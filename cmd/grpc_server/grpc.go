package grpc_server

import (
	"context"
	"fmt"
	"net"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/configs"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/repository"
	"github.com/gofreego/openauth/internal/service"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"google.golang.org/grpc"

	"github.com/gofreego/goutils/logger"
)

type GRPCServer struct {
	cfg    *configs.Configuration
	server *grpc.Server
}

func (a *GRPCServer) Name() string {
	return constants.GRPC_SERVER
}

func (a *GRPCServer) Shutdown(ctx context.Context) {
	a.server.GracefulStop()
}

func NewGRPCServer(cfg *configs.Configuration) *GRPCServer {
	return &GRPCServer{
		cfg: cfg,
	}
}

func (a *GRPCServer) Run(ctx context.Context) error {

	if a.cfg.Server.GRPC.Port == 0 {
		logger.Panic(ctx, "grpc port is not provided")
	}

	repository := repository.GetInstance(ctx, &a.cfg.Repository)

	service := service.NewService(ctx, &a.cfg.Service, repository)

	// Create authentication middleware
	authMiddleware := jwtutils.NewAuthMiddleware(a.cfg.Service.JWT.SecretKey, a.cfg.Server.GRPC.AuthenticationEnabled, true)
	authMiddleware.SetSkipMethods([]string{
		"/v1.OpenAuth/Ping",
		"/v1.OpenAuth/SignUp",
		"/v1.OpenAuth/SignIn",
		"/v1.OpenAuth/RefreshToken",
		"/v1.OpenAuth/ValidateToken",
	})
	// Create a new gRPC server with interceptors
	a.server = grpc.NewServer(
		grpc.UnaryInterceptor(authMiddleware.UnaryServerInterceptor()),
		grpc.StreamInterceptor(authMiddleware.StreamServerInterceptor()),
	)

	openauth_v1.RegisterOpenAuthServer(a.server, service)

	logger.Info(ctx, "Starting gRPC server on port %d", a.cfg.Server.GRPC.Port)

	// Listen on a TCP port
	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", a.cfg.Server.GRPC.Port))
	if err != nil {
		logger.Panic(ctx, "failed to listen for grpc server: %v", err)
	}

	// Start the gRPC server
	if err := a.server.Serve(lis); err != nil {
		logger.Panic(ctx, "failed to start grpc server: %v", err)
	}
	return nil
}
