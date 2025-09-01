package dao

import (
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/google/uuid"
)

// Permissions table
type Permission struct {
	ID          int64   `db:"id" json:"id"`
	Name        string  `db:"name" json:"name"` // e.g., users.create
	DisplayName string  `db:"display_name" json:"displayName"`
	Description *string `db:"description" json:"description,omitempty"`
	IsSystem    bool    `db:"is_system" json:"isSystem"` // system permissions cannot be deleted
	CreatedBy   int64   `db:"created_by" json:"createdBy"`
	CreatedAt   int64   `db:"created_at" json:"createdAt"`
	UpdatedAt   int64   `db:"updated_at" json:"updatedAt"`
}

// ToProto converts a Permission DAO to protobuf Permission
func (p *Permission) ToProto() *openauth_v1.Permission {
	proto := &openauth_v1.Permission{
		Id:          p.ID,
		Name:        p.Name,
		DisplayName: p.DisplayName,
		CreatedAt:   p.CreatedAt,
		UpdatedAt:   p.UpdatedAt,
	}

	if p.Description != nil {
		proto.Description = p.Description
	}

	return proto
}

// Groups (roles) table
type Group struct {
	ID          int64     `db:"id" json:"id"`
	UUID        uuid.UUID `db:"uuid" json:"uuid"`
	Name        string    `db:"name" json:"name"`
	DisplayName string    `db:"display_name" json:"displayName"`
	Description *string   `db:"description" json:"description,omitempty"`
	IsSystem    bool      `db:"is_system" json:"isSystem"`
	IsDefault   bool      `db:"is_default" json:"isDefault"`
	CreatedBy   int64     `db:"created_by" json:"createdBy"`
	CreatedAt   int64     `db:"created_at" json:"createdAt"`
	UpdatedAt   int64     `db:"updated_at" json:"updatedAt"`
}

// ToProto converts a Group DAO to protobuf Group
func (g *Group) ToProto() *openauth_v1.Group {
	proto := &openauth_v1.Group{
		Id:          g.ID,
		Name:        g.Name,
		DisplayName: g.DisplayName,
		CreatedAt:   g.CreatedAt,
		UpdatedAt:   g.UpdatedAt,
	}

	if g.Description != nil {
		proto.Description = g.Description
	}

	return proto
}

// Group ↔ Permission junction
type GroupPermission struct {
	ID           int64 `db:"id" json:"id"`
	GroupID      int64 `db:"group_id" json:"groupId"`
	PermissionID int64 `db:"permission_id" json:"permissionId"`
	GrantedBy    int64 `db:"granted_by" json:"grantedBy"`
	CreatedAt    int64 `db:"created_at" json:"createdAt"`
}

// User ↔ Group junction
type UserGroup struct {
	ID         int64  `db:"id" json:"id"`
	UserID     int64  `db:"user_id" json:"userId"`
	GroupID    int64  `db:"group_id" json:"groupId"`
	AssignedBy int64  `db:"assigned_by" json:"assignedBy"`
	ExpiresAt  *int64 `db:"expires_at" json:"expiresAt,omitempty"`
	CreatedAt  int64  `db:"created_at" json:"createdAt"`
}

// Direct User ↔ Permission mapping
type UserPermission struct {
	ID           int64  `db:"id" json:"id"`
	UserID       int64  `db:"user_id" json:"userId"`
	PermissionID int64  `db:"permission_id" json:"permissionId"`
	GrantedBy    int64  `db:"granted_by" json:"grantedBy"`
	ExpiresAt    *int64 `db:"expires_at" json:"expiresAt,omitempty"`
	CreatedAt    int64  `db:"created_at" json:"createdAt"`
}
