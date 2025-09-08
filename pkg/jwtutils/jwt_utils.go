package jwtutils

import (
	"context"
	"fmt"
	"strings"

	"github.com/gofreego/goutils/logger"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

// Token claims structure
type JWTClaims struct {
	UserID      int64       `json:"userId"`
	UserUUID    string      `json:"userUUID"`
	SessionUUID string      `json:"sessionUUID"`
	DeviceID    string      `json:"deviceId,omitempty"`
	ProfileIds  []uuid.UUID `json:"profileIds,omitempty"`
	Permissions []string    `json:"permissions,omitempty"`
	jwt.RegisteredClaims
}

func (c *JWTClaims) HasPermission(permission string) bool {
	for _, userPerm := range c.Permissions {
		if userPerm == permission || userPerm == "system.admin" {
			return true
		}
	}
	return false
}

func (c *JWTClaims) HasProfile(profileId string) bool {
	for _, pid := range c.ProfileIds {
		if pid.String() == profileId {
			return true
		}
	}
	return false
}

// ExtractTokenFromMetadata extracts JWT token from gRPC metadata
func ExtractTokenFromMetadata(ctx context.Context) (string, error) {
	logger.Debug(ctx, "Extracting JWT token from metadata")

	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		logger.Warn(ctx, "Token extraction failed: missing metadata")
		return "", status.Error(codes.Unauthenticated, "missing metadata")
	}

	authHeaders := md.Get("authorization")
	if len(authHeaders) == 0 {
		logger.Warn(ctx, "Token extraction failed: missing authorization header")
		return "", status.Error(codes.Unauthenticated, "missing authorization header")
	}

	authHeader := authHeaders[0]
	if !strings.HasPrefix(authHeader, "Bearer ") {
		logger.Warn(ctx, "Token extraction failed: invalid authorization header format")
		return "", status.Error(codes.Unauthenticated, "invalid authorization header format")
	}

	token := strings.TrimPrefix(authHeader, "Bearer ")
	logger.Debug(ctx, "JWT token extracted successfully")
	return token, nil
}

// ParseAndValidateToken parses and validates a JWT token
func ParseAndValidateToken(tokenString, jwtSecret string) (*JWTClaims, error) {
	claims := &JWTClaims{}

	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return []byte(jwtSecret), nil
	})

	if err != nil {
		return nil, fmt.Errorf("failed to parse token: %w", err)
	}

	if !token.Valid {
		return nil, fmt.Errorf("invalid token")
	}

	return claims, nil
}

type JWT_CLAIM_KEY string

const (
	JWT_CLAIM_KEY_USER JWT_CLAIM_KEY = "user_claims"
)

// SetUserInContext sets user claims in context
func SetUserInContext(ctx context.Context, claims *JWTClaims) context.Context {
	return context.WithValue(ctx, JWT_CLAIM_KEY_USER, claims)
}

// GetUserFromContext extracts user claims from context
func GetUserFromContext(ctx context.Context) (*JWTClaims, error) {
	claims, ok := ctx.Value(JWT_CLAIM_KEY_USER).(*JWTClaims)
	if !ok {
		logger.Warn(ctx, "User claims not found in context")
		return nil, fmt.Errorf("user claims not found in context")
	}
	logger.Debug(ctx, "User claims retrieved from context: userID=%d, sessionUUID=%s", claims.UserID, claims.SessionUUID)
	return claims, nil
}

// HasPermission checks if the user in the context has the specified permission
func HasPermission(ctx context.Context, permission string) (bool, error) {
	claims, err := GetUserFromContext(ctx)
	if err != nil {
		return false, err
	}

	logger.Debug(ctx, "Checking permission '%s' for userID=%d", permission, claims.UserID)

	// Check if user has system admin permission (grants all permissions)
	for _, userPermission := range claims.Permissions {
		if userPermission == "system.admin" {
			logger.Debug(ctx, "System admin permission found for userID=%d", claims.UserID)
			return true, nil
		}
	}

	// Check for specific permission
	for _, userPermission := range claims.Permissions {
		if userPermission == permission {
			logger.Debug(ctx, "Permission '%s' granted for userID=%d", permission, claims.UserID)
			return true, nil
		}
	}

	logger.Debug(ctx, "Permission '%s' denied for userID=%d", permission, claims.UserID)
	return false, nil
}

// RequirePermission checks if the user has the required permission and returns an error if not
func RequirePermission(ctx context.Context, permission string) error {
	hasPerms, err := HasPermission(ctx, permission)
	if err != nil {
		return fmt.Errorf("failed to check permissions: %w", err)
	}

	if !hasPerms {
		return fmt.Errorf("insufficient permissions: %s required", permission)
	}

	return nil
}
