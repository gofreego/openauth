package middleware

import (
	"context"
	"net/http"
	"strings"

	"github.com/gofreego/openauth/pkg/auth"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// AuthMiddleware provides JWT authentication for gRPC and HTTP requests
type AuthMiddleware struct {
	jwtSecret string
	enabled   bool
}

// NewAuthMiddleware creates a new auth middleware instance
func NewAuthMiddleware(jwtSecret string, enabled bool) *AuthMiddleware {
	return &AuthMiddleware{
		jwtSecret: jwtSecret,
		enabled:   enabled,
	}
}

// UnaryServerInterceptor provides JWT authentication for unary gRPC calls
func (a *AuthMiddleware) UnaryServerInterceptor() grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
		if !a.enabled {
			return handler(ctx, req)
		}
		// Skip auth for ping and sign-up endpoints
		if a.skipAuth(info.FullMethod) {
			return handler(ctx, req)
		}

		// Extract and validate token
		token, err := auth.ExtractTokenFromMetadata(ctx)
		if err != nil {
			return nil, err
		}

		claims, err := auth.ParseAndValidateToken(token, a.jwtSecret)
		if err != nil {
			return nil, status.Error(codes.Unauthenticated, "invalid token")
		}

		// Add claims to context
		ctx = auth.SetUserInContext(ctx, claims)

		return handler(ctx, req)
	}
}

// StreamServerInterceptor provides JWT authentication for streaming gRPC calls
func (a *AuthMiddleware) StreamServerInterceptor() grpc.StreamServerInterceptor {
	return func(srv interface{}, ss grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
		if !a.enabled {
			return handler(srv, ss)
		}
		// Skip auth for ping endpoints
		if a.skipAuth(info.FullMethod) {
			return handler(srv, ss)
		}

		// Extract and validate token
		token, err := auth.ExtractTokenFromMetadata(ss.Context())
		if err != nil {
			return err
		}

		claims, err := auth.ParseAndValidateToken(token, a.jwtSecret)
		if err != nil {
			return status.Error(codes.Unauthenticated, "invalid token")
		}

		// Add claims to context
		ctx := auth.SetUserInContext(ss.Context(), claims)

		// Create a new server stream with the updated context
		wrappedStream := &wrappedServerStream{
			ServerStream: ss,
			ctx:          ctx,
		}

		return handler(srv, wrappedStream)
	}
}

// HTTPMiddleware provides JWT authentication for HTTP requests
func (a *AuthMiddleware) HTTPMiddleware(next http.Handler) http.Handler {
	if !a.enabled {
		return next
	}
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Skip auth for ping and sign-up endpoints
		if a.skipHTTPAuth(r.URL.Path) {
			next.ServeHTTP(w, r)
			return
		}

		// Extract token from Authorization header
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" {
			http.Error(w, "missing authorization header", http.StatusUnauthorized)
			return
		}

		if !strings.HasPrefix(authHeader, "Bearer ") {
			http.Error(w, "invalid authorization header format", http.StatusUnauthorized)
			return
		}

		token := strings.TrimPrefix(authHeader, "Bearer ")
		claims, err := auth.ParseAndValidateToken(token, a.jwtSecret)
		if err != nil {
			http.Error(w, "invalid token", http.StatusUnauthorized)
			return
		}

		// Add claims to request context
		ctx := auth.SetUserInContext(r.Context(), claims)
		r = r.WithContext(ctx)

		next.ServeHTTP(w, r)
	})
}

// skipAuth checks if the gRPC method should skip authentication
func (a *AuthMiddleware) skipAuth(method string) bool {
	skipMethods := []string{
		"/openauth.v1.OpenAuthService/Ping",
		"/openauth.v1.OpenAuthService/SignUp",
		"/openauth.v1.OpenAuthService/SignIn",
		"/openauth.v1.OpenAuthService/RefreshToken",
		"/openauth.v1.OpenAuthService/ValidateToken",
	}

	for _, skipMethod := range skipMethods {
		if method == skipMethod {
			return true
		}
	}
	return false
}

// skipHTTPAuth checks if the HTTP path should skip authentication
func (a *AuthMiddleware) skipHTTPAuth(path string) bool {
	skipPaths := []string{
		"/v1/ping",
		"/v1/users/signup",
		"/v1/auth/signin",
		"/v1/auth/refresh",
		"/v1/auth/validate",
	}

	for _, skipPath := range skipPaths {
		if strings.HasSuffix(path, skipPath) {
			return true
		}
	}
	return false
}

// wrappedServerStream wraps grpc.ServerStream to provide context with claims
type wrappedServerStream struct {
	grpc.ServerStream
	ctx context.Context
}

func (w *wrappedServerStream) Context() context.Context {
	return w.ctx
}

// InitAuthMiddleware initializes auth middleware with config
func InitAuthMiddleware(secretKey string, enabled bool) *AuthMiddleware {
	return NewAuthMiddleware(secretKey, enabled)
}
