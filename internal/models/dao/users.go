package dao

import (
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/google/uuid"
)

type User struct {
	ID                int64     `db:"id" json:"id"`
	UUID              uuid.UUID `db:"uuid" json:"uuid"`
	Username          string    `db:"username" json:"username"`
	Email             *string   `db:"email" json:"email,omitempty"`
	Phone             *string   `db:"phone" json:"phone,omitempty"`
	Name              *string   `db:"name" json:"name,omitempty"`
	AvatarURL         *string   `db:"avatar_url" json:"avatarUrl,omitempty"`
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
	ProfileName *string    `db:"profile_name" json:"profileName,omitempty"` // Name/label for this profile
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

// ToProtoUser converts a User DAO to protobuf User
func (u *User) ToProtoUser() *openauth_v1.User {
	return &openauth_v1.User{
		Id:                  u.ID,
		Uuid:                u.UUID.String(),
		Username:            u.Username,
		Email:               u.Email,
		Phone:               u.Phone,
		Name:                u.Name,
		AvatarUrl:           u.AvatarURL,
		EmailVerified:       u.EmailVerified,
		PhoneVerified:       u.PhoneVerified,
		IsActive:            u.IsActive,
		IsLocked:            u.IsLocked,
		FailedLoginAttempts: int32(u.FailedLoginCount),
		LastLoginAt:         u.LastLoginAt,
		PasswordChangedAt:   u.PasswordChangedAt,
		CreatedAt:           u.CreatedAt,
		UpdatedAt:           u.UpdatedAt,
	}
}

// ToProtoGroupUser converts a User DAO to protobuf GroupUser for group user listings
func (u *User) ToProtoGroupUser(assignedAt int64) *openauth_v1.GroupUser {
	return &openauth_v1.GroupUser{
		UserId:     u.ID,
		UserUuid:   u.UUID.String(),
		Username:   u.Username,
		Email:      u.Email,
		Name:       u.Name,
		AssignedAt: assignedAt,
	}
}

// ToProtoUserProfile converts a Profile DAO to protobuf UserProfile
func (p *Profile) ToProtoUserProfile() *openauth_v1.UserProfile {
	var dateOfBirth *int64
	if p.DateOfBirth != nil {
		timestamp := p.DateOfBirth.Unix()
		dateOfBirth = &timestamp
	}

	return &openauth_v1.UserProfile{
		Id:          p.ID,
		Uuid:        p.UUID.String(),
		UserId:      p.UserID,
		ProfileName: p.ProfileName,
		FirstName:   p.FirstName,
		LastName:    p.LastName,
		DisplayName: p.DisplayName,
		Bio:         p.Bio,
		AvatarUrl:   p.AvatarURL,
		DateOfBirth: dateOfBirth,
		Gender:      p.Gender,
		Timezone:    p.Timezone,
		Locale:      p.Locale,
		Country:     p.Country,
		City:        p.City,
		Address:     p.Address,
		PostalCode:  p.PostalCode,
		WebsiteUrl:  p.WebsiteURL,
		Metadata:    p.Metadata,
		CreatedAt:   p.CreatedAt,
		UpdatedAt:   p.UpdatedAt,
	}
}
