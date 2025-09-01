package service

import (
	"context"
	"fmt"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/pkg/auth"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// GetCurrentUser returns the current user's information
// This demonstrates how to use JWT claims from context in service methods
func (s *Service) GetCurrentUser(ctx context.Context, req *openauth_v1.GetUserRequest) (*openauth_v1.GetUserResponse, error) {
	// Extract user claims from context (set by middleware)
	claims, err := auth.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "user not authenticated")
	}

	// Get user by ID from database
	user, err := s.repo.GetUserByUUID(ctx, claims.UserID)
	if err != nil {
		return nil, status.Error(codes.NotFound, "user not found")
	}

	// Convert to protobuf response
	return &openauth_v1.GetUserResponse{
		User: user.ToProtoUser(),
	}, nil
}

// UpdateCurrentUser updates the current user's information
// This demonstrates how middleware provides user context for authorization
func (s *Service) UpdateCurrentUser(ctx context.Context, req *openauth_v1.UpdateUserRequest) (*openauth_v1.UpdateUserResponse, error) {
	// Extract user claims from context (set by middleware)
	claims, err := auth.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "user not authenticated")
	}

	// Verify the user is updating their own profile (if uuid is provided in request)
	if req.Uuid != "" && claims.UserID != req.Uuid {
		return nil, status.Error(codes.PermissionDenied, "cannot update another user's profile")
	}

	// Use the authenticated user's ID
	userID := claims.UserID

	// Parse user ID to int64 for repository call
	userIDInt, err := parseUserUUID(userID)
	if err != nil {
		return nil, status.Error(codes.Internal, "invalid user ID")
	}

	// Prepare update data
	updateData := make(map[string]interface{})
	if req.Email != nil && *req.Email != "" {
		updateData["email"] = *req.Email
	}
	if req.Name != nil && *req.Name != "" {
		updateData["name"] = *req.Name
	}
	if req.AvatarUrl != nil && *req.AvatarUrl != "" {
		updateData["avatar_url"] = *req.AvatarUrl
	}

	// Update user
	updatedUser, err := s.repo.UpdateUser(ctx, userIDInt, updateData)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to update user: %v", err))
	}

	return &openauth_v1.UpdateUserResponse{
		User: updatedUser.ToProtoUser(),
	}, nil
}

// Example helper function to demonstrate context usage in any service method
func (s *Service) getCurrentUserID(ctx context.Context) (string, error) {
	claims, err := auth.GetUserFromContext(ctx)
	if err != nil {
		return "", fmt.Errorf("user not authenticated: %w", err)
	}
	return claims.UserID, nil
}

// Helper function to parse user UUID (you may need to adjust this based on your ID format)
func parseUserUUID(userID string) (int64, error) {
	// This is a simplified example - you may need to implement proper UUID to int64 conversion
	// or modify your repository to work with UUID strings directly
	return 1, nil // Placeholder implementation
}
