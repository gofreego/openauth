package migrator

import (
	"context"
	std_sql "database/sql"
	"fmt"

	"github.com/gofreego/goutils/databases"
	"github.com/gofreego/goutils/databases/connections/sql/pgsql"
	"github.com/gofreego/goutils/databases/migrations/sql"
	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/internal/configs"
	"github.com/gofreego/openauth/internal/constants"
)

// sql db migration script

type SQLMigrator struct {
	migrator sql.Migrator
	cfg      configs.SQLMigrator
}

func NewSQLMigrator(cfg *configs.Configuration) *SQLMigrator {
	var db *std_sql.DB
	var err error
	switch cfg.Repository.Name {
	case databases.Postgres:
		db, err = pgsql.GetConnection(&cfg.Repository.Postgres.Primary)
		if err != nil {
			panic("failed to get Postgres connection, err:" + err.Error())
		}
	default:
		panic(fmt.Sprintf("unsupported database for migration: %s, expected: %s", cfg.Repository.Name, databases.Postgres))
	}

	migrator, err := sql.NewMigrator(db, cfg.SQLMigrator.Path, cfg.Repository.Name)
	if err != nil {
		panic(fmt.Sprintf("failed to create SQL migrator, err: %s", err.Error()))
	}
	return &SQLMigrator{migrator: migrator, cfg: cfg.SQLMigrator}
}

// Name implements apputils.Application.
func (s *SQLMigrator) Name() string {
	return constants.SQL_MIGRATOR
}

// Run implements apputils.Application.
func (s *SQLMigrator) Run(ctx context.Context) error {
	defer s.migrator.Close()

	var err error
	switch s.cfg.Action {
	case configs.Up:
		err = s.migrator.Migrate(ctx)
		if err != nil {
			logger.Error(ctx, "Failed to migrate database: %s", err.Error())
			return err
		}
	case configs.Down:
		err = s.migrator.Rollback(ctx)
		if err != nil {
			logger.Error(ctx, "Failed to rollback database: %s", err.Error())
			return err
		}
	case configs.Force:
		err = s.migrator.Force(s.cfg.ForceVersion)
		if err != nil {
			logger.Error(ctx, "Failed to force migrate database: %s", err.Error())
			return err
		}
	default:
		logger.Error(ctx, "Unknown migration action: %s, Expected: %s | %s", s.cfg.Action, configs.Up, configs.Down)
	}
	version, dirty, err := s.migrator.Version()
	if err != nil {
		logger.Error(ctx, "Failed to get database version: %s", err.Error())
		return err
	}
	logger.Info(ctx, "Database version: %d, dirty: %t", version, dirty)
	return nil
}

// Shutdown implements apputils.Application.
func (s *SQLMigrator) Shutdown(ctx context.Context) {
	// Close the migrator connection
	if err := s.migrator.Close(); err != nil {
		// Log the error but don't panic during shutdown
		logger.Warn(ctx, "Warning: failed to close migrator: %s", err.Error())
	}
}
