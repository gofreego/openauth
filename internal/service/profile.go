package service

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/mediabase/api/mediabase_v1"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// CreateProfile creates a new profile for a user
func (s *Service) CreateProfile(ctx context.Context, req *openauth_v1.CreateProfileRequest) (*openauth_v1.CreateProfileResponse, error) {
	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Create profile failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionProfilesCreate) && claims.UserID != req.UserId {
		logger.Warn(ctx, "userID=%d does not have permission to read groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read groups")
	}

	// Verify user exists
	user, err := s.repo.GetUserByID(ctx, req.UserId)
	if err != nil {
		return nil, status.Error(codes.NotFound, "user not found")
	}

	profile := new(dao.Profile).FromCreateProfileRequest(req, user.ID)

	// Validate country field - must be 2-character ISO code or empty
	if req.Country != nil && len(*req.Country) > 2 {
		logger.Error(ctx, "Invalid country code provided for user id %d: %s (must be 2 characters or less)", req.UserId, *req.Country)
		return nil, status.Error(codes.InvalidArgument, "country must be a 2-character ISO country code")
	}

	// Handle metadata - ensure it's valid JSON or null
	if len(req.Metadata) > 0 {
		// Validate that the metadata is valid JSON
		if json.Valid(req.Metadata) {
			profile.Metadata = req.Metadata
		} else {
			logger.Error(ctx, "Invalid JSON metadata provided for user id %d: %s", req.UserId, req.Metadata)
			return nil, status.Error(codes.InvalidArgument, "invalid JSON metadata")
		}
	} else {
		// Set to nil for NULL in database
		profile.Metadata = nil
	}

	// Debug: Log the metadata being passed
	logger.Info(ctx, "Creating profile with metadata: %s", string(profile.Metadata))

	createdProfile, err := s.repo.CreateUserProfile(ctx, profile)
	if err != nil {
		logger.Error(ctx, "Failed to create profile for user UUID %d: %v", req.UserId, err)
		return nil, status.Error(codes.Internal, "failed to create profile")
	}

	return &openauth_v1.CreateProfileResponse{
		Profile: createdProfile.ToProtoUserProfile(),
		Message: "Profile created successfully",
	}, nil
}

