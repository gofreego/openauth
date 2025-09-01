package jwtutils

import (
	"context"
	"net/http"
	"strings"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/goutils/logger"
)

// AuthMiddleware provides JWT authentication for gRPC and HTTP requests
type AuthMiddleware struct {
	jwtSecret string
	enabled   bool
}

// NewAuthMiddleware creates a new auth middleware instance
func NewAuthMiddleware(jwtSecret string, enabled bool) *AuthMiddleware {
	logger.Info(context.Background(), "Initializing JWT Auth Middleware: enabled=%t", enabled)
	return &AuthMiddleware{
		jwtSecret: jwtSecret,
		enabled:   enabled,
	}
}

// getRequiredPermissionForMethod returns the required permission for a gRPC method
func (a *AuthMiddleware) getRequiredPermissionForMethod(method string) string {
	methodPermissions := map[string]string{
		// User management
		"/v1.OpenAuth/GetUser":        constants.PermissionUsersRead,
		"/v1.OpenAuth/UpdateUser":     constants.PermissionUsersUpdate,
		"/v1.OpenAuth/DeleteUser":     constants.PermissionUsersDelete,
		"/v1.OpenAuth/ListUsers":      constants.PermissionUsersList,
		"/v1.OpenAuth/ChangePassword": constants.PermissionUsersUpdate,

		// User profiles
		"/v1.OpenAuth/CreateProfile":    constants.PermissionProfilesCreate,
		"/v1.OpenAuth/ListUserProfiles": constants.PermissionProfilesList,
		"/v1.OpenAuth/UpdateProfile":    constants.PermissionProfilesUpdate,
		"/v1.OpenAuth/DeleteProfile":    constants.PermissionProfilesDelete,

		// Permission management
		"/v1.OpenAuth/CreatePermission":            constants.PermissionPermissionsCreate,
		"/v1.OpenAuth/GetPermission":               constants.PermissionPermissionsRead,
		"/v1.OpenAuth/UpdatePermission":            constants.PermissionPermissionsUpdate,
		"/v1.OpenAuth/DeletePermission":            constants.PermissionPermissionsDelete,
		"/v1.OpenAuth/ListPermissions":             constants.PermissionPermissionsRead,
		"/v1.OpenAuth/AssignPermissionToUser":      constants.PermissionPermissionsAssign,
		"/v1.OpenAuth/RemovePermissionFromUser":    constants.PermissionPermissionsRevoke,
		"/v1.OpenAuth/AssignPermissionToGroup":     constants.PermissionPermissionsAssign,
		"/v1.OpenAuth/RemovePermissionFromGroup":   constants.PermissionPermissionsRevoke,
		"/v1.OpenAuth/ListUserPermissions":         constants.PermissionPermissionsRead,
		"/v1.OpenAuth/ListGroupPermissions":        constants.PermissionPermissionsRead,
		"/v1.OpenAuth/GetUserEffectivePermissions": constants.PermissionPermissionsRead,

		// Group management
		"/v1.OpenAuth/CreateGroup":         constants.PermissionGroupsCreate,
		"/v1.OpenAuth/GetGroup":            constants.PermissionGroupsRead,
		"/v1.OpenAuth/UpdateGroup":         constants.PermissionGroupsUpdate,
		"/v1.OpenAuth/DeleteGroup":         constants.PermissionGroupsDelete,
		"/v1.OpenAuth/ListGroups":          constants.PermissionGroupsRead,
		"/v1.OpenAuth/AssignUserToGroup":   constants.PermissionGroupsAssign,
		"/v1.OpenAuth/RemoveUserFromGroup": constants.PermissionGroupsRevoke,
		"/v1.OpenAuth/ListGroupUsers":      constants.PermissionGroupsRead,
		"/v1.OpenAuth/ListUserGroups":      constants.PermissionGroupsRead,

		// Session management
		"/v1.OpenAuth/ListUserSessions": constants.PermissionSessionsRead,
		"/v1.OpenAuth/TerminateSession": constants.PermissionSessionsTerminate,
	}

	return methodPermissions[method]
}

