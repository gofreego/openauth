package service

import (
	"context"
	"crypto/rand"
	"database/sql"
	"encoding/hex"
	"fmt"
	"strings"
	"time"

	"golang.org/x/crypto/bcrypt"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"github.com/gofreego/openauth/pkg/utils"
	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

// SignIn authenticates a user and creates a new session
func (s *Service) SignIn(ctx context.Context, req *openauth_v1.SignInRequest) (*openauth_v1.SignInResponse, error) {
	logger.Info(ctx, "Sign-in attempt initiated for identifier: %s", req.Username)

	// Validate input
	if req.Username == "" || req.Password == nil || *req.Password == "" {
		logger.Warn(ctx, "Sign-in failed: missing credentials for identifier: %s", req.Username)
		return nil, status.Error(codes.InvalidArgument, "username and password are required")
	}

	// Detect the type of identifier and find user accordingly
	var user *dao.User
	var err error

	username := strings.TrimSpace(req.Username)
	identifierType := utils.DetectIdentifierType(username)
	logger.Debug(ctx, "Detected identifier type: %s for identifier: %s", identifierType, username)

	switch identifierType {
	case utils.IdentifierTypeUsername:
		logger.Debug(ctx, "Looking up user by username: %s", username)
		user, err = s.repo.GetUserByUsername(ctx, username)
	case utils.IdentifierTypeEmail:
		logger.Debug(ctx, "Looking up user by email: %s", username)
		user, err = s.repo.GetUserByEmail(ctx, username)
	case utils.IdentifierTypePhone:
		logger.Warn(ctx, "Phone login attempted but not implemented for: %s", username)
		// Try phone - you may need to implement GetUserByPhone
		return nil, status.Error(codes.Unimplemented, "phone login not yet implemented")
	default:
		logger.Warn(ctx, "Invalid identifier format provided: %s", username)
		return nil, status.Error(codes.InvalidArgument, "invalid identifier format")
	}

	if err != nil {
		logger.Error(ctx, "User lookup failed for identifier %s: %v", username, err)
		return nil, status.Error(codes.NotFound, "user not found")
	}

	logger.Info(ctx, "User found for sign-in: userID=%d, username=%s", user.ID, user.Username)

	// Check if user is active and not locked
	if !user.IsActive {
		logger.Warn(ctx, "Sign-in denied for disabled account: userID=%d, username=%s", user.ID, user.Username)
		return nil, status.Error(codes.PermissionDenied, "account is disabled")
	}
	if user.IsLocked {
		logger.Warn(ctx, "Sign-in denied for locked account: userID=%d, username=%s, failed_attempts=%d",
			user.ID, user.Username, user.FailedLoginCount)
		return nil, status.Error(codes.PermissionDenied, "account is locked")
	}

	// Verify password
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(*req.Password)); err != nil {
		logger.Warn(ctx, "Password verification failed for userID=%d, username=%s, current_failed_attempts=%d",
			user.ID, user.Username, user.FailedLoginCount)

		// Increment failed login attempts
		updates := map[string]interface{}{
			"failed_login_attempts": user.FailedLoginCount + 1,
		}

		// Lock account if too many failed attempts
		if user.FailedLoginCount >= s.cfg.Security.GetMaxLoginAttempts()-1 {
			updates["is_locked"] = true
			logger.Warn(ctx, "Account locked due to too many failed attempts: userID=%d, username=%s, attempts=%d",
				user.ID, user.Username, user.FailedLoginCount+1)
		}

		s.repo.UpdateUser(ctx, user.ID, updates)

		return nil, status.Error(codes.Unauthenticated, "invalid credentials")
	}

	logger.Info(ctx, "Password verification successful for userID=%d, username=%s", user.ID, user.Username)

	// Reset failed login attempts and update last login
	updates := map[string]interface{}{
		"failed_login_attempts": 0,
		"last_login_at":         time.Now().Unix(),
	}
	s.repo.UpdateUser(ctx, user.ID, updates)
	logger.Debug(ctx, "Reset failed login attempts for userID=%d", user.ID)

	// Create session
	sessionUUID := uuid.New()
	sessionToken, err := generateSessionToken()
	if err != nil {
		logger.Error(ctx, "Failed to generate session token for userID=%d: %v", user.ID, err)
		return nil, status.Error(codes.Internal, "failed to generate session token")
	}

	refreshToken, err := generateRefreshToken()
	if err != nil {
		logger.Error(ctx, "Failed to generate refresh token for userID=%d: %v", user.ID, err)
		return nil, status.Error(codes.Internal, "failed to generate refresh token")
	}

	// Determine session duration
	accessTokenDuration := s.cfg.JWT.GetAccessTokenTTL()
	refreshTokenDuration := s.cfg.JWT.GetRefreshTokenTTL()

	if req.RememberMe != nil && *req.RememberMe {
		accessTokenDuration = accessTokenDuration * 4   // 4x longer access token
		refreshTokenDuration = refreshTokenDuration * 4 // 4x longer refresh token
		logger.Debug(ctx, "Remember me enabled for userID=%d, extended durations: access=%v, refresh=%v",
			user.ID, accessTokenDuration, refreshTokenDuration)
	}

	expiresAt := time.Now().Add(accessTokenDuration).Unix()
	refreshExpiresAt := time.Now().Add(refreshTokenDuration).Unix()

	// Create session record using FromSignInRequest method
	session := new(dao.Session).FromSignInRequest(
		sessionUUID,
		user.ID,
		user.UUID,
		sessionToken,
		refreshToken,
		expiresAt,
		refreshExpiresAt,
		req,
	)

	// Save session to database
	createdSession, err := s.repo.CreateSession(ctx, session)
	if err != nil {
		logger.Error(ctx, "Failed to create session for userID=%d: %v", user.ID, err)
		return nil, status.Error(codes.Internal, "failed to create session")
	}

	logger.Info(ctx, "Session created successfully: sessionID=%s, userID=%d", sessionUUID.String(), user.ID)

	// Generate JWT access token
	accessToken, err := s.generateAccessToken(ctx, user, createdSession, accessTokenDuration, req)
	if err != nil {
		logger.Error(ctx, "Failed to generate access token for userID=%d, sessionID=%s: %v",
			user.ID, sessionUUID.String(), err)
		return nil, status.Error(codes.Internal, "failed to generate access token")
	}

	logger.Info(ctx, "Sign-in completed successfully for userID=%d, username=%s, sessionID=%s",
		user.ID, user.Username, sessionUUID.String())

	// Prepare response
	response := &openauth_v1.SignInResponse{
		AccessToken:      accessToken,
		RefreshToken:     refreshToken,
		ExpiresAt:        expiresAt,
		RefreshExpiresAt: refreshExpiresAt,
		User:             user.ToProtoUser(),
		SessionId:        sessionUUID.String(),
		Message:          "Sign in successful",
	}

	return response, nil
}

