package dao

import (
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/google/uuid"
)

type Session struct {
	ID                  int64      `db:"id" json:"id"`
	UUID                uuid.UUID  `db:"uuid" json:"uuid"`
	UserID              int64      `db:"user_id" json:"userId"`
	UserUUID            uuid.UUID  `db:"user_uuid" json:"userUuid"` // For easier lookups
	SessionToken        string     `db:"session_token" json:"sessionToken"`
	RefreshToken        *string    `db:"refresh_token" json:"refreshToken,omitempty"`
	DeviceID            *string    `db:"device_id" json:"deviceId,omitempty"`
	DeviceName          *string    `db:"device_name" json:"deviceName,omitempty"`
	DeviceType          *string    `db:"device_type" json:"deviceType,omitempty"` // web, mobile, desktop
	UserAgent           *string    `db:"user_agent" json:"userAgent,omitempty"`
	IPAddress           *string    `db:"ip_address" json:"ipAddress,omitempty"` // stored as INET
	Location            *string    `db:"location" json:"location,omitempty"`
	Lat                 *float64   `db:"lat" json:"lat,omitempty"`
	Lon                 *float64   `db:"lon" json:"lon,omitempty"`
	IsActive            bool       `db:"is_active" json:"isActive"`
	Status              string     `db:"status" json:"status"` // active, expired, revoked, logged_out
	ExpiresAt           int64      `db:"expires_at" json:"expiresAt"`
	RefreshExpiresAt    *int64     `db:"refresh_expires_at" json:"refreshExpiresAt,omitempty"`
	LastActivityAt      int64      `db:"last_activity_at" json:"lastActivityAt"`
	RevokedAt           *int64     `db:"revoked_at" json:"revokedAt,omitempty"`
	CreatedAt           int64      `db:"created_at" json:"createdAt"`
	LoginToken          *uuid.UUID `db:"login_token" json:"loginToken,omitempty"`
	LoginTokenExpiresAt *int64     `db:"login_token_expires_at" json:"loginTokenExpiresAt,omitempty"`
}

// FromSignInRequest initializes a Session DAO from SignInRequest data
func (s *Session) FromSignInRequest(
	sessionUUID uuid.UUID,
	userID int64,
	userUUID uuid.UUID,
	sessionToken string,
	refreshToken string,
	expiresAt int64,
	refreshExpiresAt int64,
	req *openauth_v1.SignInRequest,
) *Session {
	return s.FromMetadata(sessionUUID, userID, userUUID, sessionToken, refreshToken, expiresAt, refreshExpiresAt, req.Metadata)
}

// FromMetadata initializes a Session DAO from raw sign-in metadata, shared by
// every sign-in path (password, login-token, Google, ...).
func (s *Session) FromMetadata(
	sessionUUID uuid.UUID,
	userID int64,
	userUUID uuid.UUID,
	sessionToken string,
	refreshToken string,
	expiresAt int64,
	refreshExpiresAt int64,
	metadata *openauth_v1.SignInMetadata,
) *Session {
	s.UUID = sessionUUID
	s.UserID = userID
	s.UserUUID = userUUID
	s.SessionToken = sessionToken
	s.RefreshToken = &refreshToken
	s.IsActive = true
	s.Status = "active"
	s.ExpiresAt = expiresAt
	s.RefreshExpiresAt = &refreshExpiresAt
	s.LastActivityAt = time.Now().UnixMilli()
	s.CreatedAt = time.Now().UnixMilli()

	// Set device information if provided
	if metadata != nil {
		if metadata.DeviceId != nil {
			s.DeviceID = metadata.DeviceId
		}
		if metadata.DeviceName != nil {
			s.DeviceName = metadata.DeviceName
		}
		if metadata.DeviceType != nil {
			s.DeviceType = metadata.DeviceType
		}
	}
	return s
}

// ToProtoSession converts Session DAO to protobuf Session
func (s *Session) ToProtoSession() *openauth_v1.Session {
	session := &openauth_v1.Session{
		Id:             s.UUID.String(),
		UserId:         s.UserUUID.String(),
		IsActive:       s.IsActive,
		ExpiresAt:      s.ExpiresAt,
		LastActivityAt: s.LastActivityAt,
		CreatedAt:      s.CreatedAt,
	}

	if s.DeviceID != nil {
		session.DeviceId = *s.DeviceID
	}
	if s.DeviceName != nil {
		session.DeviceName = *s.DeviceName
	}
	if s.DeviceType != nil {
		session.DeviceType = *s.DeviceType
	}
	if s.UserAgent != nil {
		session.UserAgent = *s.UserAgent
	}
	if s.IPAddress != nil {
		session.IpAddress = *s.IPAddress
	}
	if s.Location != nil {
		session.Location = *s.Location
	}

	return session
}

// SessionArchive represents an archived session record
type SessionArchive struct {
	ID               int64     `db:"id" json:"id"`
	OriginalID       int64     `db:"original_id" json:"originalId"`
	UUID             uuid.UUID `db:"uuid" json:"uuid"`
	UserID           int64     `db:"user_id" json:"userId"`
	UserUUID         uuid.UUID `db:"user_uuid" json:"userUuid"`
	SessionToken     *string   `db:"session_token" json:"sessionToken,omitempty"`
	RefreshToken     *string   `db:"refresh_token" json:"refreshToken,omitempty"`
	DeviceID         *string   `db:"device_id" json:"deviceId,omitempty"`
	DeviceName       *string   `db:"device_name" json:"deviceName,omitempty"`
	DeviceType       *string   `db:"device_type" json:"deviceType,omitempty"`
	UserAgent        *string   `db:"user_agent" json:"userAgent,omitempty"`
	IPAddress        *string   `db:"ip_address" json:"ipAddress,omitempty"`
	Location         *string   `db:"location" json:"location,omitempty"`
	Lat              *float64  `db:"lat" json:"lat,omitempty"`
	Lon              *float64  `db:"lon" json:"lon,omitempty"`
	IsActive         bool      `db:"is_active" json:"isActive"`
	Status           string    `db:"status" json:"status"` // archived, deleted
	ExpiresAt        int64     `db:"expires_at" json:"expiresAt"`
	RefreshExpiresAt *int64    `db:"refresh_expires_at" json:"refreshExpiresAt,omitempty"`
	LastActivityAt   int64     `db:"last_activity_at" json:"lastActivityAt"`
	RevokedAt        *int64    `db:"revoked_at" json:"revokedAt,omitempty"`
	CreatedAt        int64     `db:"created_at" json:"createdAt"`
	ArchivedAt       int64     `db:"archived_at" json:"archivedAt"`
}

type SessionActivity struct {
	ID           int64   `db:"id" json:"id"`
	SessionID    int64   `db:"session_id" json:"sessionId"`
	ActivityType string  `db:"activity_type" json:"activityType"` // login, logout, refresh, access
	IPAddress    *string `db:"ip_address" json:"ipAddress,omitempty"`
	UserAgent    *string `db:"user_agent" json:"userAgent,omitempty"`
	Location     *string `db:"location" json:"location,omitempty"`
	Metadata     []byte  `db:"metadata" json:"metadata,omitempty"` // JSONB
	CreatedAt    int64   `db:"created_at" json:"createdAt"`
}
