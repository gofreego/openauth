package service

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"slices"
	"strings"
	"sync"
	"sync/atomic"
	"time"

	"golang.org/x/crypto/bcrypt"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
	communicationservice "github.com/gofreego/openauth/pkg/clients/communication-service"
	mediabaseservice "github.com/gofreego/openauth/pkg/clients/mediabase-service"
)

// openauth's runtime settings (JWT, security, Google audiences, downstream
// endpoints, message templates) live in the database under one config
// entity, editable from the admin settings page by holders of the entity's
// write permission. The YAML keeps only what's needed to reach the database
// and serve; every instance reads the settings at start and re-reads them
// periodically, so a change reaches all pods within one refresh interval.

const (
	// SettingsEntity is the config entity openauth's own settings live under.
	SettingsEntity = "openauth"

	// maskedValue stands in for sensitive values in API reads. Writing it
	// back leaves the stored value as it is.
	maskedValue = "********"

	defaultSettingsRefreshInterval = time.Minute
)

// setting is one runtime setting: its config key, how it's shown in the
// admin UI, and how it maps onto Config.
type setting struct {
	key         string
	name        string
	description string
	typ         dao.ValueType
	sensitive   bool
	// get returns the setting's value in c, as stored (JSON-marshalled).
	get func(c *Config) any
	// set decodes a stored value into c.
	set func(c *Config, raw json.RawMessage) error
}

func stringSetting(key, name, description string, field func(*Config) *string) setting {
	return setting{
		key: key, name: name, description: description, typ: dao.ValueTypeString,
		get: func(c *Config) any { return *field(c) },
		set: func(c *Config, raw json.RawMessage) error { return json.Unmarshal(raw, field(c)) },
	}
}

func intSetting(key, name, description string, field func(*Config) *int) setting {
	return setting{
		key: key, name: name, description: description, typ: dao.ValueTypeInt,
		get: func(c *Config) any { return *field(c) },
		set: func(c *Config, raw json.RawMessage) error { return json.Unmarshal(raw, field(c)) },
	}
}

// durationSetting stores a duration as a Go duration string, e.g. "168h".
func durationSetting(key, name, description string, field func(*Config) *time.Duration) setting {
	return setting{
		key: key, name: name, description: description, typ: dao.ValueTypeString,
		get: func(c *Config) any { return formatDuration(*field(c)) },
		set: func(c *Config, raw json.RawMessage) error {
			var s string
			if err := json.Unmarshal(raw, &s); err != nil {
				return err
			}
			d, err := time.ParseDuration(s)
			if err != nil {
				return err
			}
			*field(c) = d
			return nil
		},
	}
}

// stringListSetting stores a list as a JSON array of strings.
func stringListSetting(key, name, description string, field func(*Config) *[]string) setting {
	return setting{
		key: key, name: name, description: description, typ: dao.ValueTypeJSON,
		get: func(c *Config) any {
			if *field(c) == nil {
				return []string{}
			}
			return *field(c)
		},
		set: func(c *Config, raw json.RawMessage) error {
			var list []string
			if err := json.Unmarshal(raw, &list); err != nil {
				return err
			}
			*field(c) = list
			return nil
		},
	}
}