// RefreshToken generates new access token using refresh token
func (s *Service) RefreshToken(ctx context.Context, req *openauth_v1.RefreshTokenRequest) (*openauth_v1.RefreshTokenResponse, error) {
	logger.Debug(ctx, "Token refresh request initiated")

	if req.RefreshToken == "" {
		logger.Warn(ctx, "Token refresh failed: missing refresh token")
		return nil, status.Error(codes.InvalidArgument, "refresh token is required")
	}

	// Find session by refresh token
	session, err := s.repo.GetSessionByRefreshToken(ctx, req.RefreshToken)
	if err != nil {
		logger.Warn(ctx, "Token refresh failed: invalid refresh token: %v", err)
		return nil, status.Error(codes.Unauthenticated, "invalid refresh token")
	}

	logger.Debug(ctx, "Session found for refresh: sessionID=%s, userID=%d", session.UUID.String(), session.UserID)

	// Check if session is active and not expired
	if !session.IsActive {
		logger.Warn(ctx, "Token refresh denied: session inactive: sessionID=%s, userID=%d",
			session.UUID.String(), session.UserID)
		return nil, status.Error(codes.Unauthenticated, "session is inactive")
	}

	if session.RefreshExpiresAt != nil && time.Now().Unix() > *session.RefreshExpiresAt {
		logger.Warn(ctx, "Token refresh denied: refresh token expired: sessionID=%s, userID=%d, expires_at=%d",
			session.UUID.String(), session.UserID, *session.RefreshExpiresAt)
		return nil, status.Error(codes.Unauthenticated, "refresh token expired")
	}

	// Get user
	user, err := s.repo.GetUserByID(ctx, session.UserID)
	if err != nil {
		logger.Error(ctx, "Failed to get user during token refresh: userID=%d, sessionID=%s: %v",
			session.UserID, session.UUID.String(), err)
		return nil, status.Error(codes.Internal, "failed to get user")
	}

	// Generate new tokens (token rotation for security)
	newRefreshToken, err := generateRefreshToken()
	if err != nil {
		logger.Error(ctx, "Failed to generate new refresh token for userID=%d, sessionID=%s: %v",
			session.UserID, session.UUID.String(), err)
		return nil, status.Error(codes.Internal, "failed to generate new refresh token")
	}

	accessTokenDuration := s.cfg.JWT.GetAccessTokenTTL()
	refreshTokenDuration := s.cfg.JWT.GetRefreshTokenTTL()

	expiresAt := time.Now().Add(accessTokenDuration).Unix()
	refreshExpiresAt := time.Now().Add(refreshTokenDuration).Unix()

	// Update session with new refresh token
	updates := map[string]interface{}{
		"refresh_token":      newRefreshToken,
		"refresh_expires_at": refreshExpiresAt,
		"last_activity_at":   time.Now().Unix(),
	}

	updatedSession, err := s.repo.UpdateSession(ctx, session.UUID.String(), updates)
	if err != nil {
		logger.Error(ctx, "Failed to update session during token refresh: sessionID=%s, userID=%d: %v",
			session.UUID.String(), session.UserID, err)
		return nil, status.Error(codes.Internal, "failed to update session")
	}

	// Generate new JWT access token
	accessToken, err := s.generateAccessToken(ctx, user, updatedSession, accessTokenDuration, nil)
	if err != nil {
		logger.Error(ctx, "Failed to generate new access token: userID=%d, sessionID=%s: %v",
			session.UserID, session.UUID.String(), err)
		return nil, status.Error(codes.Internal, "failed to generate access token")
	}

	logger.Info(ctx, "Token refresh completed successfully: userID=%d, sessionID=%s",
		session.UserID, session.UUID.String())

	return &openauth_v1.RefreshTokenResponse{
		AccessToken:      accessToken,
		RefreshToken:     newRefreshToken,
		ExpiresAt:        expiresAt,
		RefreshExpiresAt: refreshExpiresAt,
		Message:          "Token refreshed successfully",
	}, nil
}