// ListUserProfiles retrieves all profiles for a user
func (s *Service) ListUserProfiles(ctx context.Context, req *openauth_v1.ListUserProfilesRequest) (*openauth_v1.ListUserProfilesResponse, error) {
	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "List user profiles failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionProfilesRead) && claims.UserUUID != req.UserUuid {
		logger.Warn(ctx, "userID=%d does not have permission to read profiles", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read profiles")
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
	filters := filter.NewUserProfilesFilter(req.UserUuid, limit, offset)
	profiles, err := s.repo.ListUserProfiles(ctx, filters)
	if err != nil {
		logger.Error(ctx, "Failed to list profiles for user UUID %s: %v", req.UserUuid, err)
		return nil, status.Error(codes.Internal, "failed to list profiles")
	}

	// Convert to proto
	protoProfiles := make([]*openauth_v1.UserProfile, len(profiles))
	for i, profile := range profiles {
		protoProfiles[i] = profile.ToProtoUserProfile()
	}

	return &openauth_v1.ListUserProfilesResponse{
		Profiles: protoProfiles,
	}, nil
}

// UpdateProfile modifies an existing profile
func (s *Service) UpdateProfile(ctx context.Context, req *openauth_v1.UpdateProfileRequest) (*openauth_v1.UpdateProfileResponse, error) {
	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Update profile failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Get existing profile
	profile, err := s.repo.GetProfileByUUID(ctx, req.ProfileUuid)
	if err != nil {
		return nil, status.Error(codes.NotFound, "profile not found")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionProfilesUpdate) && claims.UserID != profile.UserID {
		logger.Warn(ctx, "userID=%d does not have permission to update profiles", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to update profiles")
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
		dob, err := time.Parse(time.DateOnly, *req.DateOfBirth)
		if err != nil {
			logger.Error(ctx, "Invalid date_of_birth format provided for profile UUID %s: %s", req.ProfileUuid, *req.DateOfBirth)
			return nil, status.Error(codes.InvalidArgument, "date_of_birth must be in yyyy-mm-dd format")
		}
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
		if len(*req.Country) > 2 {
			logger.Error(ctx, "Invalid country code provided: %s (must be 2 characters or less)", *req.Country)
			return nil, status.Error(codes.InvalidArgument, "country must be a 2-character ISO country code")
		}
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
		// Validate that the metadata is valid JSON if it's not empty
		if len(req.Metadata) > 0 {
			if json.Valid(req.Metadata) {
				updates["metadata"] = req.Metadata
			} else {
				logger.Error(ctx, "Invalid JSON metadata provided for profile UUID %s", req.ProfileUuid)
				return nil, status.Error(codes.InvalidArgument, "invalid JSON metadata")
			}
		} else {
			// Set to nil for NULL in database when empty
			updates["metadata"] = nil
		}
	}

	// Update profile if there are changes
	var updatedProfile *dao.Profile
	if len(updates) > 0 {
		// Note: updated_at is automatically set by the repository
		updatedProfile, err = s.repo.UpdateProfileByUUID(ctx, req.ProfileUuid, updates)
		if err != nil {
			logger.Error(ctx, "Failed to update profile for user UUID %s: %v", profile.UserID, err)
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
	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Delete profile failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Get profile to ensure it exists
	profile, err := s.repo.GetProfileByUUID(ctx, req.ProfileUuid)
	if err != nil {
		return nil, status.Error(codes.NotFound, "profile not found")
	}

	// check for permissions
	if !claims.HasPermission(constants.PermissionProfilesDelete) && claims.UserID != profile.UserID {
		logger.Warn(ctx, "userID=%d does not have permission to delete profiles", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to delete profiles")
	}

	// Get user to get UUID for counting profiles
	user, err := s.repo.GetUserByID(ctx, profile.UserID)
	if err != nil {
		logger.Error(ctx, "Failed to get user for profile UUID %s: %v", req.ProfileUuid, err)
		return nil, status.Error(codes.Internal, "failed to get user")
	}

	// Check if this is the user's last profile (optional business rule)
	userProfileCount, err := s.repo.CountUserProfiles(ctx, user.UUID.String())
	if err != nil {
		logger.Error(ctx, "Failed to count profiles for user UUID %s: %v", user.UUID.String(), err)
		return nil, status.Error(codes.Internal, "failed to check profile count")
	}
	if userProfileCount <= 1 {
		return nil, status.Error(codes.FailedPrecondition, "cannot delete the last profile")
	}

	// Delete profile
	err = s.repo.DeleteProfileByUUID(ctx, req.ProfileUuid)
	if err != nil {
		logger.Error(ctx, "Failed to delete profile UUID %s: %v", req.ProfileUuid, err)
		return nil, status.Error(codes.Internal, "failed to delete profile")
	}

	return &openauth_v1.DeleteProfileResponse{
		Success: true,
		Message: "Profile deleted successfully",
	}, nil
}

// GetProfileUploadURL generates a presigned URL for uploading a profile image
func (s *Service) GetProfileUploadURL(ctx context.Context, req *openauth_v1.GetProfileUploadURLRequest) (*openauth_v1.GetProfileUploadURLResponse, error) {
	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Get profile upload URL failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Get existing profile to verify ownership
	profile, err := s.repo.GetProfileByUUID(ctx, req.ProfileUuid)
	if err != nil {
		return nil, status.Error(codes.NotFound, "profile not found")
	}

	// check for permissions
	if !claims.HasPermission(constants.PermissionProfilesUpdate) && claims.UserID != profile.UserID {
		logger.Warn(ctx, "userID=%d does not have permission to update profiles", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to get upload URL")
	}

	// Prepare mediabase request
	// We'll store profile images in a path like profiles
	path := "profiles"
	fileName := fmt.Sprintf("%s.webp", req.ProfileUuid)

	mediabaseReq := &mediabase_v1.PresignUploadRequest{
		BucketName:  s.cfg.Mediabase.BucketName,
		Path:        path,
		FileName:    fileName,
		ContentType: "image/webp",
	}

	// Call mediabase service
	if s.mediabaseClient == nil {
		return nil, status.Error(codes.Internal, "mediabase service client not initialized")
	}

	resp, err := s.mediabaseClient.PresignUpload(ctx, mediabaseReq)
	if err != nil {
		logger.Error(ctx, "Failed to get presigned URL from mediabase: %v", err)
		return nil, status.Error(codes.Internal, "failed to generate upload URL")
	}

	return &openauth_v1.GetProfileUploadURLResponse{
		UploadUrl: resp.GetPresignedUrl(),
		ObjectKey: resp.GetObjectKey(),
		FormData:  resp.GetFormData(),
		ExpiresIn: resp.GetExpiresIn(),
	}, nil
}
