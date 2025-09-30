package jwtutils

import (
	"context"
	"net/http"
	"strings"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/gofreego/goutils/logger"
)

// AuthMiddleware provides JWT authentication for gRPC and HTTP requests
type AuthMiddleware struct {
	jwtSecret  string
	enabled    bool
	validation bool // whether to validate token expiration and signature
}

// NewAuthMiddleware creates a new auth middleware instance
func NewAuthMiddleware(jwtSecret string, enabled bool, validation bool) *AuthMiddleware {
	logger.Info(context.Background(), "Initializing JWT Auth Middleware: enabled=%t, validation=%t", enabled, validation)
	return &AuthMiddleware{
		jwtSecret:  jwtSecret,
		enabled:    enabled,
		validation: validation,
	}
}

// UnaryServerInterceptor provides JWT authentication for unary gRPC calls
func (a *AuthMiddleware) UnaryServerInterceptor() grpc.UnaryServerInterceptor {
	return func(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (interface{}, error) {
		if !a.enabled {
			logger.Debug(ctx, "Auth middleware disabled, skipping authentication for method: %s", info.FullMethod)
			return handler(ctx, req)
		}

		// Skip auth for ping and sign-up endpoints
		if a.skipAuth(info.FullMethod) {
			logger.Debug(ctx, "Skipping authentication for exempt method: %s", info.FullMethod)
			return handler(ctx, req)
		}

		logger.Debug(ctx, "Processing gRPC authentication for method: %s", info.FullMethod)

		// Extract and validate token
		token, err := ExtractTokenFromMetadata(ctx)
		if err != nil {
			logger.Warn(ctx, "Failed to extract token from metadata for method %s: %v", info.FullMethod, err)
			return nil, err
		}
		var claims *JWTClaims
		if a.validation {
			claims, err = ParseAndValidateToken(token, a.jwtSecret)
			if err != nil {
				logger.Warn(ctx, "Invalid token for method %s: %v", info.FullMethod, err)
				return nil, status.Error(codes.Unauthenticated, "invalid token")
			}
		} else {
			claims, err = parseWithoutValidation(token)
			if err != nil {
				logger.Warn(ctx, "Failed to parse token without validation for method %s: %v", info.FullMethod, err)
				return nil, status.Error(codes.Unauthenticated, "invalid token")
			}
		}

		logger.Debug(ctx, "Token validated for user %s (userID=%d) accessing method: %s",
			claims.UserUUID, claims.UserID, info.FullMethod)

		// Add claims to context
		ctx = setUserInContext(ctx, claims)

		return handler(ctx, req)
	}
}

// StreamServerInterceptor provides JWT authentication for streaming gRPC calls
func (a *AuthMiddleware) StreamServerInterceptor() grpc.StreamServerInterceptor {
	return func(srv interface{}, ss grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
		if !a.enabled {
			logger.Debug(ss.Context(), "Auth middleware disabled, skipping authentication for stream method: %s", info.FullMethod)
			return handler(srv, ss)
		}

		// Skip auth for ping endpoints
		if a.skipAuth(info.FullMethod) {
			logger.Debug(ss.Context(), "Skipping authentication for exempt stream method: %s", info.FullMethod)
			return handler(srv, ss)
		}

		logger.Debug(ss.Context(), "Processing gRPC stream authentication for method: %s", info.FullMethod)

		// Extract and validate token
		token, err := ExtractTokenFromMetadata(ss.Context())
		if err != nil {
			logger.Warn(ss.Context(), "Failed to extract token from stream metadata for method %s: %v", info.FullMethod, err)
			return err
		}

		claims, err := ParseAndValidateToken(token, a.jwtSecret)
		if err != nil {
			logger.Warn(ss.Context(), "Invalid token for stream method %s: %v", info.FullMethod, err)
			return status.Error(codes.Unauthenticated, "invalid token")
		}

		logger.Debug(ss.Context(), "Stream token validated for user %s (userID=%d) accessing method: %s",
			claims.UserUUID, claims.UserID, info.FullMethod)

		// Add claims to context
		ctx := setUserInContext(ss.Context(), claims)

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
		logger.Info(context.Background(), "HTTP Auth middleware disabled")
		return next
	}
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Skip auth for ping and sign-up endpoints
		if a.skipHTTPAuth(r.URL.Path) {
			logger.Debug(r.Context(), "Skipping HTTP authentication for exempt path: %s %s", r.Method, r.URL.Path)
			next.ServeHTTP(w, r)
			return
		}

		logger.Debug(r.Context(), "Processing HTTP authentication for: %s %s", r.Method, r.URL.Path)

		// Extract token from Authorization header
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" {
			logger.Warn(r.Context(), "Missing authorization header for HTTP request: %s %s", r.Method, r.URL.Path)
			http.Error(w, "missing authorization header", http.StatusUnauthorized)
			return
		}

		if !strings.HasPrefix(authHeader, "Bearer ") {
			logger.Warn(r.Context(), "Invalid authorization header format for HTTP request: %s %s", r.Method, r.URL.Path)
			http.Error(w, "invalid authorization header format", http.StatusUnauthorized)
			return
		}

		token := strings.TrimPrefix(authHeader, "Bearer ")
		claims, err := ParseAndValidateToken(token, a.jwtSecret)
		if err != nil {
			logger.Warn(r.Context(), "Invalid token for HTTP request %s %s: %v", r.Method, r.URL.Path, err)
			http.Error(w, "invalid token", http.StatusUnauthorized)
			return
		}

		logger.Debug(r.Context(), "HTTP token validated for user %s (userID=%d) accessing: %s %s",
			claims.UserUUID, claims.UserID, r.Method, r.URL.Path)

		// Add claims to request context
		ctx := setUserInContext(r.Context(), claims)
		r = r.WithContext(ctx)

		next.ServeHTTP(w, r)
	})
}

// skipAuth checks if the gRPC method should skip authentication
func (a *AuthMiddleware) skipAuth(method string) bool {
	logger.Info(context.Background(), "Checking if method should skip auth: %s", method)
	skipMethods := []string{
		"/v1.OpenAuth/Ping",
		"/v1.OpenAuth/SignUp",
		"/v1.OpenAuth/SignIn",
		"/v1.OpenAuth/RefreshToken",
		"/v1.OpenAuth/ValidateToken",
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
		"/openauth/v1/swagger",
		"/openauth/admin",
	}

	for _, skipPath := range skipPaths {
		if strings.HasSuffix(path, skipPath) || strings.HasPrefix(path, skipPath) {
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