var settings = []setting{
	func() setting {
		s := stringSetting("jwt.secret_key", "JWT secret key",
			"Signs every access and refresh token (HS256, at least 32 characters). Changing it signs everyone out.",
			func(c *Config) *string { return &c.JWT.SecretKey })
		s.sensitive = true
		return s
	}(),
	durationSetting("jwt.access_token_ttl", "Access token lifetime",
		"How long an access token is valid, as a duration like 15m or 168h.",
		func(c *Config) *time.Duration { return &c.JWT.AccessTokenTTL }),
	durationSetting("jwt.refresh_token_ttl", "Refresh token lifetime",
		"How long a refresh token is valid, as a duration like 168h.",
		func(c *Config) *time.Duration { return &c.JWT.RefreshTokenTTL }),
	intSetting("security.bcrypt_cost", "Password hashing cost",
		fmt.Sprintf("bcrypt cost for new password hashes (%d–%d); higher is slower and stronger.", bcrypt.MinCost, bcrypt.MaxCost),
		func(c *Config) *int { return &c.Security.BcryptCost }),
	intSetting("security.max_login_attempts", "Max login attempts",
		"Failed password attempts before the account is locked.",
		func(c *Config) *int { return &c.Security.MaxLoginAttempts }),
	durationSetting("security.lockout_duration", "Lockout duration",
		"How long a locked account stays locked, as a duration like 30m.",
		func(c *Config) *time.Duration { return &c.Security.LockoutDuration }),
	stringListSetting("google_oauth.client_ids", "Google client IDs",
		`OAuth client IDs accepted as a Google ID token's audience, as a JSON array — the web/server client plus each native client (e.g. iOS), whose tokens carry their own client ID. An empty array turns Google sign-in off.`,
		func(c *Config) *[]string { return &c.GoogleOAuth.ClientIDs }),
	stringSetting("mediabase.service_endpoint", "Mediabase endpoint",
		"gRPC address of mediabase, used for profile picture uploads.",
		func(c *Config) *string { return &c.Mediabase.ServiceEndpoint }),
	stringSetting("mediabase.bucket_name", "Mediabase bucket",
		"Bucket profile pictures are uploaded to.",
		func(c *Config) *string { return &c.Mediabase.BucketName }),
	stringSetting("communication.service_endpoint", "Communication endpoint",
		"Address of the communication service that sends verification emails and SMS.",
		func(c *Config) *string { return &c.Communication.ServiceEndpoint }),
	stringSetting("communication.email_verification_subject", "Verification email subject",
		"Subject of the email-verification message.",
		func(c *Config) *string { return &c.Communication.EmailVerificationSubject }),
	stringSetting("communication.email_verification_body", "Verification email body",
		"Body of the email-verification message; %s is replaced with the code.",
		func(c *Config) *string { return &c.Communication.EmailVerificationBody }),
	stringSetting("communication.sms_verification_message", "Verification SMS",
		"Text of the phone-verification SMS; %s is replaced with the code.",
		func(c *Config) *string { return &c.Communication.SMSVerificationMessage }),
}

func settingByKey(key string) (setting, bool) {
	i := slices.IndexFunc(settings, func(s setting) bool { return s.key == key })
	if i < 0 {
		return setting{}, false
	}
	return settings[i], true
}

func settingKeys() []string {
	keys := make([]string, len(settings))
	for i, s := range settings {
		keys[i] = s.key
	}
	return keys
}

// clone copies c deeply enough that changing the copy leaves c untouched.
func (c *Config) clone() *Config {
	cp := *c
	cp.GoogleOAuth.ClientIDs = slices.Clone(c.GoogleOAuth.ClientIDs)
	return &cp
}

// validate rejects settings openauth can't safely run with.
func (c *Config) validate() error {
	var errs []string
	if len(c.JWT.SecretKey) < 32 {
		errs = append(errs, "jwt.secret_key must be at least 32 characters")
	}
	if c.JWT.AccessTokenTTL <= 0 {
		errs = append(errs, "jwt.access_token_ttl must be positive")
	}
	if c.JWT.RefreshTokenTTL <= 0 {
		errs = append(errs, "jwt.refresh_token_ttl must be positive")
	}
	if c.Security.BcryptCost < bcrypt.MinCost || c.Security.BcryptCost > bcrypt.MaxCost {
		errs = append(errs, fmt.Sprintf("security.bcrypt_cost must be between %d and %d", bcrypt.MinCost, bcrypt.MaxCost))
	}
	if c.Security.MaxLoginAttempts < 1 {
		errs = append(errs, "security.max_login_attempts must be at least 1")
	}
	if c.Security.LockoutDuration < 0 {
		errs = append(errs, "security.lockout_duration can't be negative")
	}
	if slices.ContainsFunc(c.GoogleOAuth.ClientIDs, func(id string) bool { return strings.TrimSpace(id) == "" }) {
		errs = append(errs, "google_oauth.client_ids can't contain an empty ID")
	}
	if strings.TrimSpace(c.Mediabase.ServiceEndpoint) == "" {
		errs = append(errs, "mediabase.service_endpoint is required")
	}
	if strings.TrimSpace(c.Mediabase.BucketName) == "" {
		errs = append(errs, "mediabase.bucket_name is required")
	}
	for key, template := range map[string]string{
		"communication.email_verification_body":  c.Communication.EmailVerificationBody,
		"communication.sms_verification_message": c.Communication.SMSVerificationMessage,
	} {
		if strings.Count(template, "%s") != 1 || strings.Count(template, "%") != 1 {
			errs = append(errs, key+" must contain exactly one %s (for the code) and no other %")
		}
	}
	if len(errs) > 0 {
		slices.Sort(errs)
		return fmt.Errorf("%s", strings.Join(errs, "; "))
	}
	return nil
}

