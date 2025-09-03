package service

import (
	"context"
	"crypto/rand"
	"fmt"
	"math/big"
	"time"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	communicationservice "github.com/gofreego/openauth/pkg/clients/communication-service"
	"github.com/gofreego/openauth/pkg/utils"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// SignUp creates a new user account in the system
func (s *Service) SignUp(ctx context.Context, req *openauth_v1.SignUpRequest) (*openauth_v1.SignUpResponse, error) {
	logger.Info(ctx, "Sign-up request initiated for username: %s", req.Username)

	// Validate required fields
	if req.Username == "" {
		logger.Warn(ctx, "Sign-up failed: missing username")
		return nil, status.Error(codes.InvalidArgument, "username is required")
	}
	if req.Password == "" {
		logger.Warn(ctx, "Sign-up failed: missing password for username: %s", req.Username)
		return nil, status.Error(codes.InvalidArgument, "password is required")
	}

	// Check if username already exists
	usernameExists, err := s.repo.CheckUsernameExists(ctx, req.Username)
	if err != nil {
		logger.Error(ctx, "Failed to check username availability for %s: %v", req.Username, err)
		return nil, status.Error(codes.Internal, "failed to check username availability")
	}
	if usernameExists {
		logger.Warn(ctx, "Sign-up failed: username already exists: %s", req.Username)
		return nil, status.Error(codes.AlreadyExists, "username already exists")
	}

	// Check if email already exists (if provided)
	if req.Email != nil && *req.Email != "" {
		emailExists, err := s.repo.CheckEmailExists(ctx, *req.Email)
		if err != nil {
			logger.Error(ctx, "Failed to check email availability for %s: %v", *req.Email, err)
			return nil, status.Error(codes.Internal, "failed to check email availability")
		}
		if emailExists {
			logger.Warn(ctx, "Sign-up failed: email already exists: %s", *req.Email)
			return nil, status.Error(codes.AlreadyExists, "email already exists")
		}
	}

	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), s.cfg.Security.BcryptCost)
	if err != nil {
		logger.Error(ctx, "Failed to hash password for username %s: %v", req.Username, err)
		return nil, status.Error(codes.Internal, "failed to hash password")
	}

	userUUID := uuid.New()

	logger.Debug(ctx, "Creating user record for username: %s, userUUID: %s", req.Username, userUUID.String())

	user := new(dao.User).FromSignUpRequest(req, string(hashedPassword))

	// Create user in database
	createdUser, err := s.repo.CreateUser(ctx, user)
	if err != nil {
		logger.Error(ctx, "Failed to create user in database for username %s: %v", req.Username, err)
		return nil, status.Error(codes.Internal, "failed to create user")
	}

	logger.Info(ctx, "User created successfully: userID=%d, username=%s, userUUID=%s",
		createdUser.ID, createdUser.Username, createdUser.UUID.String())

	// Send email verification if email provided
	emailVerificationRequired := false
	if req.Email != nil && *req.Email != "" {
		logger.Debug(ctx, "Sending email verification for userID=%d, email=%s", createdUser.ID, *req.Email)
		if err := s.sendEmailVerification(ctx, createdUser.ID, *req.Email); err != nil {
			// Log error but don't fail registration
			logger.Error(ctx, "Failed to send email verification for userID=%d, email=%s: %v",
				createdUser.ID, *req.Email, err)
		} else {
			emailVerificationRequired = true
			logger.Debug(ctx, "Email verification sent successfully for userID=%d", createdUser.ID)
		}
	}

	// Send phone verification if phone provided
	phoneVerificationRequired := false
	if req.Phone != nil && *req.Phone != "" {
		logger.Debug(ctx, "Sending phone verification for userID=%d, phone=%s", createdUser.ID, *req.Phone)
		if err := s.sendPhoneVerification(ctx, createdUser.ID, *req.Phone); err != nil {
			// Log error but don't fail registration
			logger.Error(ctx, "Failed to send phone verification for userID=%d, phone=%s: %v",
				createdUser.ID, *req.Phone, err)
		} else {
			phoneVerificationRequired = true
			logger.Debug(ctx, "Phone verification sent successfully for userID=%d", createdUser.ID)
		}
	}

	logger.Info(ctx, "Sign-up completed successfully for userID=%d, username=%s, email_verification=%t, phone_verification=%t",
		createdUser.ID, createdUser.Username, emailVerificationRequired, phoneVerificationRequired)

	return &openauth_v1.SignUpResponse{
		User:                      createdUser.ToProtoUser(),
		Message:                   "User created successfully",
		EmailVerificationRequired: emailVerificationRequired,
		PhoneVerificationRequired: phoneVerificationRequired,
	}, nil
}

