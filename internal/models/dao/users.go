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

func (u *User) FromSignUpRequest(req *openauth_v1.SignUpRequest, hashedPassword string) *User {
	now := time.Now().UnixMilli()
	u.UUID = uuid.New()
	u.Username = req.Username
	u.Email = req.Email
	u.Phone = req.Phone
	u.Name = req.Name
	u.AvatarURL = nil
	u.PasswordHash = hashedPassword
	u.EmailVerified = false
	u.PhoneVerified = false
	u.IsActive = true
	u.IsLocked = false
	u.FailedLoginCount = 0
	u.PasswordChangedAt = now
	u.CreatedAt = now
	u.UpdatedAt = now
	return u
}
