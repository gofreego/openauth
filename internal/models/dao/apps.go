package dao

import (
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
)

// App represents the apps table
type App struct {
	ID          int64   `db:"id" json:"id"`
	Name        string  `db:"name" json:"name"`
	Description *string `db:"description" json:"description,omitempty"`
	URL         string  `db:"url" json:"url"`
	LogoURL     *string `db:"logo_url" json:"logoUrl,omitempty"`
	CreatedAt   int64   `db:"created_at" json:"createdAt"`
	UpdatedAt   int64   `db:"updated_at" json:"updatedAt"`
}

// UserApp represents the user_apps table
type UserApp struct {
	ID         int64 `db:"id" json:"id"`
	UserID     int64 `db:"user_id" json:"userId"`
	AppID      int64 `db:"app_id" json:"appId"`
	AssignedBy int64 `db:"assigned_by" json:"assignedBy"`
	CreatedAt  int64 `db:"created_at" json:"createdAt"`
}

// FromCreateAppRequest creates an App from a protobuf request
func (a *App) FromCreateAppRequest(req *openauth_v1.CreateAppRequest) *App {
	a.Name = req.Name
	a.URL = req.Url
	
	if req.Description != nil {
		desc := *req.Description
		a.Description = &desc
	}
	
	if req.LogoUrl != nil {
		logo := *req.LogoUrl
		a.LogoURL = &logo
	}

	a.CreatedAt = time.Now().UnixMilli()
	a.UpdatedAt = time.Now().UnixMilli()
	return a
}

// ToProtoApp converts an App DAO to protobuf App
func (a *App) ToProtoApp() *openauth_v1.App {
	proto := &openauth_v1.App{
		Id:        a.ID,
		Name:      a.Name,
		Url:       a.URL,
		CreatedAt: a.CreatedAt,
		UpdatedAt: a.UpdatedAt,
	}

	if a.Description != nil {
		desc := *a.Description
		proto.Description = &desc
	}

	if a.LogoURL != nil {
		logo := *a.LogoURL
		proto.LogoUrl = &logo
	}

	return proto
}
