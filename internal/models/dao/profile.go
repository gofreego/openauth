package dao

import (
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/google/uuid"
)

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

func (p *Profile) FromCreateProfileRequest(req *openauth_v1.CreateProfileRequest, userId int64) *Profile {
	var dob *time.Time
	if req.DateOfBirth != nil {
		d := time.UnixMilli(*req.DateOfBirth)
		dob = &d
	}
	now := time.Now().Unix()
	p.UUID = uuid.New()
	p.UserID = userId
	p.ProfileName = req.ProfileName
	p.FirstName = req.FirstName
	p.LastName = req.LastName
	p.DisplayName = req.DisplayName
	p.Bio = req.Bio
	p.AvatarURL = req.AvatarUrl
	p.Gender = req.Gender
	p.DateOfBirth = dob
	p.Timezone = req.Timezone
	p.Locale = req.Locale
	p.Country = req.Country
	p.City = req.City
	p.Address = req.Address
	p.PostalCode = req.PostalCode
	p.WebsiteURL = req.WebsiteUrl
	p.CreatedAt = now
	p.UpdatedAt = now
	return p
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
