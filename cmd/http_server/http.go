package http_server

import (
	"context"
	"fmt"
	"net/http"
	"path/filepath"
	"strings"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/configs"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/repository"
	"github.com/gofreego/openauth/internal/service"
	"github.com/gofreego/openauth/pkg/jwtutils"

	"github.com/gofreego/goutils/api"
	"github.com/gofreego/goutils/api/debug"
	"github.com/gofreego/goutils/logger"
	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
)

type HTTPServer struct {
	cfg    *configs.Configuration
	server *http.Server
}

func (a *HTTPServer) Name() string {
	return constants.HTTP_SERVER
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

	if a.cfg.Server.HTTP.Port == 0 {
		logger.Panic(ctx, "http port is not provided")
	}

	service := service.NewService(ctx, &a.cfg.Service, repository.GetInstance(ctx, &a.cfg.Repository))

	// Create authentication middleware
	authMiddleware := jwtutils.NewAuthMiddleware(a.cfg.Service.JWT.SecretKey, a.cfg.Server.HTTP.AuthenticationEnabled, true)

	mux := runtime.NewServeMux()

	api.RegisterSwaggerHandler(ctx, mux, "/openauth/v1/swagger", "./api/docs/proto", "/openauth/v1/openauth.swagger.json")
	err := openauth_v1.RegisterOpenAuthHandlerServer(ctx, mux, service)
	if err != nil {
		logger.Panic(ctx, "failed to register ping service : %v", err)
	}

	// Register debug endpoints if enabled
	if a.cfg.Debug.Enabled {
		debug.RegisterDebugHandlersWithGateway(ctx, &a.cfg.Debug, mux, a.cfg.Logger.AppName, string(a.cfg.Logger.Build), "/openauth/v1")
	}

	// Create a custom handler that serves static files for /openauth/admin and falls back to grpc-gateway
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if strings.HasPrefix(r.URL.Path, "/openauth/admin") {
			// Serve static files from admin/builds/web
			staticDir := "./admin/builds/web"

			// Remove /openauth/admin prefix and get the file path
			filePath := strings.TrimPrefix(r.URL.Path, "/openauth/admin")
			if filePath == "" || filePath == "/" {
				filePath = "/index.html"
			}

			// Construct the full file path
			fullPath := filepath.Join(staticDir, filePath)

			// Check if file exists, if not serve index.html for SPA routing
			if _, err := http.Dir(staticDir).Open(filePath); err != nil {
				fullPath = filepath.Join(staticDir, "index.html")
			}

			http.ServeFile(w, r, fullPath)
			return
		}

		// Fall back to grpc-gateway mux for other routes
		mux.ServeHTTP(w, r)
	})

	a.server = &http.Server{
		Addr:    fmt.Sprintf(":%d", a.cfg.Server.HTTP.Port),
		Handler: logger.WithRequestMiddleware(logger.WithRequestTimeMiddleware(api.CORSMiddleware(authMiddleware.HTTPMiddleware(handler)))),
	}

	logger.Info(ctx, "Starting HTTP server on port %d", a.cfg.Server.HTTP.Port)
	logger.Info(ctx, "Swagger UI is available at `http://localhost:%d/openauth/v1/swagger`", a.cfg.Server.HTTP.Port)
	logger.Info(ctx, "Admin UI is available at `http://localhost:%d/openauth/admin`", a.cfg.Server.HTTP.Port)

	if a.cfg.Debug.Enabled {
		logger.Info(ctx, "Debug dashboard available at `http://localhost:%d/openauth/v1/debug`", a.cfg.Server.HTTP.Port)
	}
	// Start HTTP server (and proxy calls to gRPC server endpoint)
	err = a.server.ListenAndServe()
	if err != nil && err != http.ErrServerClosed {
		logger.Panic(ctx, "failed to start http server : %v", err)
	}
	return nil
}