// getRequiredPermissionForHTTPPath returns the required permission for an HTTP path
func (a *AuthMiddleware) getRequiredPermissionForHTTPPath(method, path string) string {
	// Define HTTP path to permission mappings
	pathPermissions := map[string]map[string]string{
		// User management endpoints
		"/v1/users": {
			"POST": constants.PermissionUsersCreate,
			"GET":  constants.PermissionUsersList,
		},
		"/openauth/v1/users": {
			"POST": constants.PermissionUsersCreate,
			"GET":  constants.PermissionUsersList,
		},
		// Permission management endpoints
		"/v1/permissions": {
			"POST": constants.PermissionPermissionsCreate,
			"GET":  constants.PermissionPermissionsRead,
		},
		"/openauth/v1/permissions": {
			"POST": constants.PermissionPermissionsCreate,
			"GET":  constants.PermissionPermissionsRead,
		},
		// Group management endpoints
		"/v1/groups": {
			"POST": constants.PermissionGroupsCreate,
			"GET":  constants.PermissionGroupsRead,
		},
		"/openauth/v1/groups": {
			"POST": constants.PermissionGroupsCreate,
			"GET":  constants.PermissionGroupsRead,
		},
	}

	// Check for specific path patterns with user/group/permission IDs
	if strings.HasPrefix(path, "/v1/users/") || strings.HasPrefix(path, "/openauth/v1/users/") {
		switch method {
		case "GET":
			if strings.Contains(path, "/sessions") {
				return constants.PermissionSessionsRead
			}
			if strings.Contains(path, "/groups") {
				return constants.PermissionGroupsRead
			}
			if strings.Contains(path, "/permissions") {
				return constants.PermissionPermissionsRead
			}
			return constants.PermissionUsersRead
		case "PUT", "PATCH":
			if strings.Contains(path, "/permissions") {
				return constants.PermissionPermissionsAssign
			}
			return constants.PermissionUsersUpdate
		case "DELETE":
			if strings.Contains(path, "/sessions") {
				return constants.PermissionSessionsTerminate
			}
			if strings.Contains(path, "/permissions") {
				return constants.PermissionPermissionsRevoke
			}
			return constants.PermissionUsersDelete
		case "POST":
			if strings.Contains(path, "/permissions") {
				return constants.PermissionPermissionsAssign
			}
			if strings.Contains(path, "/groups") {
				return constants.PermissionGroupsAssign
			}
		}
	}

	if strings.HasPrefix(path, "/v1/permissions/") || strings.HasPrefix(path, "/openauth/v1/permissions/") {
		switch method {
		case "GET":
			return constants.PermissionPermissionsRead
		case "PUT", "PATCH":
			return constants.PermissionPermissionsUpdate
		case "DELETE":
			return constants.PermissionPermissionsDelete
		}
	}

	if strings.HasPrefix(path, "/v1/groups/") || strings.HasPrefix(path, "/openauth/v1/groups/") {
		switch method {
		case "GET":
			if strings.Contains(path, "/users") {
				return constants.PermissionGroupsRead
			}
			if strings.Contains(path, "/permissions") {
				return constants.PermissionPermissionsRead
			}
			return constants.PermissionGroupsRead
		case "PUT", "PATCH":
			return constants.PermissionGroupsUpdate
		case "DELETE":
			if strings.Contains(path, "/users") {
				return constants.PermissionGroupsRevoke
			}
			if strings.Contains(path, "/permissions") {
				return constants.PermissionPermissionsRevoke
			}
			return constants.PermissionGroupsDelete
		case "POST":
			if strings.Contains(path, "/users") {
				return constants.PermissionGroupsAssign
			}
			if strings.Contains(path, "/permissions") {
				return constants.PermissionPermissionsAssign
			}
		}
	}

	// Check exact path matches
	if methodMap, exists := pathPermissions[path]; exists {
		return methodMap[method]
	}

	return ""
}

