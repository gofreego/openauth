package configs

import (
	"context"
	"fmt"

	"github.com/gofreego/openauth/internal/service"

	"github.com/gofreego/goutils/api/debug"
	"github.com/gofreego/goutils/configutils"
	"github.com/gofreego/goutils/databases/connections/sql"
	"github.com/gofreego/goutils/logger"
)

type Configuration struct {
	LogConfig    bool               `yaml:"LogConfig"`
	Logger       logger.Config      `yaml:"Logger"`
	ConfigReader configutils.Config `yaml:"ConfigReader"`
	AppNames     []string           `yaml:"AppNames"`
	Server       Server             `yaml:"Server" `
	Repository   sql.Config         `yaml:"Repository"`
	Service      service.Config     `yaml:"Service"`
	Debug        debug.Config       `yaml:"Debug"`
	SQLMigrator  SQLMigrator        `yaml:"SQLMigrator"`
}

type Server struct {
	GRPCPort int `yaml:"GRPCPort"`
	HTTPPort int `yaml:"HTTPPort"`
}

type MigrationAction string

const (
	Up   MigrationAction = "up"
	Down MigrationAction = "down"
)

type SQLMigrator struct {
	Path   string          `yaml:"Path"`   // Path to the SQL migration files
	Action MigrationAction `yaml:"Action"` // Migration action (up/down)
}

func LoadConfig(ctx context.Context, path string, env string) *Configuration {
	filePath := fmt.Sprintf("%s/%s.yaml", path, env)
	var conf Configuration
	err := configutils.ReadConfig(ctx, filePath, &conf)
	if err != nil {
		logger.Panic(ctx, "failed to read configs : %v", err)
	}
	// logging config for debug
	if conf.LogConfig {
		configutils.LogConfig(ctx, conf)
	}
	return &conf
}
