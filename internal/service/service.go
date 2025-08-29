package service

import (
	"context"

	"github.com/gofreego/openauth/api/openauth_v1"
)

type Config struct {
}

type Repository interface {
	Ping(ctx context.Context) error
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
