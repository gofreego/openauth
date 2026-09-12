package service

import (
	"context"
	"database/sql"
	"fmt"
	"slices"
	"strings"
	"time"

	"google.golang.org/api/idtoken"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/google/uuid"
)

const googleAuthProviderName = "google"

// GoogleSignIn authenticates a user via a Google-issued ID token, creating a
// new (or linking an existing) user on first sign-in.
func (s *Service) GoogleSignIn(ctx context.Context, req *openauth_v1.GoogleSignInRequest) (*openauth_v1.SignInResponse, error) {
	logger.Info(ctx, "Google sign-in attempt initiated")

	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Google sign-in failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	payload, err := idtoken.Validate(ctx, req.IdToken, "")
	if err != nil {
		logger.Warn(ctx, "Google sign-in failed: invalid id token: %v", err)
		return nil, status.Error(codes.Unauthenticated, "invalid Google id token")
	}

	if payload.Issuer != "accounts.google.com" && payload.Issuer != "https://accounts.google.com" {
		logger.Warn(ctx, "Google sign-in failed: unexpected issuer: %s", payload.Issuer)
		return nil, status.Error(codes.Unauthenticated, "invalid Google id token")
	}

	if !slices.Contains(s.cfg.GoogleOAuth.ClientIDs, payload.Audience) {
		logger.Warn(ctx, "Google sign-in failed: unrecognized audience: %s", payload.Audience)
		return nil, status.Error(codes.Unauthenticated, "invalid Google id token")
	}

	googleUserID := payload.Subject
	email, _ := payload.Claims["email"].(string)
	emailVerified, _ := payload.Claims["email_verified"].(bool)
	name, _ := payload.Claims["name"].(string)
	picture, _ := payload.Claims["picture"].(string)

	provider, err := s.repo.GetAuthProviderByName(ctx, googleAuthProviderName)
	if err != nil || !provider.IsEnabled {
		logger.Error(ctx, "Google sign-in failed: auth provider not configured: %v", err)
		return nil, status.Error(codes.FailedPrecondition, "google sign-in is not enabled")
	}

	user, err := s.findOrCreateGoogleUser(ctx, provider.ID, googleUserID, email, emailVerified, name, picture)
	if err != nil {
		logger.Error(ctx, "Google sign-in failed to resolve user: %v", err)
		return nil, status.Error(codes.Internal, "failed to authenticate")
	}

	if !user.IsActive {
		logger.Warn(ctx, "Google sign-in denied for disabled account: userID=%d", user.ID)
		return nil, status.Error(codes.PermissionDenied, "account is disabled")
	}
	if user.IsLocked {
		logger.Warn(ctx, "Google sign-in denied for locked account: userID=%d", user.ID)
		return nil, status.Error(codes.PermissionDenied, "your account is locked, please contact customer support")
	}

	updates := map[string]interface{}{
		"failed_login_attempts": 0,
		"last_login_at":         time.Now().UnixMilli(),
	}
	user, err = s.repo.UpdateUser(ctx, user.ID, updates)
	if err != nil {
		logger.Error(ctx, "Google sign-in failed to update login info for userID=%d: %v", user.ID, err)
		return nil, status.Error(codes.Internal, "failed to update user login info")
	}

	sessionUUID := uuid.New()
	sessionToken, err := generateSessionToken()
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to generate session token")
	}
	refreshToken, err := generateRefreshToken()
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to generate refresh token")
	}

	accessTokenDuration := s.cfg.JWT.AccessTokenTTL
	refreshTokenDuration := s.cfg.JWT.RefreshTokenTTL
	expiresAt := time.Now().Add(accessTokenDuration).UnixMilli()
	refreshExpiresAt := time.Now().Add(refreshTokenDuration).UnixMilli()

	session := new(dao.Session).FromMetadata(
		sessionUUID, user.ID, user.UUID, sessionToken, refreshToken, expiresAt, refreshExpiresAt, req.Metadata,
	)

	createdSession, err := s.repo.CreateSession(ctx, session)
	if err != nil {
		logger.Error(ctx, "Google sign-in failed to create session for userID=%d: %v", user.ID, err)
		return nil, status.Error(codes.Internal, "failed to create session")
	}

	includePermissions := req.IncludePermissions != nil && *req.IncludePermissions
	accessToken, err := s.generateAccessToken(ctx, user, createdSession, accessTokenDuration, includePermissions)
	if err != nil {
		logger.Error(ctx, "Google sign-in failed to generate access token for userID=%d: %v", user.ID, err)
		return nil, status.Error(codes.Internal, "failed to generate access token")
	}

	logger.Info(ctx, "Google sign-in completed successfully for userID=%d, sessionID=%s", user.ID, sessionUUID.String())

	return &openauth_v1.SignInResponse{
		AccessToken:      accessToken,
		RefreshToken:     refreshToken,
		ExpiresAt:        expiresAt,
		RefreshExpiresAt: refreshExpiresAt,
		User:             user.ToProtoUser(),
		SessionId:        sessionUUID.String(),
		Message:          "Sign in successful",
	}, nil
}

