package main

import (
	"context"
	"embed"
	"flag"
	"io/fs"
	"net/http"

	"github.com/gofreego/openauth/cmd/grpc_server"
	"github.com/gofreego/openauth/cmd/http_server"
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

//go:embed all:adminv2/dist
var adminV2Dist embed.FS

func getAdminV2UIHandler() http.Handler {
	fsys, err := fs.Sub(adminV2Dist, "adminv2/dist")
	if err != nil {
		panic(err)
	}
	indexHTML, err := fs.ReadFile(adminV2Dist, "adminv2/dist/index.html")
	if err != nil {
		panic(err)
	}
	return http_server.GetUIHandler(http.FS(fsys), indexHTML, "/openauth/admin/v2/")
}

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
			apps = append(apps, http_server.NewHTTPServer(conf, getAdminV2UIHandler()))
		case constants.GRPC_SERVER:
			apps = append(apps, grpc_server.NewGRPCServer(conf))
		default:
			logger.Panic(ctx, "invalid application name provided `%s`", appName)
		}
	}

	for _, app := range apps {
		logger.Info(ctx, "Starting %s", app.Name())
		go func(app apputils.Application) {
			if err := app.Run(ctx); err != nil {
				logger.Panic(ctx, "Failed to run %s: %s", app.Name(), err.Error())
			}
		}(app)
	}

	apputils.GracefulShutdown(ctx, apps...)
}
