package service

import (
	"context"
	"time"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/models/dao"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// GetUser retrieves user information by ID, UUID, username, or email
func (s *Service) GetUser(ctx context.Context, req *openauth_v1.GetUserRequest) (*openauth_v1.GetUserResponse, error) {
	var user *dao.User
	var err error

	switch identifier := req.Identifier.(type) {
	case *openauth_v1.GetUserRequest_Id:
		user, err = s.repo.GetUserByID(ctx, identifier.Id)
	case *openauth_v1.GetUserRequest_Uuid:
		user, err = s.repo.GetUserByUUID(ctx, identifier.Uuid)
	default:
		return nil, status.Error(codes.InvalidArgument, "invalid identifier")
	}

	if err != nil {
		return nil, status.Error(codes.NotFound, "user not found")
	}

	response := &openauth_v1.GetUserResponse{
		User: user.ToProtoUser(),
	}

	// Include profiles if requested
	if req.IncludeProfile {
		// Note: Profile functionality would require GetUserProfiles method
		// response.Profiles = protoProfiles
	}

	return response, nil
}

// UpdateUser modifies user account and profile information
func (s *Service) UpdateUser(ctx context.Context, req *openauth_v1.UpdateUserRequest) (*openauth_v1.UpdateUserResponse, error) {
	logger.Debug(ctx, "UpdateUser request initiated for UUID: %s", req.Uuid)

	if req.Uuid == "" {
		logger.Warn(ctx, "UpdateUser failed: missing UUID")
		return nil, status.Error(codes.InvalidArgument, "uuid is required")
	}

	// Get existing user
	user, err := s.repo.GetUserByUUID(ctx, req.Uuid)
	if err != nil {
		logger.Error(ctx, "Failed to get user by UUID %s: %v", req.Uuid, err)
		return nil, status.Error(codes.NotFound, "user not found")
	}

	logger.Debug(ctx, "Found user for update: userID=%d, username=%s", user.ID, user.Username)

	// Prepare user updates
	userUpdates := make(map[string]interface{})

	// Check if username is being updated and validate uniqueness
	if req.Username != nil && *req.Username != user.Username {
		logger.Debug(ctx, "Username change requested for userID=%d: from '%s' to '%s'",
			user.ID, user.Username, *req.Username)

		// Check if new username already exists
		exists, err := s.repo.CheckUsernameExists(ctx, *req.Username)
		if err != nil {
			logger.Error(ctx, "Failed to check username availability for userID=%d, username='%s': %v",
				user.ID, *req.Username, err)
			return nil, status.Error(codes.Internal, "failed to validate username availability")
		}
		if exists {
			logger.Warn(ctx, "Username update denied for userID=%d: username '%s' already exists",
				user.ID, *req.Username)
			return nil, status.Error(codes.AlreadyExists, "username already exists")
		}
		userUpdates["username"] = *req.Username
	}

	// Check if email is being updated and validate uniqueness
	if req.Email != nil && (user.Email == nil || *req.Email != *user.Email) {
		logger.Debug(ctx, "Email change requested for userID=%d: to '%s'", user.ID, *req.Email)

		// Check if new email already exists
		exists, err := s.repo.CheckEmailExists(ctx, *req.Email)
		if err != nil {
			logger.Error(ctx, "Failed to check email availability for userID=%d, email='%s': %v",
				user.ID, *req.Email, err)
			return nil, status.Error(codes.Internal, "failed to validate email availability")
		}
		if exists {
			logger.Warn(ctx, "Email update denied for userID=%d: email '%s' already exists",
				user.ID, *req.Email)
			return nil, status.Error(codes.AlreadyExists, "email already exists")
		}
		userUpdates["email"] = *req.Email
	}

	if req.Phone != nil {
		userUpdates["phone"] = *req.Phone
	}
	if req.IsActive != nil {
		userUpdates["is_active"] = *req.IsActive
	}
	if req.Name != nil {
		userUpdates["name"] = *req.Name
	}
	if req.AvatarUrl != nil {
		userUpdates["avatar_url"] = *req.AvatarUrl
	}

	// Update user if there are changes
	var updatedUser *dao.User
	if len(userUpdates) > 0 {
		logger.Debug(ctx, "Updating user fields: %v for userID=%d", userUpdates, user.ID)
		userUpdates["updated_at"] = time.Now().Unix()
		updatedUser, err = s.repo.UpdateUser(ctx, user.ID, userUpdates)
		if err != nil {
			logger.Error(ctx, "Failed to update userID=%d: %v", user.ID, err)
			return nil, status.Error(codes.Internal, "failed to update user")
		}
		logger.Info(ctx, "User updated successfully: userID=%d, username=%s",
			updatedUser.ID, updatedUser.Username)
	} else {
		logger.Debug(ctx, "No user updates requested for userID=%d", user.ID)
		updatedUser = user
	}

	return &openauth_v1.UpdateUserResponse{
		User: updatedUser.ToProtoUser(),
	}, nil
}
