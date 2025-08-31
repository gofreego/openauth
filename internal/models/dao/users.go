package dao

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	ID                int64     `db:"id" json:"id"`
	UUID              uuid.UUID `db:"uuid" json:"uuid"`
	Username          string    `db:"username" json:"username"`
	Email             *string   `db:"email" json:"email,omitempty"`
	Phone             *string   `db:"phone" json:"phone,omitempty"`
	PasswordHash      string    `db:"password_hash" json:"passwordHash"`
	EmailVerified     bool      `db:"email_verified" json:"emailVerified"`
	PhoneVerified     bool      `db:"phone_verified" json:"phoneVerified"`
	IsActive          bool      `db:"is_active" json:"isActive"`
	IsLocked          bool      `db:"is_locked" json:"isLocked"`
	FailedLoginCount  int       `db:"failed_login_attempts" json:"failedLoginAttempts"`
	LastLoginAt       *int64    `db:"last_login_at" json:"lastLoginAt,omitempty"`
	PasswordChangedAt int64     `db:"password_changed_at" json:"passwordChangedAt"`
	CreatedAt         int64     `db:"created_at" json:"createdAt"`
	UpdatedAt         int64     `db:"updated_at" json:"updatedAt"`
}

type Profile struct {
	ID          int64      `db:"id" json:"id"`
	UUID        uuid.UUID  `db:"uuid" json:"uuid"`
	UserID      int64      `db:"user_id" json:"userId"`
	FirstName   *string    `db:"first_name" json:"firstName,omitempty"`
	LastName    *string    `db:"last_name" json:"lastName,omitempty"`
	DisplayName *string    `db:"display_name" json:"displayName,omitempty"`
	Bio         *string    `db:"bio" json:"bio,omitempty"`
	AvatarURL   *string    `db:"avatar_url" json:"avatarUrl,omitempty"`
	DateOfBirth *time.Time `db:"date_of_birth" json:"dateOfBirth,omitempty"`
	Gender      *string    `db:"gender" json:"gender,omitempty"`
	Timezone    *string    `db:"timezone" json:"timezone,omitempty"`
	Locale      *string    `db:"locale" json:"locale,omitempty"`
	Country     *string    `db:"country" json:"country,omitempty"`
	City        *string    `db:"city" json:"city,omitempty"`
	Address     *string    `db:"address" json:"address,omitempty"`
	PostalCode  *string    `db:"postal_code" json:"postalCode,omitempty"`
	WebsiteURL  *string    `db:"website_url" json:"websiteUrl,omitempty"`
	Metadata    []byte     `db:"metadata" json:"metadata,omitempty"` // JSONB as raw bytes
	CreatedAt   int64      `db:"created_at" json:"createdAt"`
	UpdatedAt   int64      `db:"updated_at" json:"updatedAt"`
}
