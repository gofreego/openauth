package dao

import "github.com/google/uuid"

type Session struct {
	ID               int64     `db:"id" json:"id"`
	UUID             uuid.UUID `db:"uuid" json:"uuid"`
	UserID           int64     `db:"user_id" json:"userId"`
	SessionToken     string    `db:"session_token" json:"sessionToken"`
	RefreshToken     *string   `db:"refresh_token" json:"refreshToken,omitempty"`
	DeviceID         *string   `db:"device_id" json:"deviceId,omitempty"`
	DeviceName       *string   `db:"device_name" json:"deviceName,omitempty"`
	DeviceType       *string   `db:"device_type" json:"deviceType,omitempty"` // web, mobile, desktop
	UserAgent        *string   `db:"user_agent" json:"userAgent,omitempty"`
	IPAddress        *string   `db:"ip_address" json:"ipAddress,omitempty"` // stored as INET
	Location         *string   `db:"location" json:"location,omitempty"`
	IsActive         bool      `db:"is_active" json:"isActive"`
	ExpiresAt        int64     `db:"expires_at" json:"expiresAt"`
	RefreshExpiresAt *int64    `db:"refresh_expires_at" json:"refreshExpiresAt,omitempty"`
	LastActivityAt   int64     `db:"last_activity_at" json:"lastActivityAt"`
	CreatedAt        int64     `db:"created_at" json:"createdAt"`
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