// VerifyEmail verifies a user's email address using a verification code
func (s *Service) VerifyEmail(ctx context.Context, req *openauth_v1.VerifyEmailRequest) (*openauth_v1.VerificationResponse, error) {
	logger.Info(ctx, "Email verification request initiated for email: %s", req.Email)

	if req.Email == "" {
		logger.Warn(ctx, "Email verification failed: missing email")
		return nil, status.Error(codes.InvalidArgument, "email is required")
	}
	if req.VerificationCode == "" {
		logger.Warn(ctx, "Email verification failed: missing verification code for email: %s", req.Email)
		return nil, status.Error(codes.InvalidArgument, "verification code is required")
	}

	// Get verification token
	otpVerification, err := s.repo.GetOTPVerification(ctx, req.Email, req.VerificationCode)
	if err != nil {
		logger.Warn(ctx, "Email verification failed: invalid verification code for email %s: %v", req.Email, err)
		return nil, status.Error(codes.NotFound, "invalid verification code")
	}

	// Check if expired
	if time.Now().Unix() > otpVerification.ExpiresAt {
		logger.Warn(ctx, "Email verification failed: code expired for email %s, userID=%v",
			req.Email, otpVerification.UserID)
		return nil, status.Error(codes.DeadlineExceeded, "verification code has expired")
	}

	// Check if already used
	if otpVerification.IsUsed {
		logger.Warn(ctx, "Email verification failed: code already used for email %s, userID=%v",
			req.Email, otpVerification.UserID)
		return nil, status.Error(codes.FailedPrecondition, "verification code has already been used")
	}

	// Update user email verification status
	if otpVerification.UserID != nil {
		err = s.repo.UpdateVerificationStatus(ctx, *otpVerification.UserID, "email_verified", true)
		if err != nil {
			logger.Error(ctx, "Failed to update email verification status for userID=%d, email=%s: %v",
				*otpVerification.UserID, req.Email, err)
			return nil, status.Error(codes.Internal, "failed to update verification status")
		}
		logger.Info(ctx, "Email verification status updated for userID=%d, email=%s",
			*otpVerification.UserID, req.Email)
	}

	// Mark OTP as used
	err = s.repo.DeleteOTPVerification(ctx, req.Email, "emailVerification")
	if err != nil {
		// Log error but don't fail the verification
		logger.Error(ctx, "Failed to delete OTP verification for email %s: %v", req.Email, err)
	}

	logger.Info(ctx, "Email verification completed successfully for email: %s", req.Email)

	return &openauth_v1.VerificationResponse{
		Verified: true,
		Message:  "Email verified successfully",
	}, nil
}

// VerifyPhone verifies a user's phone number using a verification code
func (s *Service) VerifyPhone(ctx context.Context, req *openauth_v1.VerifyPhoneRequest) (*openauth_v1.VerificationResponse, error) {
	if req.Phone == "" {
		return nil, status.Error(codes.InvalidArgument, "phone is required")
	}
	if req.VerificationCode == "" {
		return nil, status.Error(codes.InvalidArgument, "verification code is required")
	}

	// Get verification token
	otpVerification, err := s.repo.GetOTPVerification(ctx, req.Phone, req.VerificationCode)
	if err != nil {
		return nil, status.Error(codes.NotFound, "invalid verification code")
	}

	// Check if expired
	if time.Now().Unix() > otpVerification.ExpiresAt {
		return nil, status.Error(codes.DeadlineExceeded, "verification code has expired")
	}

	// Check if already used
	if otpVerification.IsUsed {
		return nil, status.Error(codes.FailedPrecondition, "verification code has already been used")
	}

	// Update user phone verification status
	if otpVerification.UserID != nil {
		err = s.repo.UpdateVerificationStatus(ctx, *otpVerification.UserID, "phone_verified", true)
		if err != nil {
			return nil, status.Error(codes.Internal, "failed to update verification status")
		}
	}

	// Mark OTP as used
	err = s.repo.DeleteOTPVerification(ctx, req.Phone, "phoneVerification")
	if err != nil {
		// Log error but don't fail the verification
	}

	return &openauth_v1.VerificationResponse{
		Verified: true,
		Message:  "Phone verified successfully",
	}, nil
}

func (s *Service) getUserByIdentifier(ctx context.Context, identifier string, identifierType utils.IdentifierType) (*dao.User, error) {
	switch identifierType {
	case utils.IdentifierTypeEmail:
		return s.repo.GetUserByEmail(ctx, identifier)
	case utils.IdentifierTypePhone:
		return s.repo.GetUserByPhone(ctx, identifier)
	default:
		return nil, status.Error(codes.InvalidArgument, "invalid identifier type")
	}
}

