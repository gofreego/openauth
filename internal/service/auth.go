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
	// Validate input
	if req.Username == "" || req.Password == nil || *req.Password == "" {
		return nil, status.Error(codes.InvalidArgument, "username and password are required")
	}

	// Detect the type of identifier and find user accordingly
	var user *dao.User
	var err error

	username := strings.TrimSpace(req.Username)
	identifierType := utils.DetectIdentifierType(username)

	switch identifierType {
	case utils.IdentifierTypeUsername:
		user, err = s.repo.GetUserByUsername(ctx, username)
	case utils.IdentifierTypeEmail:
		user, err = s.repo.GetUserByEmail(ctx, username)
	case utils.IdentifierTypePhone:
		// Try phone - you may need to implement GetUserByPhone
		return nil, status.Error(codes.Unimplemented, "phone login not yet implemented")
	default:
		return nil, status.Error(codes.InvalidArgument, "invalid identifier format")
	}

	if err != nil {
		return nil, status.Error(codes.NotFound, "user not found")
	}

	// Check if user is active and not locked
	if !user.IsActive {
		return nil, status.Error(codes.PermissionDenied, "account is disabled")
	}
	if user.IsLocked {
		return nil, status.Error(codes.PermissionDenied, "account is locked")
	}

	// Verify password
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(*req.Password)); err != nil {
		// Increment failed login attempts
		updates := map[string]interface{}{
			"failed_login_attempts": user.FailedLoginCount + 1,
		}

		// Lock account if too many failed attempts
		if user.FailedLoginCount >= s.cfg.Security.GetMaxLoginAttempts()-1 {
			updates["is_locked"] = true
		}

		s.repo.UpdateUser(ctx, user.ID, updates)

		return nil, status.Error(codes.Unauthenticated, "invalid credentials")
	}

	// Reset failed login attempts and update last login
	updates := map[string]interface{}{
		"failed_login_attempts": 0,
		"last_login_at":         time.Now().Unix(),
	}
	s.repo.UpdateUser(ctx, user.ID, updates)

	// Create session
	sessionUUID := uuid.New()
	sessionToken, err := generateSessionToken()
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to generate session token")
	}

	refreshToken, err := generateRefreshToken()
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to generate refresh token")
	}

	// Determine session duration
	accessTokenDuration := s.cfg.JWT.GetAccessTokenTTL()
	refreshTokenDuration := s.cfg.JWT.GetRefreshTokenTTL()

	if req.RememberMe != nil && *req.RememberMe {
		accessTokenDuration = accessTokenDuration * 4   // 4x longer access token
		refreshTokenDuration = refreshTokenDuration * 4 // 4x longer refresh token
	}

	expiresAt := time.Now().Add(accessTokenDuration).Unix()
	refreshExpiresAt := time.Now().Add(refreshTokenDuration).Unix()

	// Create session record using FromSignInRequest method
	session := &dao.Session{}
	session.FromSignInRequest(
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
		return nil, status.Error(codes.Internal, "failed to create session")
	}

	// Generate JWT access token
	accessToken, err := s.generateAccessToken(user, createdSession, accessTokenDuration)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to generate access token")
	}

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
	if req.RefreshToken == "" {
		return nil, status.Error(codes.InvalidArgument, "refresh token is required")
	}

	// Find session by refresh token
	session, err := s.repo.GetSessionByRefreshToken(ctx, req.RefreshToken)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "invalid refresh token")
	}

	// Check if session is active and not expired
	if !session.IsActive {
		return nil, status.Error(codes.Unauthenticated, "session is inactive")
	}

	if session.RefreshExpiresAt != nil && time.Now().Unix() > *session.RefreshExpiresAt {
		return nil, status.Error(codes.Unauthenticated, "refresh token expired")
	}

	// Get user
	user, err := s.repo.GetUserByID(ctx, session.UserID)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to get user")
	}

	// Generate new tokens (token rotation for security)
	newRefreshToken, err := generateRefreshToken()
	if err != nil {
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
		return nil, status.Error(codes.Internal, "failed to update session")
	}

	// Generate new JWT access token
	accessToken, err := s.generateAccessToken(user, updatedSession, accessTokenDuration)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to generate access token")
	}

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
	var sessionsTerminated int32

	if req.AllSessions != nil && *req.AllSessions {
		// Logout from all sessions - need to get user context first
		// This would require extracting user info from the current session
		return nil, status.Error(codes.Unimplemented, "logout from all sessions not implemented yet")
	} else if req.SessionId != nil {
		// Logout from specific session
		err := s.repo.DeleteSession(ctx, *req.SessionId)
		if err != nil {
			return nil, status.Error(codes.Internal, "failed to terminate session")
		}
		sessionsTerminated = 1
	} else {
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
	if req.AccessToken == "" {
		return nil, status.Error(codes.InvalidArgument, "access token is required")
	}

	// Parse and validate JWT token
	claims, err := s.ValidateAccessToken(req.AccessToken)
	if err != nil {
		return &openauth_v1.ValidateTokenResponse{
			Valid:   false,
			Message: "invalid token",
		}, nil
	}

	// Check if session is still active
	session, err := s.repo.GetSessionByUUID(ctx, claims.SessionUUID)
	if err != nil {
		return &openauth_v1.ValidateTokenResponse{
			Valid:   false,
			Message: "session not found",
		}, nil
	}

	if !session.IsActive {
		return &openauth_v1.ValidateTokenResponse{
			Valid:   false,
			Message: "session inactive",
		}, nil
	}

	// Get user info
	user, err := s.repo.GetUserByID(ctx, session.UserID)
	if err != nil {
		return &openauth_v1.ValidateTokenResponse{
			Valid:   false,
			Message: "user not found",
		}, nil
	}

	// Update last activity
	s.repo.UpdateLastActivity(ctx, session.UUID.String())

	expiresAt := claims.RegisteredClaims.ExpiresAt.Unix()
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
func (s *Service) generateAccessToken(user *dao.User, session *dao.Session, duration time.Duration) (string, error) {
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