// Logout terminates user session(s)
func (s *Service) Logout(ctx context.Context, req *openauth_v1.LogoutRequest) (*openauth_v1.LogoutResponse, error) {
	logger.Debug(ctx, "Logout request initiated")

	var sessionsTerminated int32

	if req.AllSessions != nil && *req.AllSessions {
		// Logout from all sessions - need to get user context first
		// This would require extracting user info from the current session
		logger.Warn(ctx, "Logout from all sessions requested but not implemented")
		return nil, status.Error(codes.Unimplemented, "logout from all sessions not implemented yet")
	} else if req.SessionId != nil {
		// Logout from specific session
		logger.Debug(ctx, "Terminating specific session: sessionID=%s", *req.SessionId)
		err := s.repo.DeleteSession(ctx, *req.SessionId)
		if err != nil {
			logger.Error(ctx, "Failed to terminate session: sessionID=%s: %v", *req.SessionId, err)
			return nil, status.Error(codes.Internal, "failed to terminate session")
		}
		sessionsTerminated = 1
		logger.Info(ctx, "Session terminated successfully: sessionID=%s", *req.SessionId)
	} else {
		logger.Warn(ctx, "Logout request missing required parameters")
		return nil, status.Error(codes.InvalidArgument, "session_id or all_sessions must be specified")
	}

	return &openauth_v1.LogoutResponse{
		Success:            true,
		Message:            "Logout successful",
		SessionsTerminated: sessionsTerminated,
	}, nil
}

