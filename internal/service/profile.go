package service

import (
	"context"
	"fmt"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"github.com/gofreego/goutils/logger"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// GetCurrentUser returns the current user's information
// This demonstrates how to use JWT claims from context in service methods
func (s *Service) GetCurrentUser(ctx context.Context, req *openauth_v1.GetUserRequest) (*openauth_v1.GetUserResponse, error) {
	logger.Debug(ctx, "GetCurrentUser request initiated")
	
	// Extract user claims from context (set by middleware)
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "GetCurrentUser failed: user not authenticated: %v", err)
		return nil, status.Error(codes.Unauthenticated, "user not authenticated")
	}

	logger.Debug(ctx, "User claims extracted: userID=%d, userUUID=%s, sessionID=%s", 
		claims.UserID, claims.UserUUID, claims.SessionUUID)

	// Get user by ID from database
	user, err := s.repo.GetUserByID(ctx, claims.UserID)
	if err != nil {
		logger.Error(ctx, "Failed to get user from database: userID=%d: %v", claims.UserID, err)
		return nil, status.Error(codes.NotFound, "user not found")
	}

	logger.Info(ctx, "GetCurrentUser completed successfully: userID=%d, username=%s", 
		user.ID, user.Username)

	// Convert to protobuf response
	return &openauth_v1.GetUserResponse{
		User: user.ToProtoUser(),
	}, nil
}

// UpdateCurrentUser updates the current user's information
// This demonstrates how middleware provides user context for authorization
func (s *Service) UpdateCurrentUser(ctx context.Context, req *openauth_v1.UpdateUserRequest) (*openauth_v1.UpdateUserResponse, error) {
	logger.Debug(ctx, "UpdateCurrentUser request initiated")
	
	// Extract user claims from context (set by middleware)
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "UpdateCurrentUser failed: user not authenticated: %v", err)
		return nil, status.Error(codes.Unauthenticated, "user not authenticated")
	}

	logger.Debug(ctx, "User claims extracted for update: userID=%d, userUUID=%s", 
		claims.UserID, claims.UserUUID)

	// Verify the user is updating their own profile (if uuid is provided in request)
	if req.Uuid != "" && claims.UserUUID != req.Uuid {
		logger.Warn(ctx, "UpdateCurrentUser denied: user %s attempting to update profile of %s", 
			claims.UserUUID, req.Uuid)
		return nil, status.Error(codes.PermissionDenied, "No permission to update other user's profile")
	}

	// Prepare update data
	updateData := make(map[string]interface{})
	var updateFields []string
	
	if req.Email != nil && *req.Email != "" {
		updateData["email"] = *req.Email
		updateFields = append(updateFields, "email")
	}
	if req.Name != nil && *req.Name != "" {
		updateData["name"] = *req.Name
		updateFields = append(updateFields, "name")
	}
	if req.AvatarUrl != nil && *req.AvatarUrl != "" {
		updateData["avatar_url"] = *req.AvatarUrl
		updateFields = append(updateFields, "avatar_url")
	}

	logger.Debug(ctx, "Updating user profile fields: %v for userID=%d", updateFields, claims.UserID)

	// Update user
	updatedUser, err := s.repo.UpdateUser(ctx, claims.UserID, updateData)
	if err != nil {
		logger.Error(ctx, "Failed to update user profile: userID=%d, fields=%v: %v", 
			claims.UserID, updateFields, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to update user: %v", err))
	}

	logger.Info(ctx, "User profile updated successfully: userID=%d, username=%s, fields=%v", 
		updatedUser.ID, updatedUser.Username, updateFields)

	return &openauth_v1.UpdateUserResponse{
		User: updatedUser.ToProtoUser(),
	}, nil
}