// SendVerificationCode implements openauth_v1.OpenAuthServer.
func (s *Service) SendVerificationCode(ctx context.Context, req *openauth_v1.SendVerificationCodeRequest) (*openauth_v1.SendVerificationCodeResponse, error) {

	identifierType := utils.DetectIdentifierType(req.Identifier)
	user, err := s.getUserByIdentifier(ctx, req.Identifier, identifierType)
	if err != nil {
		return nil, status.Error(codes.NotFound, "user not found")
	}

	switch identifierType {
	case utils.IdentifierTypeEmail:
		err = s.sendEmailVerification(ctx, user.ID, req.Identifier)
		if err != nil {
			return nil, status.Error(codes.Internal, "failed to send email verification code")
		}
	case utils.IdentifierTypePhone:
		err = s.sendPhoneVerification(ctx, user.ID, req.Identifier)
		if err != nil {
			return nil, status.Error(codes.Internal, "failed to send SMS verification code")
		}
	default:
		return nil, status.Error(codes.InvalidArgument, "invalid identifier type")
	}
	// No error means the verification code was sent successfully
	logger.Info(ctx, "Verification code sent successfully to %s", req.Identifier)
	return &openauth_v1.SendVerificationCodeResponse{
		Message: "Verification code sent successfully",
		Sent:    true,
	}, nil
}

// CheckUsername checks if a username is available for registration
func (s *Service) CheckUsername(ctx context.Context, req *openauth_v1.CheckUsernameRequest) (*openauth_v1.CheckUsernameResponse, error) {
	if req.Username == "" {
		return nil, status.Error(codes.InvalidArgument, "username is required")
	}

	exists, err := s.repo.CheckUsernameExists(ctx, req.Username)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to check username availability")
	}

	response := &openauth_v1.CheckUsernameResponse{
		Available: !exists,
	}

	if exists {
		response.Message = "Username is already taken"
		response.Suggestions = s.generateUsernameSuggestions(req.Username)
	} else {
		response.Message = "Username is available"
	}

	return response, nil
}

// CheckEmail checks if an email address is available for registration
func (s *Service) CheckEmail(ctx context.Context, req *openauth_v1.CheckEmailRequest) (*openauth_v1.CheckEmailResponse, error) {
	if req.Email == "" {
		return nil, status.Error(codes.InvalidArgument, "email is required")
	}

	exists, err := s.repo.CheckEmailExists(ctx, req.Email)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to check email availability")
	}

	response := &openauth_v1.CheckEmailResponse{
		Available: !exists,
	}

	if exists {
		response.Message = "Email is already registered"
	} else {
		response.Message = "Email is available"
	}

	return response, nil
}

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

// ChangePassword allows users to change their password
func (s *Service) ChangePassword(ctx context.Context, req *openauth_v1.ChangePasswordRequest) (*openauth_v1.ChangePasswordResponse, error) {
	if req.Uuid == "" {
		return nil, status.Error(codes.InvalidArgument, "uuid is required")
	}
	if req.CurrentPassword == "" {
		return nil, status.Error(codes.InvalidArgument, "current password is required")
	}
	if req.NewPassword == "" {
		return nil, status.Error(codes.InvalidArgument, "new password is required")
	}

	// Get user
	user, err := s.repo.GetUserByUUID(ctx, req.Uuid)
	if err != nil {
		return nil, status.Error(codes.NotFound, "user not found")
	}

	// Verify current password
	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.CurrentPassword))
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "current password is incorrect")
	}

	// Hash new password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.NewPassword), s.cfg.Security.BcryptCost)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to hash new password")
	}

	// Update password
	updates := map[string]interface{}{
		"password_hash":       string(hashedPassword),
		"password_changed_at": time.Now().Unix(),
		"updated_at":          time.Now().Unix(),
	}

	_, err = s.repo.UpdateUser(ctx, user.ID, updates)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to update password")
	}

	return &openauth_v1.ChangePasswordResponse{
		Success: true,
		Message: "Password changed successfully",
	}, nil
}

// ListUsers retrieves users with filtering, sorting, and pagination
func (s *Service) ListUsers(ctx context.Context, req *openauth_v1.ListUsersRequest) (*openauth_v1.ListUsersResponse, error) {
	// Set default values
	limit := req.Limit
	if limit <= 0 || limit > 100 {
		limit = 10
	}
	offset := req.Offset
	if offset < 0 {
		offset = 0
	}

	// Prepare filters
	filters := &filter.UserFilter{
		Limit:  limit,
		Offset: offset,
	}

	if req.Search != nil {
		filters.Search = req.Search
	}
	if req.IsActive != nil {
		filters.IsActive = req.IsActive
	}
	if req.EmailVerified != nil {
		filters.EmailVerified = req.EmailVerified
	}
	if req.PhoneVerified != nil {
		filters.PhoneVerified = req.PhoneVerified
	}

	// Get users from repository
	users, err := s.repo.ListUsers(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to list users")
	}

	// Convert to proto
	protoUsers := make([]*openauth_v1.User, len(users))
	for i, user := range users {
		protoUsers[i] = user.ToProtoUser()
	}

	return &openauth_v1.ListUsersResponse{
		Users: protoUsers,
	}, nil
}