// ValidateToken checks if an access token is valid
func (s *Service) ValidateToken(ctx context.Context, req *openauth_v1.ValidateTokenRequest) (*openauth_v1.ValidateTokenResponse, error) {
	logger.Debug(ctx, "Token validation request initiated")

	if req.AccessToken == "" {
		logger.Warn(ctx, "Token validation failed: missing access token")
		return nil, status.Error(codes.InvalidArgument, "access token is required")
	}

	// Parse and validate JWT token
	claims, err := s.ValidateAccessToken(req.AccessToken)
	if err != nil {
		logger.Warn(ctx, "Token validation failed: invalid JWT token: %v", err)
		return &openauth_v1.ValidateTokenResponse{
			Valid:   false,
			Message: "invalid token",
		}, nil
	}

	logger.Debug(ctx, "JWT claims validated for sessionID=%s", claims.SessionUUID)

	// Check if session is still active
	session, err := s.repo.GetSessionByUUID(ctx, claims.SessionUUID)
	if err != nil {
		logger.Warn(ctx, "Token validation failed: session not found: sessionID=%s: %v", claims.SessionUUID, err)
		return &openauth_v1.ValidateTokenResponse{
			Valid:   false,
			Message: "session not found",
		}, nil
	}

	if !session.IsActive {
		logger.Warn(ctx, "Token validation failed: session inactive: sessionID=%s, userID=%d",
			claims.SessionUUID, session.UserID)
		return &openauth_v1.ValidateTokenResponse{
			Valid:   false,
			Message: "session inactive",
		}, nil
	}

	// Get user info
	user, err := s.repo.GetUserByID(ctx, session.UserID)
	if err != nil {
		logger.Error(ctx, "Token validation failed: user not found: userID=%d, sessionID=%s: %v",
			session.UserID, claims.SessionUUID, err)
		return &openauth_v1.ValidateTokenResponse{
			Valid:   false,
			Message: "user not found",
		}, nil
	}

	// Update last activity
	s.repo.UpdateLastActivity(ctx, session.UUID.String())
	logger.Debug(ctx, "Updated last activity for sessionID=%s", session.UUID.String())

	expiresAt := claims.RegisteredClaims.ExpiresAt.Unix()
	logger.Info(ctx, "Token validation successful: userID=%d, sessionID=%s", session.UserID, claims.SessionUUID)

	return &openauth_v1.ValidateTokenResponse{
		Valid:     true,
		Message:   "token valid",
		User:      user.ToProtoUser(),
		ExpiresAt: &expiresAt,
	}, nil
}

// ListUserSessions retrieves active sessions for a user
func (s *Service) ListUserSessions(ctx context.Context, req *openauth_v1.ListUserSessionsRequest) (*openauth_v1.ListUserSessionsResponse, error) {
	if req.UserUuid == "" {
		return nil, status.Error(codes.InvalidArgument, "user_uuid is required")
	}

	limit := req.Limit
	if limit <= 0 || limit > 100 {
		limit = 20
	}

	offset := req.Offset
	if offset < 0 {
		offset = 0
	}

	activeOnly := req.ActiveOnly != nil && *req.ActiveOnly

	filters := filter.NewUserSessionsFilter(req.UserUuid, limit, offset, activeOnly)
	sessions, err := s.repo.ListUserSessions(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to list sessions")
	}

	// Convert to proto
	protoSessions := make([]*openauth_v1.Session, len(sessions))
	for i, session := range sessions {
		protoSessions[i] = session.ToProtoSession()
	}

	return &openauth_v1.ListUserSessionsResponse{
		Sessions: protoSessions,
	}, nil
}

