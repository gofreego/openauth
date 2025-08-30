package main

import (
	"context"
	"flag"

	"github.com/gofreego/openauth/cmd/grpc_server"
	"github.com/gofreego/openauth/cmd/http_server"
	"github.com/gofreego/openauth/cmd/migrator"
	"github.com/gofreego/openauth/internal/configs"
	"github.com/gofreego/openauth/internal/constants"

	"github.com/gofreego/goutils/apputils"
	"github.com/gofreego/goutils/logger"
)

var (
	app  string
	env  string
	path string
)

func main() {
	flag.StringVar(&env, "env", "dev", "-env=dev")
	flag.StringVar(&path, "path", ".", "-path=./")
	flag.StringVar(&app, "app", "", "-app=<app_name>")
	flag.Parse()
	ctx := context.Background()

	conf := configs.LoadConfig(ctx, path, env)

	conf.Logger.InitiateLogger()
	logger.AddMiddleLayers(logger.RequestMiddleLayer)

	if app != "" {
		conf.AppNames = []string{app}
	}

	// starting application
	var apps []apputils.Application
	for _, appName := range conf.AppNames {
		switch appName {
		case constants.HTTP_SERVER:
			apps = append(apps, http_server.NewHTTPServer(conf))
		case constants.GRPC_SERVER:
			apps = append(apps, grpc_server.NewGRPCServer(conf))
		case constants.SQL_MIGRATOR:
			apps = append(apps, migrator.NewSQLMigrator(conf))
		default:
			logger.Panic(ctx, "invalid application name provided `%s`", appName)
		}
	}

	for _, app := range apps {
		logger.Info(ctx, "Starting %s", app.Name())
		go app.Run(ctx)
	}

	apputils.GracefulShutdown(ctx, apps...)
}
