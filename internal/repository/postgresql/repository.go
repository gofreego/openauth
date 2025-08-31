package postgresql

import (
	"context"

	sqlutils "github.com/gofreego/goutils/databases/connections/sql"
)

type Repository struct {
	connManager sqlutils.DBManager
}

func NewRepository(ctx context.Context, cfg *sqlutils.Config) (*Repository, error) {
	connManager, err := sqlutils.NewDBManager(cfg)
	if err != nil {
		return nil, err
	}
	return &Repository{connManager: connManager}, nil
}

// Ping implements service.Repository.
func (r *Repository) Ping(ctx context.Context) error {
	return r.connManager.Primary().Ping()
}
