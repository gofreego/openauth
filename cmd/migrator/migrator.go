package migrator

import (
	"context"
	std_sql "database/sql"

	"github.com/gofreego/goutils/databases/migrations/sql"
	"github.com/gofreego/openauth/internal/configs"
	"github.com/gofreego/openauth/internal/constants"
)

// sql db migration script

type SQLMigrator struct {
	migrator sql.Migrator
}

func NewSQLMigrator(cfg *configs.Configuration) *SQLMigrator {
	var db *std_sql.DB

	migrator, err := sql.NewMigrator(db, cfg.SQLMigrator.Path, cfg.Repository.Name)
	if err != nil {
		panic("failed to create SQL migrator, err:" + err.Error())
	}
	return &SQLMigrator{migrator: migrator}
}

// Name implements apputils.Application.
func (s *SQLMigrator) Name() string {
	return constants.SQL_MIGRATOR
}

// Run implements apputils.Application.
func (s *SQLMigrator) Run(ctx context.Context) error {
	panic("unimplemented")
}

// Shutdown implements apputils.Application.
func (s *SQLMigrator) Shutdown(ctx context.Context) {
	panic("unimplemented")
}
