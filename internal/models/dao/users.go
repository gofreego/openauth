package dao

import (
	"crypto/rand"
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
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

// FromGoogleSignIn builds a User for a first-time Google sign-in. Since the
// account has no password, PasswordHash is set to a bcrypt hash of a random
// token that is never handed back to anyone, so password-based SignIn will
// always fail for this account (the user must keep using Google to sign in,
// or set a password explicitly via a future "set password" flow).
func (u *User) FromGoogleSignIn(username string, email string, emailVerified bool, name *string, avatarURL *string) (*User, error) {
	randomBytes := make([]byte, 32)
	if _, err := rand.Read(randomBytes); err != nil {
		return nil, err
	}
	unusablePasswordHash, err := bcrypt.GenerateFromPassword(randomBytes, bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}

	now := time.Now().UnixMilli()
	u.UUID = uuid.New()
	u.Username = username
	u.Email = &email
	u.Name = name
	u.AvatarURL = avatarURL
	u.PasswordHash = string(unusablePasswordHash)
	u.EmailVerified = emailVerified
	u.PhoneVerified = false
	u.IsActive = true
	u.IsLocked = false
	u.FailedLoginCount = 0
	u.PasswordChangedAt = now
	u.CreatedAt = now
	u.UpdatedAt = now
	return u, nil
}

func (u *User) FromSignUpRequest(req *openauth_v1.SignUpRequest, username string, hashedPassword string) *User {
	now := time.Now().UnixMilli()
	u.UUID = uuid.New()
	u.Username = username
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
