package service

import (
	"context"
	"time"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	communicationservice "github.com/gofreego/openauth/pkg/clients/communication-service"
	"github.com/google/uuid"
)

type Config struct {
	JWT           JWTConfig           `yaml:"JWT"`
	Security      SecurityConfig      `yaml:"Security"`
	Communication CommunicationConfig `yaml:"Communication"`
}

func (c *Config) Default() {
	c.JWT.Default()
	c.Security.Default()
	c.Communication.Default()
}

type CommunicationConfig struct {
	ServiceEndpoint          string `yaml:"ServiceEndpoint"`
	EmailVerificationSubject string `yaml:"EmailVerificationSubject"`
	EmailVerificationBody    string `yaml:"EmailVerificationBody"`
	SMSVerificationMessage   string `yaml:"SMSVerificationMessage"`
}

func (c *CommunicationConfig) Default() {
	if c.EmailVerificationSubject == "" {
		c.EmailVerificationSubject = constants.DefaultEmailVerificationSubject
	}
	if c.EmailVerificationBody == "" {
		c.EmailVerificationBody = constants.DefaultEmailVerificationBody
	}
	if c.SMSVerificationMessage == "" {
		c.SMSVerificationMessage = constants.DefaultSMSVerificationMessage
	}
}

type JWTConfig struct {
	SecretKey       string        `yaml:"SecretKey"`       // JWT signing secret key
	AccessTokenTTL  time.Duration `yaml:"AccessTokenTTL"`  // Access token expiration time
	RefreshTokenTTL time.Duration `yaml:"RefreshTokenTTL"` // Refresh token expiration time
}

func (c *JWTConfig) Default() {
	if c.SecretKey == "" {
		c.SecretKey = constants.DefaultJWTSecretKey
	}
	if c.AccessTokenTTL == 0 {
		c.AccessTokenTTL = constants.DefaultAccessTokenTTL
	}
	if c.RefreshTokenTTL == 0 {
		c.RefreshTokenTTL = constants.DefaultRefreshTokenTTL
	}
}

type SecurityConfig struct {
	BcryptCost       int           `yaml:"BcryptCost"`       // Password hashing cost
	MaxLoginAttempts int           `yaml:"MaxLoginAttempts"` // Maximum failed login attempts
	LockoutDuration  time.Duration `yaml:"LockoutDuration"`  // Account lockout duration
}

func (c *SecurityConfig) Default() {
	if c.BcryptCost == 0 {
		c.BcryptCost = constants.DefaultBcryptCost
	}
	if c.MaxLoginAttempts == 0 {
		c.MaxLoginAttempts = constants.DefaultMaxLoginAttempts
	}
	if c.LockoutDuration == 0 {
		c.LockoutDuration = constants.DefaultLockoutDuration
	}
}

