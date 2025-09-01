package dao

import (
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/google/uuid"
)

type Session struct {
	ID               int64     `db:"id" json:"id"`
	UUID             uuid.UUID `db:"uuid" json:"uuid"`
	UserID           int64     `db:"user_id" json:"userId"`
	UserUUID         uuid.UUID `db:"user_uuid" json:"userUuid"` // For easier lookups
	SessionToken     string    `db:"session_token" json:"sessionToken"`
	RefreshToken     *string   `db:"refresh_token" json:"refreshToken,omitempty"`
	DeviceID         *string   `db:"device_id" json:"deviceId,omitempty"`
	DeviceName       *string   `db:"device_name" json:"deviceName,omitempty"`
	DeviceType       *string   `db:"device_type" json:"deviceType,omitempty"` // web, mobile, desktop
	UserAgent        *string   `db:"user_agent" json:"userAgent,omitempty"`
	IPAddress        *string   `db:"ip_address" json:"ipAddress,omitempty"` // stored as INET
	Location         *string   `db:"location" json:"location,omitempty"`
	Lat              *float64  `db:"lat" json:"lat,omitempty"`
	Lon              *float64  `db:"lon" json:"lon,omitempty"`
	IsActive         bool      `db:"is_active" json:"isActive"`
	ExpiresAt        int64     `db:"expires_at" json:"expiresAt"`
	RefreshExpiresAt *int64    `db:"refresh_expires_at" json:"refreshExpiresAt,omitempty"`
	LastActivityAt   int64     `db:"last_activity_at" json:"lastActivityAt"`
	CreatedAt        int64     `db:"created_at" json:"createdAt"`
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
) {
	s.UUID = sessionUUID
	s.UserID = userID
	s.UserUUID = userUUID
	s.SessionToken = sessionToken
	s.RefreshToken = &refreshToken
	s.IsActive = true
	s.ExpiresAt = expiresAt
	s.RefreshExpiresAt = &refreshExpiresAt
	s.LastActivityAt = time.Now().Unix()
	s.CreatedAt = time.Now().Unix()

	// Set device information if provided
	if req.Metadata != nil {
		if req.Metadata.DeviceId != nil {
			s.DeviceID = req.Metadata.DeviceId
		}
		if req.Metadata.DeviceName != nil {
			s.DeviceName = req.Metadata.DeviceName
		}
		if req.Metadata.DeviceType != nil {
			s.DeviceType = req.Metadata.DeviceType
		}
	}
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