// findOrCreateGoogleUser resolves the local user for a Google account: reuses
// a previously-linked user, links an existing verified-email account, or
// creates a brand-new user.
func (s *Service) findOrCreateGoogleUser(ctx context.Context, providerID int64, googleUserID, email string, emailVerified bool, name, picture string) (*dao.User, error) {
	externalAccount, err := s.repo.GetUserExternalAccount(ctx, providerID, googleUserID)
	if err == nil {
		user, getErr := s.repo.GetUserByID(ctx, externalAccount.UserID)
		if getErr != nil {
			return nil, getErr
		}
		// Self-heal accounts linked before this check existed: Google has
		// verified this email, so don't leave it stuck unverified forever.
		if emailVerified && !user.EmailVerified {
			if err := s.repo.UpdateVerificationStatus(ctx, user.ID, "email_verified", true); err != nil {
				return nil, err
			}
			user.EmailVerified = true
		}
		return user, nil
	}
	if err != sql.ErrNoRows {
		return nil, err
	}

	var user *dao.User
	if email != "" && emailVerified {
		if existing, lookupErr := s.repo.GetUserByEmail(ctx, email); lookupErr == nil {
			user = existing
			// Google has already verified this email, but a user who signed
			// up with a password (and never completed the OTP flow) would
			// otherwise stay email_verified=false forever after linking.
			if !user.EmailVerified {
				if err := s.repo.UpdateVerificationStatus(ctx, user.ID, "email_verified", true); err != nil {
					return nil, err
				}
				user.EmailVerified = true
			}
		}
	}

	if user == nil {
		usernameBase := googleAuthProviderName
		if email != "" {
			usernameBase = strings.SplitN(email, "@", 2)[0]
		}
		username, err := s.generateUniqueUsernameFromBase(ctx, usernameBase)
		if err != nil {
			return nil, err
		}

		var namePtr, avatarPtr *string
		if name != "" {
			namePtr = &name
		}
		if picture != "" {
			avatarPtr = &picture
		}

		newUser, err := new(dao.User).FromGoogleSignIn(username, email, emailVerified, namePtr, avatarPtr)
		if err != nil {
			return nil, err
		}

		user, err = s.repo.CreateUser(ctx, newUser)
		if err != nil {
			return nil, err
		}
	}

	externalUsername := name
	externalEmail := email
	now := time.Now().UnixMilli()
	_, err = s.repo.CreateUserExternalAccount(ctx, &dao.UserExternalAccount{
		UserID:           user.ID,
		ProviderID:       providerID,
		ExternalUserID:   googleUserID,
		ExternalUsername: &externalUsername,
		ExternalEmail:    &externalEmail,
		CreatedAt:        now,
		UpdatedAt:        now,
	})
	if err != nil {
		return nil, err
	}

	return user, nil
}
