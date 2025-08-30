package migrator

import (
	"context"

	"github.com/gofreego/openauth/internal/configs"
	"github.com/gofreego/openauth/internal/constants"
)

// sql db migration script

type SQLMigrator struct {
}

func NewSQLMigrator(cfg *configs.Configuration) *SQLMigrator {
	return &SQLMigrator{}
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