// snapshot is one consistent view of the settings and the clients built
// from them, swapped as a whole on change.
type snapshot struct {
	cfg           *Config
	communication communicationservice.Client
	mediabase     mediabaseservice.Client
}

// settingsStore holds the current snapshot and keeps it fresh. One per
// process, shared by the HTTP and gRPC servers.
type settingsStore struct {
	repo     Repository
	current  atomic.Pointer[snapshot]
	reloadMu sync.Mutex
}

var (
	storeOnce   sync.Once
	sharedStore *settingsStore
)

// getSettingsStore returns the process's settings store, creating it on
// first use: it seeds any setting missing from the database (from the
// legacy YAML values in seed, else defaults), loads them, and starts the
// periodic refresh. It panics if the settings can't be loaded, since
// openauth can't authenticate anyone without them.
func getSettingsStore(ctx context.Context, seed *Config, repo Repository) *settingsStore {
	storeOnce.Do(func() {
		st := &settingsStore{repo: repo}
		if err := st.seed(ctx, seed); err != nil {
			logger.Panic(ctx, "failed to seed openauth settings: %v", err)
		}
		if err := st.reload(ctx); err != nil {
			logger.Panic(ctx, "failed to load openauth settings: %v", err)
		}
		interval := seed.SettingsRefreshInterval
		if interval <= 0 {
			interval = defaultSettingsRefreshInterval
		}
		go st.refreshEvery(ctx, interval)
		sharedStore = st
	})
	return sharedStore
}

func (st *settingsStore) get() *snapshot { return st.current.Load() }

// seed creates the settings entity and every setting missing from it.
// Existing values are never overwritten: after the first start the database
// is the source of truth.
func (st *settingsStore) seed(ctx context.Context, legacy *Config) error {
	initial := legacy.clone()
	if initial.JWT.SecretKey == "" || initial.JWT.SecretKey == constants.DefaultJWTSecretKey {
		secret, err := randomSecret()
		if err != nil {
			return err
		}
		initial.JWT.SecretKey = secret
	}
	initial.Default()

	admin, err := st.repo.GetUserByUsername(ctx, "admin")
	if err != nil || admin == nil {
		return fmt.Errorf("the admin user, recorded as the settings' creator, wasn't found: %v", err)
	}

	entity, err := st.repo.GetConfigEntityByName(ctx, SettingsEntity)
	if err != nil {
		return err
	}
	if entity == nil {
		readPerm, err := st.repo.GetPermissionByName(ctx, constants.PermissionOpenAuthConfigRead)
		if err != nil || readPerm == nil {
			return fmt.Errorf("permission %s not found: %v", constants.PermissionOpenAuthConfigRead, err)
		}
		writePerm, err := st.repo.GetPermissionByName(ctx, constants.PermissionOpenAuthConfigEdit)
		if err != nil || writePerm == nil {
			return fmt.Errorf("permission %s not found: %v", constants.PermissionOpenAuthConfigEdit, err)
		}
		now := time.Now().UnixMilli()
		entity = &dao.ConfigEntity{
			Name:        SettingsEntity,
			DisplayName: "OpenAuth",
			Description: "OpenAuth's runtime settings. Changes reach every instance within a minute.",
			ReadPerm:    readPerm.ID,
			WritePerm:   writePerm.ID,
			CreatedBy:   admin.ID,
			CreatedAt:   now,
			UpdatedAt:   now,
		}
		if err := st.repo.CreateConfigEntity(ctx, entity); err != nil {
			return err
		}
		logger.Info(ctx, "Created the %q settings entity", SettingsEntity)
	}

	existing, err := st.repo.GetConfigsByEntityNameAndKeys(ctx, SettingsEntity, settingKeys())
	if err != nil {
		return err
	}
	for _, s := range settings {
		if _, ok := existing[s.key]; ok {
			continue
		}
		now := time.Now().UnixMilli()
		row := &dao.Config{
			EntityID:    entity.ID,
			Key:         s.key,
			DisplayName: s.name,
			Description: s.description,
			Type:        s.typ,
			CreatedBy:   admin.ID,
			UpdatedBy:   admin.ID,
			CreatedAt:   now,
			UpdatedAt:   now,
		}
		if err := row.SetValue(s.get(initial)); err != nil {
			return err
		}
		if err := st.repo.CreateConfig(ctx, row); err != nil {
			return err
		}
		logger.Info(ctx, "Seeded setting %s", s.key)
	}
	return nil
}

