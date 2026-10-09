package service

import (
	"encoding/json"
	"strings"
	"testing"
	"time"
)

func validConfig() *Config {
	c := &Config{}
	c.JWT.SecretKey = strings.Repeat("k", 32)
	c.GoogleOAuth.ClientIDs = []string{"web.apps.googleusercontent.com"}
	c.Mediabase.ServiceEndpoint = "mediabase:8081"
	c.Default()
	return c
}

// Every setting survives a round trip through its stored form.
func TestSettingsRoundTrip(t *testing.T) {
	in := validConfig()
	in.JWT.AccessTokenTTL = 168 * time.Hour
	in.Security.BcryptCost = 10
	in.GoogleOAuth.ClientIDs = []string{"a", "b"}

	out := &Config{}
	for _, s := range settings {
		raw, err := json.Marshal(s.get(in))
		if err != nil {
			t.Fatalf("%s: marshal: %v", s.key, err)
		}
		if err := s.set(out, raw); err != nil {
			t.Fatalf("%s: set %s: %v", s.key, raw, err)
		}
	}
	for _, s := range settings {
		if !jsonEqual(s.get(in), s.get(out)) {
			t.Errorf("%s: got %v, want %v", s.key, s.get(out), s.get(in))
		}
	}
	if err := out.validate(); err != nil {
		t.Errorf("round-tripped config invalid: %v", err)
	}
}

func TestSettingKeysUnique(t *testing.T) {
	seen := map[string]bool{}
	for _, s := range settings {
		if seen[s.key] {
			t.Errorf("duplicate setting key %s", s.key)
		}
		seen[s.key] = true
	}
}

func TestValidate(t *testing.T) {
	cases := map[string]func(*Config){
		"short secret":   func(c *Config) { c.JWT.SecretKey = "short" },
		"zero ttl":       func(c *Config) { c.JWT.AccessTokenTTL = 0 },
		"bcrypt too low": func(c *Config) { c.Security.BcryptCost = 1 },
		"no attempts":    func(c *Config) { c.Security.MaxLoginAttempts = 0 },
		"empty client":   func(c *Config) { c.GoogleOAuth.ClientIDs = []string{"a", " "} },
		"no mediabase":   func(c *Config) { c.Mediabase.ServiceEndpoint = "" },
		"no code verb":   func(c *Config) { c.Communication.SMSVerificationMessage = "Your code" },
		"extra verb":     func(c *Config) { c.Communication.EmailVerificationBody = "%s and %d" },
	}
	for name, breakIt := range cases {
		c := validConfig()
		breakIt(c)
		if c.validate() == nil {
			t.Errorf("%s: validate passed", name)
		}
	}
	if err := validConfig().validate(); err != nil {
		t.Errorf("valid config rejected: %v", err)
	}
}

func TestCheckWrite(t *testing.T) {
	st := &settingsStore{}
	st.current.Store(&snapshot{cfg: validConfig()})

	ok := map[string]string{
		"google_oauth.client_ids": `["a","b"]`,
		"jwt.access_token_ttl":    `"15m"`,
		"security.bcrypt_cost":    `11`,
	}
	for key, raw := range ok {
		if err := st.checkWrite(key, raw); err != nil {
			t.Errorf("%s=%s rejected: %v", key, raw, err)
		}
	}
	bad := map[string]string{
		"google_oauth.client_ids": `"not a list"`,
		"jwt.access_token_ttl":    `"forever"`,
		"security.bcrypt_cost":    `99`,
		"jwt.secret_key":          `"short"`,
		"no.such.key":             `1`,
	}
	for key, raw := range bad {
		if err := st.checkWrite(key, raw); err == nil {
			t.Errorf("%s=%s accepted", key, raw)
		}
	}
	// A rejected write leaves the live settings untouched.
	if st.get().cfg.Security.BcryptCost != validConfig().Security.BcryptCost {
		t.Error("checkWrite changed the live settings")
	}
}

func TestFormatDuration(t *testing.T) {
	for d, want := range map[time.Duration]string{
		168 * time.Hour:  "168h",
		30 * time.Minute: "30m",
		90 * time.Minute: "1h30m",
		15 * time.Second: "15s",
		0:                "0s",
	} {
		if got := formatDuration(d); got != want {
			t.Errorf("formatDuration(%v) = %q, want %q", d, got, want)
		}
	}
}