type Repository interface {
	Ping(ctx context.Context) error

	// Permission methods
	CreatePermission(ctx context.Context, permission *dao.Permission) (*dao.Permission, error)
	GetPermissionByID(ctx context.Context, id int64) (*dao.Permission, error)
	ListPermissions(ctx context.Context, filters *filter.PermissionFilter) ([]*dao.Permission, error)
	UpdatePermission(ctx context.Context, id int64, updates map[string]interface{}) (*dao.Permission, error)
	DeletePermission(ctx context.Context, id int64) error
	GetPermissionByName(ctx context.Context, name string) (*dao.Permission, error)

	// User methods
	CreateUser(ctx context.Context, user *dao.User) (*dao.User, error)
	CreateUserProfile(ctx context.Context, profile *dao.Profile) (*dao.Profile, error)
	GetUserByID(ctx context.Context, id int64) (*dao.User, error)
	GetUserByUUID(ctx context.Context, uuid string) (*dao.User, error)
	GetUserByUsername(ctx context.Context, username string) (*dao.User, error)
	GetUserByEmail(ctx context.Context, email string) (*dao.User, error)
	GetUserByPhone(ctx context.Context, identifier string) (*dao.User, error)
	GetUserProfile(ctx context.Context, userID int64) (*dao.Profile, error)
	UpdateUser(ctx context.Context, id int64, updates map[string]interface{}) (*dao.User, error)
	UpdateUserProfile(ctx context.Context, userID int64, updates map[string]interface{}) (*dao.Profile, error)
	DeleteUser(ctx context.Context, id int64, softDelete bool) error
	ListUsers(ctx context.Context, filters *filter.UserFilter) ([]*dao.User, error)
	CheckUsernameExists(ctx context.Context, username string) (bool, error)
	CheckEmailExists(ctx context.Context, email string) (bool, error)

	// Profile management methods
	ListUserProfiles(ctx context.Context, filters *filter.UserProfilesFilter) ([]*dao.Profile, error)
	ListUserProfileUUIDs(ctx context.Context, userID int64) ([]uuid.UUID, error)
	GetProfileByUUID(ctx context.Context, uuid string) (*dao.Profile, error)
	UpdateProfileByUUID(ctx context.Context, uuid string, updates map[string]interface{}) (*dao.Profile, error)
	CountUserProfiles(ctx context.Context, userUUID string) (int32, error)
	DeleteProfileByUUID(ctx context.Context, uuid string) error

	// Verification methods
	CreateOTPVerification(ctx context.Context, otp *dao.OTPVerification) error
	GetOTPVerification(ctx context.Context, identifier, code string) (*dao.OTPVerification, error)
	UpdateVerificationStatus(ctx context.Context, userID int64, field string, verified bool) error
	DeleteOTPVerification(ctx context.Context, identifier, otpType string) error

	// Session management methods
	CreateSession(ctx context.Context, session *dao.Session) (*dao.Session, error)
	GetSessionByToken(ctx context.Context, sessionToken string) (*dao.Session, error)
	GetSessionByUUID(ctx context.Context, sessionUUID string) (*dao.Session, error)
	GetSessionByRefreshToken(ctx context.Context, refreshToken string) (*dao.Session, error)
	UpdateSession(ctx context.Context, sessionUUID string, updates map[string]interface{}) (*dao.Session, error)
	DeleteSession(ctx context.Context, sessionUUID string) error
	DeleteUserSessions(ctx context.Context, userUUID string) error
	ListUserSessions(ctx context.Context, filters *filter.UserSessionsFilter) ([]*dao.Session, error)
	UpdateLastActivity(ctx context.Context, sessionUUID string) error

	// Group methods
	CreateGroup(ctx context.Context, group *dao.Group) (*dao.Group, error)
	GetGroupByID(ctx context.Context, id int64) (*dao.Group, error)
	GetGroupByUUID(ctx context.Context, uuid string) (*dao.Group, error)
	GetGroupByName(ctx context.Context, name string) (*dao.Group, error)
	ListGroups(ctx context.Context, filters *filter.GroupFilter) ([]*dao.Group, error)
	UpdateGroup(ctx context.Context, id int64, updates map[string]interface{}) (*dao.Group, error)
	DeleteGroup(ctx context.Context, id int64) error
	CheckGroupNameExists(ctx context.Context, name string) (bool, error)

	// Group membership methods
	AssignUserToGroup(ctx context.Context, userID, groupID int64, assignedBy int64, expiresAt *int64) error
	RemoveUserFromGroup(ctx context.Context, userID, groupID int64) error
	ListGroupUsers(ctx context.Context, filters *filter.GroupUsersFilter) ([]*dao.User, error)
	ListUserGroups(ctx context.Context, filters *filter.UserGroupsFilter) ([]*dao.Group, error)
	IsUserInGroup(ctx context.Context, userID, groupID int64) (bool, error)

	// Group permission methods
	AssignPermissionToGroup(ctx context.Context, groupID, permissionID, grantedBy int64) error
	RemovePermissionFromGroup(ctx context.Context, groupID, permissionID int64) error
	ListGroupPermissions(ctx context.Context, groupId int64) ([]*dao.EffectivePermission, error)
	IsPermissionAssignedToGroup(ctx context.Context, groupID, permissionID int64) (bool, error)

	// User permission methods
	AssignPermissionToUser(ctx context.Context, userID, permissionID, grantedBy int64, expiresAt *int64) error
	RemovePermissionFromUser(ctx context.Context, userID, permissionID int64) error
	ListUserPermissions(ctx context.Context, userId int64) ([]*dao.EffectivePermission, error)
	GetUserEffectivePermissions(ctx context.Context, userId int64) ([]*dao.EffectivePermission, error)
	IsPermissionAssignedToUser(ctx context.Context, userID, permissionID int64) (bool, error)
	GetUserEffectivePermissionNames(ctx context.Context, userId int64) ([]string, error)
	// Stats methods
	GetTotalUsers(ctx context.Context) (int64, error)
	GetTotalPermissions(ctx context.Context) (int64, error)
	GetTotalGroups(ctx context.Context) (int64, error)
	GetActiveUsers(ctx context.Context) (int64, error)
}

type Service struct {
	repo Repository
	cfg  *Config
	openauth_v1.UnimplementedOpenAuthServer
	communicationClient communicationservice.Client
}

func NewService(ctx context.Context, cfg *Config, repo Repository) *Service {
	cfg.Communication.Default()
	logger.Info(ctx, "Initializing OpenAuth Service with config: JWT TTL=%v, Security BcryptCost=%d",
		cfg.JWT.AccessTokenTTL, cfg.Security.BcryptCost)
	return &Service{
		repo:                repo,
		cfg:                 cfg,
		communicationClient: communicationservice.NewClient(cfg.Communication.ServiceEndpoint),
	}
}
