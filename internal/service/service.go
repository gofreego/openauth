package service

import (
	"context"
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
)

type Config struct {
	JWT      JWTConfig      `yaml:"JWT"`
	Security SecurityConfig `yaml:"Security"`
}

type JWTConfig struct {
	SecretKey       string        `yaml:"SecretKey"`       // JWT signing secret key
	AccessTokenTTL  time.Duration `yaml:"AccessTokenTTL"`  // Access token expiration time
	RefreshTokenTTL time.Duration `yaml:"RefreshTokenTTL"` // Refresh token expiration time
}

// GetSecretKey returns the JWT secret key
func (j *JWTConfig) GetSecretKey() []byte {
	if j.SecretKey != "" {
		return []byte(j.SecretKey)
	}
	// Default fallback (not recommended for production)
	return []byte(constants.DefaultJWTSecretKey)
}

// GetAccessTokenTTL returns the access token TTL with default fallback
func (j *JWTConfig) GetAccessTokenTTL() time.Duration {
	if j.AccessTokenTTL > 0 {
		return j.AccessTokenTTL
	}
	return constants.DefaultAccessTokenTTL
}

// GetRefreshTokenTTL returns the refresh token TTL with default fallback
func (j *JWTConfig) GetRefreshTokenTTL() time.Duration {
	if j.RefreshTokenTTL > 0 {
		return j.RefreshTokenTTL
	}
	return constants.DefaultRefreshTokenTTL
}

type SecurityConfig struct {
	BcryptCost       int           `yaml:"BcryptCost"`       // Password hashing cost
	MaxLoginAttempts int           `yaml:"MaxLoginAttempts"` // Maximum failed login attempts
	LockoutDuration  time.Duration `yaml:"LockoutDuration"`  // Account lockout duration
}

// GetBcryptCost returns the bcrypt cost with default fallback
func (s *SecurityConfig) GetBcryptCost() int {
	if s.BcryptCost > 0 {
		return s.BcryptCost
	}
	return constants.DefaultBcryptCost
}

// GetMaxLoginAttempts returns the maximum login attempts with default fallback
func (s *SecurityConfig) GetMaxLoginAttempts() int {
	if s.MaxLoginAttempts > 0 {
		return s.MaxLoginAttempts
	}
	return constants.DefaultMaxLoginAttempts
}

// GetLockoutDuration returns the lockout duration with default fallback
func (s *SecurityConfig) GetLockoutDuration() time.Duration {
	if s.LockoutDuration > 0 {
		return s.LockoutDuration
	}
	return constants.DefaultLockoutDuration
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
	GetUserProfile(ctx context.Context, userID int64) (*dao.Profile, error)
	UpdateUser(ctx context.Context, id int64, updates map[string]interface{}) (*dao.User, error)
	UpdateUserProfile(ctx context.Context, userID int64, updates map[string]interface{}) (*dao.Profile, error)
	DeleteUser(ctx context.Context, id int64, softDelete bool) error
	ListUsers(ctx context.Context, filters *filter.UserFilter) ([]*dao.User, error)
	CheckUsernameExists(ctx context.Context, username string) (bool, error)
	CheckEmailExists(ctx context.Context, email string) (bool, error)

	// Profile management methods
	ListUserProfiles(ctx context.Context, filters *filter.UserProfilesFilter) ([]*dao.Profile, error)
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
	AssignUserToGroup(ctx context.Context, userID, groupID int64, assignedBy *int64, expiresAt *int64) error
	RemoveUserFromGroup(ctx context.Context, userID, groupID int64) error
	ListGroupUsers(ctx context.Context, filters *filter.GroupUsersFilter) ([]*dao.User, error)
	ListUserGroups(ctx context.Context, filters *filter.UserGroupsFilter) ([]*dao.Group, error)
	IsUserInGroup(ctx context.Context, userID, groupID int64) (bool, error)

	// Group permission methods
	AssignPermissionToGroup(ctx context.Context, groupID, permissionID, grantedBy int64) (*dao.GroupPermission, error)
	RemovePermissionFromGroup(ctx context.Context, groupID, permissionID int64) error
	ListGroupPermissions(ctx context.Context, filters *filter.GroupPermissionFilter) ([]*dao.GroupPermission, error)
	IsPermissionAssignedToGroup(ctx context.Context, groupID, permissionID int64) (bool, error)

	// User permission methods
	AssignPermissionToUser(ctx context.Context, userID, permissionID, grantedBy int64, expiresAt *int64) (*dao.UserPermission, error)
	RemovePermissionFromUser(ctx context.Context, userID, permissionID int64) error
	ListUserPermissions(ctx context.Context, filters *filter.UserPermissionFilter) ([]*dao.UserPermission, error)
	GetUserEffectivePermissions(ctx context.Context, filters *filter.UserEffectivePermissionFilter) ([]*dao.Permission, error)
	IsPermissionAssignedToUser(ctx context.Context, userID, permissionID int64) (bool, error)

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
}

func NewService(ctx context.Context, cfg *Config, repo Repository) *Service {
	return &Service{
		repo: repo,
		cfg:  cfg,
	}
}
