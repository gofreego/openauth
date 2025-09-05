package service

import (
	"context"
	"fmt"
	"time"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"github.com/google/uuid"
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

// CreateProfile creates a new profile for a user
func (s *Service) CreateProfile(ctx context.Context, req *openauth_v1.CreateProfileRequest) (*openauth_v1.CreateProfileResponse, error) {
	if req.UserUuid == "" {
		return nil, status.Error(codes.InvalidArgument, "user_uuid is required")
	}

	// Verify user exists
	user, err := s.repo.GetUserByUUID(ctx, req.UserUuid)
	if err != nil {
		return nil, status.Error(codes.NotFound, "user not found")
	}

	// Create profile
	now := time.Now().Unix()
	profile := &dao.Profile{
		UUID:        uuid.New(),
		UserID:      user.ID,
		ProfileName: req.ProfileName,
		FirstName:   req.FirstName,
		LastName:    req.LastName,
		DisplayName: req.DisplayName,
		Bio:         req.Bio,
		AvatarURL:   req.AvatarUrl,
		Gender:      req.Gender,
		Timezone:    req.Timezone,
		Locale:      req.Locale,
		Country:     req.Country,
		City:        req.City,
		Address:     req.Address,
		PostalCode:  req.PostalCode,
		WebsiteURL:  req.WebsiteUrl,
		Metadata:    req.Metadata,
		CreatedAt:   now,
		UpdatedAt:   now,
	}

	// Handle date of birth conversion
	if req.DateOfBirth != nil {
		dob := time.Unix(*req.DateOfBirth, 0)
		profile.DateOfBirth = &dob
	}

	createdProfile, err := s.repo.CreateUserProfile(ctx, profile)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to create profile")
	}

	return &openauth_v1.CreateProfileResponse{
		Profile: createdProfile.ToProtoUserProfile(),
		Message: "Profile created successfully",
	}, nil
}

// ListUserProfiles retrieves all profiles for a user
func (s *Service) ListUserProfiles(ctx context.Context, req *openauth_v1.ListUserProfilesRequest) (*openauth_v1.ListUserProfilesResponse, error) {
	if req.UserUuid == "" {
		return nil, status.Error(codes.InvalidArgument, "user_uuid is required")
	}

	// Verify user exists
	user, err := s.repo.GetUserByUUID(ctx, req.UserUuid)
	if err != nil {
		return nil, status.Error(codes.NotFound, "user not found")
	}

	// Set default pagination
	limit := req.Limit
	if limit <= 0 || limit > 100 {
		limit = constants.DefaultPageSize
	}
	offset := req.Offset
	if offset < 0 {
		offset = 0
	}

	// Get profiles for user
	filters := filter.NewUserProfilesFilter(user.UUID.String(), limit, offset)
	profiles, err := s.repo.ListUserProfiles(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to list profiles")
	}

	// Convert to proto
	protoProfiles := make([]*openauth_v1.UserProfile, len(profiles))
	for i, profile := range profiles {
		protoProfiles[i] = profile.ToProtoUserProfile()
	}

	return &openauth_v1.ListUserProfilesResponse{
		Profiles: protoProfiles,
		Limit:    limit,
		Offset:   offset,
	}, nil
}

// UpdateProfile modifies an existing profile
func (s *Service) UpdateProfile(ctx context.Context, req *openauth_v1.UpdateProfileRequest) (*openauth_v1.UpdateProfileResponse, error) {
	if req.ProfileUuid == "" {
		return nil, status.Error(codes.InvalidArgument, "profile_uuid is required")
	}

	// Get existing profile
	profile, err := s.repo.GetProfileByUUID(ctx, req.ProfileUuid)
	if err != nil {
		return nil, status.Error(codes.NotFound, "profile not found")
	}

	// Prepare updates
	updates := make(map[string]interface{})
	if req.ProfileName != nil {
		updates["profile_name"] = *req.ProfileName
	}
	if req.FirstName != nil {
		updates["first_name"] = *req.FirstName
	}
	if req.LastName != nil {
		updates["last_name"] = *req.LastName
	}
	if req.DisplayName != nil {
		updates["display_name"] = *req.DisplayName
	}
	if req.Bio != nil {
		updates["bio"] = *req.Bio
	}
	if req.AvatarUrl != nil {
		updates["avatar_url"] = *req.AvatarUrl
	}
	if req.DateOfBirth != nil {
		dob := time.Unix(*req.DateOfBirth, 0)
		updates["date_of_birth"] = dob
	}
	if req.Gender != nil {
		updates["gender"] = *req.Gender
	}
	if req.Timezone != nil {
		updates["timezone"] = *req.Timezone
	}
	if req.Locale != nil {
		updates["locale"] = *req.Locale
	}
	if req.Country != nil {
		updates["country"] = *req.Country
	}
	if req.City != nil {
		updates["city"] = *req.City
	}
	if req.Address != nil {
		updates["address"] = *req.Address
	}
	if req.PostalCode != nil {
		updates["postal_code"] = *req.PostalCode
	}
	if req.WebsiteUrl != nil {
		updates["website_url"] = *req.WebsiteUrl
	}
	if req.Metadata != nil {
		updates["metadata"] = req.Metadata
	}

	// Update profile if there are changes
	var updatedProfile *dao.Profile
	if len(updates) > 0 {
		updates["updated_at"] = time.Now().Unix()
		updatedProfile, err = s.repo.UpdateProfileByUUID(ctx, req.ProfileUuid, updates)
		if err != nil {
			return nil, status.Error(codes.Internal, "failed to update profile")
		}
	} else {
		updatedProfile = profile
	}

	return &openauth_v1.UpdateProfileResponse{
		Profile: updatedProfile.ToProtoUserProfile(),
		Message: "Profile updated successfully",
	}, nil
}

// DeleteProfile removes a specific profile
func (s *Service) DeleteProfile(ctx context.Context, req *openauth_v1.DeleteProfileRequest) (*openauth_v1.DeleteProfileResponse, error) {
	if req.ProfileUuid == "" {
		return nil, status.Error(codes.InvalidArgument, "profile_uuid is required")
	}

	// Get profile to ensure it exists
	profile, err := s.repo.GetProfileByUUID(ctx, req.ProfileUuid)
	if err != nil {
		return nil, status.Error(codes.NotFound, "profile not found")
	}

	// Get user to get UUID for counting profiles
	user, err := s.repo.GetUserByID(ctx, profile.UserID)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to get user")
	}

	// Check if this is the user's last profile (optional business rule)
	userProfileCount, err := s.repo.CountUserProfiles(ctx, user.UUID.String())
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to check profile count")
	}
	if userProfileCount <= 1 {
		return nil, status.Error(codes.FailedPrecondition, "cannot delete the last profile")
	}

	// Delete profile
	err = s.repo.DeleteProfileByUUID(ctx, req.ProfileUuid)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to delete profile")
	}

	return &openauth_v1.DeleteProfileResponse{
		Success: true,
		Message: "Profile deleted successfully",
	}, nil
}
