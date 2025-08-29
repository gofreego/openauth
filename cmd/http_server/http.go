package http_server

import (
	"context"
	"fmt"
	"net/http"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/configs"
	"github.com/gofreego/openauth/internal/repository"
	"github.com/gofreego/openauth/internal/service"
	"github.com/gofreego/openauth/pkg/utils"

	"github.com/gofreego/goutils/logger"
	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
)

type HTTPServer struct {
	cfg    *configs.Configuration
	server *http.Server
}

func (a *HTTPServer) Name() string {
	return "HTTP_Server"
}

func (a *HTTPServer) Shutdown(ctx context.Context) {
	if err := a.server.Shutdown(ctx); err != nil {
		logger.Panic(ctx, "failed to shutdown %s : %v", a.Name(), err)
	}
}

func NewHTTPServer(cfg *configs.Configuration) *HTTPServer {
	return &HTTPServer{
		cfg: cfg,
	}
}

func (a *HTTPServer) Run(ctx context.Context) error {

	if a.cfg.Server.HTTPPort == 0 {
		logger.Panic(ctx, "http port is not provided")
	}

	service := service.NewService(ctx, &a.cfg.Service, repository.GetInstance(ctx, &a.cfg.Repository))

	mux := runtime.NewServeMux()

	utils.RegisterSwaggerHandler(ctx, mux, "/openauth/v1/swagger", "./api/docs/proto", "/openauth/v1/openauth.swagger.json")
	err := openauth_v1.RegisterOpenAuthHandlerServer(ctx, mux, service)
	if err != nil {
		logger.Panic(ctx, "failed to register ping service : %v", err)
	}

	a.server = &http.Server{
		Addr:    fmt.Sprintf(":%d", a.cfg.Server.HTTPPort),
		Handler: logger.WithRequestMiddleware(logger.WithRequestTimeMiddleware(utils.CORSMiddleware(mux))),
	}

	logger.Info(ctx, "Starting HTTP server on port %d", a.cfg.Server.HTTPPort)
	logger.Info(ctx, "Swagger UI is available at `http://localhost:%d/openauth/v1/swagger`", a.cfg.Server.HTTPPort)
	// Start HTTP server (and proxy calls to gRPC server endpoint)
	err = a.server.ListenAndServe()
	if err != nil && err != http.ErrServerClosed {
		logger.Panic(ctx, "failed to start http server : %v", err)
	}
	return nil
}
