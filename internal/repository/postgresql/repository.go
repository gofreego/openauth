package postgresql

import (
	"context"

	"github.com/gofreego/goutils/databases/connections/sql"
)

type Repository struct {
	connManager sql.DBManager
}

func NewRepository(ctx context.Context, cfg *sql.Config) (*Repository, error) {
	connManager, err := sql.NewDBManager(cfg)
	if err != nil {
		return nil, err
	}
	return &Repository{connManager: connManager}, nil
}

// Ping implements service.Repository.
func (r *Repository) Ping(ctx context.Context) error {
	return r.connManager.Primary().Ping()
}