// load reads the settings from the database into a validated Config.
func (st *settingsStore) load(ctx context.Context) (*Config, error) {
	rows, err := st.repo.GetConfigsByEntityNameAndKeys(ctx, SettingsEntity, settingKeys())
	if err != nil {
		return nil, err
	}
	cfg := &Config{}
	cfg.Default()
	for _, s := range settings {
		row, ok := rows[s.key]
		if !ok {
			return nil, fmt.Errorf("setting %s is missing", s.key)
		}
		if err := s.set(cfg, json.RawMessage(row.Value)); err != nil {
			return nil, fmt.Errorf("setting %s has an invalid value: %w", s.key, err)
		}
	}
	if err := cfg.validate(); err != nil {
		return nil, err
	}
	return cfg, nil
}

// reload re-reads the settings and swaps them in, rebuilding a client only
// when its endpoint changed. On error the current snapshot stays in place.
func (st *settingsStore) reload(ctx context.Context) error {
	st.reloadMu.Lock()
	defer st.reloadMu.Unlock()

	cfg, err := st.load(ctx)
	if err != nil {
		return err
	}
	next := &snapshot{cfg: cfg}
	prev := st.get()

	if prev != nil && prev.cfg.Communication.ServiceEndpoint == cfg.Communication.ServiceEndpoint {
		next.communication = prev.communication
	} else {
		next.communication = communicationservice.NewClient(cfg.Communication.ServiceEndpoint)
	}
	if prev != nil && prev.mediabase != nil && prev.cfg.Mediabase.ServiceEndpoint == cfg.Mediabase.ServiceEndpoint {
		next.mediabase = prev.mediabase
	} else {
		mediabase, err := mediabaseservice.NewClient(cfg.Mediabase.ServiceEndpoint)
		if err != nil {
			// Profile pictures fail until the next successful reload.
			logger.Error(ctx, "Failed to initialize mediabase client: %v", err)
		}
		next.mediabase = mediabase
	}

	st.current.Store(next)

	if prev != nil {
		if prev.mediabase != nil && prev.mediabase != next.mediabase {
			prev.mediabase.Close()
		}
		for _, s := range settings {
			before, after := s.get(prev.cfg), s.get(cfg)
			if !jsonEqual(before, after) {
				logger.Info(ctx, "Setting %s changed", s.key)
			}
		}
	}
	return nil
}

func (st *settingsStore) refreshEvery(ctx context.Context, interval time.Duration) {
	ticker := time.NewTicker(interval)
	defer ticker.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			if err := st.reload(ctx); err != nil {
				logger.Error(ctx, "Failed to refresh openauth settings, keeping the current ones: %v", err)
			}
		}
	}
}

// checkWrite validates writing raw to setting key, against the current
// settings, so a bad value is refused before it's stored rather than at
// the next refresh.
func (st *settingsStore) checkWrite(key string, raw string) error {
	s, ok := settingByKey(key)
	if !ok {
		return fmt.Errorf("%q isn't an openauth setting", key)
	}
	cfg := st.get().cfg.clone()
	if err := s.set(cfg, json.RawMessage(raw)); err != nil {
		return fmt.Errorf("invalid value for %s: %w", key, err)
	}
	return cfg.validate()
}

func jsonEqual(a, b any) bool {
	ja, _ := json.Marshal(a)
	jb, _ := json.Marshal(b)
	return string(ja) == string(jb)
}

// formatDuration is d as a Go duration string without trailing zero units:
// "168h", not "168h0m0s".
func formatDuration(d time.Duration) string {
	out := d.String()
	if strings.HasSuffix(out, "m0s") {
		out = strings.TrimSuffix(out, "0s")
	}
	if strings.HasSuffix(out, "h0m") {
		out = strings.TrimSuffix(out, "0m")
	}
	return out
}

func randomSecret() (string, error) {
	b := make([]byte, 32)
	if _, err := rand.Read(b); err != nil {
		return "", fmt.Errorf("failed to generate a JWT secret: %w", err)
	}
	return hex.EncodeToString(b), nil
}

// isSensitiveSetting reports whether the config row is a setting whose
// value must never be returned by the API.
func isSensitiveSetting(entityName, key string) bool {
	if entityName != SettingsEntity {
		return false
	}
	s, ok := settingByKey(key)
	return ok && s.sensitive
}
