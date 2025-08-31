package service

import (
	"context"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/models/dao"
)

type Config struct {
}

type Repository interface {
	Ping(ctx context.Context) error

	// Permission methods
	CreatePermission(ctx context.Context, permission *dao.Permission) (*dao.Permission, error)
	GetPermissionByID(ctx context.Context, id int64) (*dao.Permission, error)
	ListPermissions(ctx context.Context, limit, offset int32, filters map[string]interface{}) ([]*dao.Permission, int32, error)
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
	ListUsers(ctx context.Context, limit, offset int32, filters map[string]interface{}) ([]*dao.User, int32, error)
	CheckUsernameExists(ctx context.Context, username string) (bool, error)
	CheckEmailExists(ctx context.Context, email string) (bool, error)

	// Verification methods
	CreateOTPVerification(ctx context.Context, otp *dao.OTPVerification) error
	GetOTPVerification(ctx context.Context, identifier, code string) (*dao.OTPVerification, error)
	UpdateVerificationStatus(ctx context.Context, userID int64, field string, verified bool) error
	DeleteOTPVerification(ctx context.Context, identifier, otpType string) error
}

type Service struct {
	repo Repository
	openauth_v1.UnimplementedOpenAuthServer
}

func NewService(ctx context.Context, cfg *Config, repo Repository) *Service {
	return &Service{
		repo: repo,
	}
}
