package dao

import (
	"github.com/google/uuid"
)

// AuthProvider represents an OAuth or external provider
type AuthProvider struct {
	ID           int64     `db:"id" json:"id"`
	UUID         uuid.UUID `db:"uuid" json:"uuid"`
	Name         string    `db:"name" json:"name"`
	DisplayName  string    `db:"display_name" json:"displayName"`
	ClientID     string    `db:"client_id" json:"clientId"`
	ClientSecret string    `db:"client_secret" json:"clientSecret"`
	AuthURL      string    `db:"auth_url" json:"authUrl"`
	TokenURL     string    `db:"token_url" json:"tokenUrl"`
	UserInfoURL  string    `db:"user_info_url" json:"userInfoUrl"`
	Scope        string    `db:"scope" json:"scope"`
	IsEnabled    bool      `db:"is_enabled" json:"isEnabled"`
	CreatedAt    int64     `db:"created_at" json:"createdAt"`
	UpdatedAt    int64     `db:"updated_at" json:"updatedAt"`
}

// UserExternalAccount represents linked external accounts for a user
type UserExternalAccount struct {
	ID               int64     `db:"id" json:"id"`
	UUID             uuid.UUID `db:"uuid" json:"uuid"`
	UserID           int64     `db:"user_id" json:"userId"`
	ProviderID       int64     `db:"provider_id" json:"providerId"`
	ExternalUserID   string    `db:"external_user_id" json:"externalUserId"`
	ExternalUsername string    `db:"external_username" json:"externalUsername"`
	ExternalEmail    string    `db:"external_email" json:"externalEmail"`
	AccessToken      string    `db:"access_token" json:"accessToken"`
	RefreshToken     string    `db:"refresh_token" json:"refreshToken"`
	TokenExpiresAt   int64     `db:"token_expires_at" json:"tokenExpiresAt"`
	ExternalData     []byte    `db:"external_data" json:"externalData"` // JSONB → []byte or map[string]any
	CreatedAt        int64     `db:"created_at" json:"createdAt"`
	UpdatedAt        int64     `db:"updated_at" json:"updatedAt"`
}
