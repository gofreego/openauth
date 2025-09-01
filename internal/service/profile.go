package service

import (
	"context"
	"fmt"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// GetCurrentUser returns the current user's information
// This demonstrates how to use JWT claims from context in service methods
func (s *Service) GetCurrentUser(ctx context.Context, req *openauth_v1.GetUserRequest) (*openauth_v1.GetUserResponse, error) {
	// Extract user claims from context (set by middleware)
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "user not authenticated")
	}

	// Get user by ID from database
	user, err := s.repo.GetUserByID(ctx, claims.UserID)
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
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "user not authenticated")
	}

	// Verify the user is updating their own profile (if uuid is provided in request)
	if req.Uuid != "" && claims.UserUUID != req.Uuid {
		return nil, status.Error(codes.PermissionDenied, "No permission to update other user's profile")
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
	updatedUser, err := s.repo.UpdateUser(ctx, claims.UserID, updateData)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to update user: %v", err))
	}

	return &openauth_v1.UpdateUserResponse{
		User: updatedUser.ToProtoUser(),
	}, nil
}