// DeleteUser removes or deactivates a user account
func (s *Service) DeleteUser(ctx context.Context, req *openauth_v1.DeleteUserRequest) (*openauth_v1.DeleteUserResponse, error) {
	if req.Uuid == "" {
		return nil, status.Error(codes.InvalidArgument, "uuid is required")
	}

	// Get user to ensure it exists
	user, err := s.repo.GetUserByUUID(ctx, req.Uuid)
	if err != nil {
		return nil, status.Error(codes.NotFound, "user not found")
	}

	// check if user is admin user
	if user.Username == "admin" {
		return nil, status.Error(codes.PermissionDenied, "admin user cannot be deleted")
	}

	// Delete user
	err = s.repo.DeleteUser(ctx, user.ID, req.SoftDelete)
	if err != nil {
		logger.Error(ctx, "Failed to delete userID=%d: %v", user.ID, err)
		return nil, status.Error(codes.Internal, "failed to delete user")
	}

	message := "User deleted successfully"
	if req.SoftDelete {
		message = "User deactivated successfully"
	}

	return &openauth_v1.DeleteUserResponse{
		Success: true,
		Message: message,
	}, nil
}

// Helper functions

func (s *Service) sendEmailVerification(ctx context.Context, userID int64, email string) error {
	// Generate verification code
	code, err := s.generateVerificationCode()
	if err != nil {
		return err
	}

	// Create OTP verification
	otp := &dao.OTPVerification{
		UserID:      &userID,
		Identifier:  email,
		OTPCode:     code,
		OTPType:     "emailVerification",
		IsUsed:      false,
		ExpiresAt:   time.Now().Add(15 * time.Minute).Unix(), // 15 minutes
		Attempts:    0,
		MaxAttempts: 3,
		CreatedAt:   time.Now().Unix(),
	}

	err = s.repo.CreateOTPVerification(ctx, otp)
	if err != nil {
		return err
	}

	err = s.communicationClient.SendEmail(ctx, &communicationservice.SendEmailRequest{
		Email:   email,
		Subject: s.cfg.Communication.EmailVerificationSubject,
		Body:    fmt.Sprintf(s.cfg.Communication.EmailVerificationBody, code),
	})
	if err != nil {
		return err
	}

	return nil
}

func (s *Service) sendPhoneVerification(ctx context.Context, userID int64, phone string) error {
	// Generate verification code
	code, err := s.generateVerificationCode()
	if err != nil {
		return err
	}

	// Create OTP verification
	var userIDPtr *int64
	if userID > 0 {
		userIDPtr = &userID
	}

	otp := &dao.OTPVerification{
		UserID:      userIDPtr,
		Identifier:  phone,
		OTPCode:     code,
		OTPType:     "phoneVerification",
		IsUsed:      false,
		ExpiresAt:   time.Now().Add(15 * time.Minute).Unix(), // 15 minutes
		Attempts:    0,
		MaxAttempts: 3,
		CreatedAt:   time.Now().Unix(),
	}

	err = s.repo.CreateOTPVerification(ctx, otp)
	if err != nil {
		return err
	}

	err = s.communicationClient.SendSMS(ctx, &communicationservice.SendSMSRequest{
		Mobile:  phone,
		Message: fmt.Sprintf(s.cfg.Communication.SMSVerificationMessage, code),
	})
	if err != nil {
		return err
	}

	return nil
}

func (s *Service) generateVerificationCode() (string, error) {
	// Generate 6-digit code
	max := big.NewInt(999999)
	min := big.NewInt(100000)
	n, err := rand.Int(rand.Reader, max.Sub(max, min).Add(max, big.NewInt(1)))
	if err != nil {
		return "", err
	}
	return fmt.Sprintf("%06d", n.Add(n, min).Int64()), nil
}

func (s *Service) generateUsernameSuggestions(username string) []string {
	suggestions := make([]string, 0, 3)

	// Add numbers to the username
	for i := 1; i <= 3; i++ {
		suggestions = append(suggestions, fmt.Sprintf("%s%d", username, i))
	}

	return suggestions
}

// Profile Management Methods

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
		limit = 10
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
