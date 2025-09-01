package jwtutils

import (
	"context"
	"fmt"
	"strings"

	"github.com/golang-jwt/jwt/v5"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

// Token claims structure
type JWTClaims struct {
	UserID      int64    `json:"userId"`
	UserUUID    string   `json:"userUUID"`
	SessionUUID string   `json:"sessionUUID"`
	DeviceID    string   `json:"deviceId,omitempty"`
	ProfileIds  []string `json:"profileIds,omitempty"`
	Permissions []string `json:"permissions,omitempty"`
	jwt.RegisteredClaims
}

// ExtractTokenFromMetadata extracts JWT token from gRPC metadata
func ExtractTokenFromMetadata(ctx context.Context) (string, error) {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return "", status.Error(codes.Unauthenticated, "missing metadata")
	}

	authHeaders := md.Get("authorization")
	if len(authHeaders) == 0 {
		return "", status.Error(codes.Unauthenticated, "missing authorization header")
	}

	authHeader := authHeaders[0]
	if !strings.HasPrefix(authHeader, "Bearer ") {
		return "", status.Error(codes.Unauthenticated, "invalid authorization header format")
	}

	return strings.TrimPrefix(authHeader, "Bearer "), nil
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
		return nil, fmt.Errorf("user claims not found in context")
	}
	return claims, nil
}

// HasPermission checks if the user in the context has the specified permission
func HasPermission(ctx context.Context, permission string) (bool, error) {
	claims, err := GetUserFromContext(ctx)
	if err != nil {
		return false, err
	}

	// Check if user has system admin permission (grants all permissions)
	for _, userPermission := range claims.Permissions {
		if userPermission == "system.admin" {
			return true, nil
		}
	}

	// Check for specific permission
	for _, userPermission := range claims.Permissions {
		if userPermission == permission {
			return true, nil
		}
	}

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
