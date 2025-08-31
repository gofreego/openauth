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
