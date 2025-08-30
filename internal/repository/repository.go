package repository

import (
	"context"
	"sync"

	"github.com/gofreego/goutils/databases"
	"github.com/gofreego/goutils/databases/connections/sql"
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
		return instance
	}
	mu.RUnlock()

	once.Do(func() {
		mu.Lock()
		defer mu.Unlock()
		if instance == nil {
			switch cfg.Name {
			case databases.Postgres:
				repo, err := postgresql.NewRepository(ctx, cfg)
				if err != nil {
					panic("failed to create repository: " + err.Error())
				}
				instance = repo
			}
		}
	})

	return instance
}
