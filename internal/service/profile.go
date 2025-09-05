package service

import (
	"context"
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/google/uuid"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

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
