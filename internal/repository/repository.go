package repository

import (
	"context"
	"sync"

	"github.com/gofreego/goutils/databases"
	"github.com/gofreego/goutils/databases/connections/sql"
	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/internal/repository/postgresql"
	"github.com/gofreego/openauth/internal/service"
)

var (
	instance service.Repository
	once     sync.Once
	mu       sync.RWMutex
)

// GetInstance returns the singleton instance of the repository
func GetInstance(ctx context.Context, cfg *sql.Config) service.Repository {
	mu.RLock()
	if instance != nil {
		defer mu.RUnlock()
		logger.Debug(ctx, "Returning existing repository instance")
		return instance
	}
	mu.RUnlock()

	once.Do(func() {
		mu.Lock()
		defer mu.Unlock()
		if instance == nil {
			logger.Info(ctx, "Initializing repository instance with database: %s", cfg.Name)
			switch cfg.Name {
			case databases.Postgres:
				repo, err := postgresql.NewRepository(ctx, cfg)
				if err != nil {
					logger.Panic(ctx, "Failed to create PostgreSQL repository: %v", err)
				}
				instance = repo
				logger.Info(ctx, "PostgreSQL repository initialized successfully")
			default:
				logger.Panic(ctx, "Unsupported database type: %s", cfg.Name)
			}
		}
	})

	return instance
}