// hasPermission checks if the user has the required permission
func (a *AuthMiddleware) hasPermission(claims *JWTClaims, requiredPermission string) bool {
	if requiredPermission == "" {
		return true // No permission required
	}

	// Check if user has system admin permission (grants all permissions)
	for _, permission := range claims.Permissions {
		if permission == constants.PermissionSystemAdmin {
			logger.Debug(context.Background(), "User %s has system admin permission, granting access", claims.UserUUID)
			return true
		}
	}

	// Check for specific permission
	for _, permission := range claims.Permissions {
		if permission == requiredPermission {
			logger.Debug(context.Background(), "User %s has required permission %s", claims.UserUUID, requiredPermission)
			return true
		}
	}

	logger.Warn(context.Background(), "User %s lacks required permission %s. User permissions: %v", 
		claims.UserUUID, requiredPermission, claims.Permissions)
	return false
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

		claims, err := ParseAndValidateToken(token, a.jwtSecret)
		if err != nil {
			logger.Warn(ctx, "Invalid token for method %s: %v", info.FullMethod, err)
			return nil, status.Error(codes.Unauthenticated, "invalid token")
		}

		logger.Debug(ctx, "Token validated for user %s (userID=%d) accessing method: %s", 
			claims.UserUUID, claims.UserID, info.FullMethod)

		// Check permissions for the requested method
		requiredPermission := a.getRequiredPermissionForMethod(info.FullMethod)
		if requiredPermission != "" && !a.hasPermission(claims, requiredPermission) {
			logger.Warn(ctx, "Permission denied for user %s accessing method %s. Required: %s", 
				claims.UserUUID, info.FullMethod, requiredPermission)
			return nil, status.Error(codes.PermissionDenied, "insufficient permissions")
		}

		if requiredPermission != "" {
			logger.Debug(ctx, "Permission check passed for user %s accessing method %s", 
				claims.UserUUID, info.FullMethod)
		}

		// Add claims to context
		ctx = SetUserInContext(ctx, claims)

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

		// Check permissions for the requested method
		requiredPermission := a.getRequiredPermissionForMethod(info.FullMethod)
		if requiredPermission != "" && !a.hasPermission(claims, requiredPermission) {
			logger.Warn(ss.Context(), "Stream permission denied for user %s accessing method %s. Required: %s", 
				claims.UserUUID, info.FullMethod, requiredPermission)
			return status.Error(codes.PermissionDenied, "insufficient permissions")
		}

		if requiredPermission != "" {
			logger.Debug(ss.Context(), "Stream permission check passed for user %s accessing method %s", 
				claims.UserUUID, info.FullMethod)
		}

		// Add claims to context
		ctx := SetUserInContext(ss.Context(), claims)

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

		// Check permissions for the requested path and method
		requiredPermission := a.getRequiredPermissionForHTTPPath(r.Method, r.URL.Path)
		if requiredPermission != "" && !a.hasPermission(claims, requiredPermission) {
			logger.Warn(r.Context(), "HTTP permission denied for user %s accessing %s %s. Required: %s", 
				claims.UserUUID, r.Method, r.URL.Path, requiredPermission)
			http.Error(w, "insufficient permissions", http.StatusForbidden)
			return
		}

		if requiredPermission != "" {
			logger.Debug(r.Context(), "HTTP permission check passed for user %s accessing %s %s", 
				claims.UserUUID, r.Method, r.URL.Path)
		}

		// Add claims to request context
		ctx := SetUserInContext(r.Context(), claims)
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
		"/openauth/v1/swagger",
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

// InitAuthMiddleware initializes auth middleware with config
func InitAuthMiddleware(secretKey string, enabled bool) *AuthMiddleware {
	logger.Info(context.Background(), "Initializing Auth Middleware with enabled=%t", enabled)
	return NewAuthMiddleware(secretKey, enabled)
}