// TerminateSession ends a specific user session
func (s *Service) TerminateSession(ctx context.Context, req *openauth_v1.TerminateSessionRequest) (*openauth_v1.TerminateSessionResponse, error) {
	if req.SessionId == "" {
		return nil, status.Error(codes.InvalidArgument, "session_id is required")
	}

	err := s.repo.DeleteSession(ctx, req.SessionId)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, status.Error(codes.NotFound, "session not found")
		}
		return nil, status.Error(codes.Internal, "failed to terminate session")
	}

	return &openauth_v1.TerminateSessionResponse{
		Success: true,
		Message: "Session terminated successfully",
	}, nil
}

// Helper functions

// generateSessionToken creates a cryptographically secure session token
func generateSessionToken() (string, error) {
	bytes := make([]byte, 32)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

// generateRefreshToken creates a cryptographically secure refresh token
func generateRefreshToken() (string, error) {
	bytes := make([]byte, 32)
	if _, err := rand.Read(bytes); err != nil {
		return "", err
	}
	return hex.EncodeToString(bytes), nil
}

// generateAccessToken creates a JWT access token
func (s *Service) generateAccessToken(ctx context.Context, user *dao.User, session *dao.Session, duration time.Duration, req *openauth_v1.SignInRequest) (string, error) {
	claims := jwtutils.JWTClaims{
		UserID:      user.ID,
		UserUUID:    user.UUID.String(),
		SessionUUID: session.UUID.String(),
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   user.UUID.String(),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(duration)),
			Issuer:    "openauth",
		},
	}

	if session.DeviceID != nil {
		claims.DeviceID = *session.DeviceID
	}

	// Include profile IDs if requested
	if req != nil && req.Profiles != nil && *req.Profiles {
		profileIDs, err := s.getUserProfileIDs(ctx, user.ID)
		if err != nil {
			return "", fmt.Errorf("failed to get user profile IDs: %w", err)
		}
		claims.ProfileIds = profileIDs
	}

	// Include permissions if requested
	if req != nil && req.IncludePermissions != nil && *req.IncludePermissions {
		permissions, err := s.getUserPermissions(ctx, user.ID)
		if err != nil {
			return "", fmt.Errorf("failed to get user permissions: %w", err)
		}
		claims.Permissions = permissions
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString(s.cfg.JWT.GetSecretKey())
}

// ValidateAccessToken parses and validates a JWT access token
func (s *Service) ValidateAccessToken(tokenString string) (*jwtutils.JWTClaims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &jwtutils.JWTClaims{}, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}
		return s.cfg.JWT.GetSecretKey(), nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*jwtutils.JWTClaims); ok && token.Valid {
		return claims, nil
	}

	return nil, fmt.Errorf("invalid token")
}

// getUserProfileIDs fetches all profile UUIDs for a given user
func (s *Service) getUserProfileIDs(ctx context.Context, userID int64) ([]string, error) {
	user, err := s.repo.GetUserByID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to get user: %w", err)
	}

	profileFilter := &filter.UserProfilesFilter{
		UserUUID: user.UUID.String(),
		Limit:    100, // Set a reasonable limit
		Offset:   0,
	}

	profiles, err := s.repo.ListUserProfiles(ctx, profileFilter)
	if err != nil {
		return nil, fmt.Errorf("failed to list user profiles: %w", err)
	}

	profileIDs := make([]string, len(profiles))
	for i, profile := range profiles {
		profileIDs[i] = profile.UUID.String()
	}

	return profileIDs, nil
}

// getUserPermissions fetches all effective permissions for a given user
func (s *Service) getUserPermissions(ctx context.Context, userID int64) ([]string, error) {
	permissionFilter := &filter.UserEffectivePermissionFilter{
		UserID: userID,
		Limit:  100, // Set a reasonable limit
		Offset: 0,
	}

	permissions, err := s.repo.GetUserEffectivePermissions(ctx, permissionFilter)
	if err != nil {
		return nil, fmt.Errorf("failed to get user permissions: %w", err)
	}

	permissionNames := make([]string, len(permissions))
	for i, permission := range permissions {
		permissionNames[i] = permission.Name
	}

	return permissionNames, nil
}
