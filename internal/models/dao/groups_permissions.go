package dao

import (
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
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

func (p *Permission) FromCreatePermissionRequest(req *openauth_v1.CreatePermissionRequest, createdBy int64) *Permission {
	p.Name = req.Name
	p.DisplayName = req.DisplayName
	p.Description = req.Description
	p.IsSystem = false
	p.CreatedBy = createdBy
	p.CreatedAt = time.Now().Unix()
	p.UpdatedAt = time.Now().Unix()
	return p
}

// ToProtoPermission converts a Permission DAO to protobuf Permission
func (p *Permission) ToProtoPermission() *openauth_v1.Permission {
	proto := &openauth_v1.Permission{
		Id:          p.ID,
		Name:        p.Name,
		DisplayName: p.DisplayName,
		CreatedBy:   p.CreatedBy,
		CreatedAt:   p.CreatedAt,
		UpdatedAt:   p.UpdatedAt,
		IsSystem:    p.IsSystem,
	}

	if p.Description != nil {
		proto.Description = p.Description
	}

	return proto
}

// Groups (roles) table
type Group struct {
	ID          int64   `db:"id" json:"id"`
	Name        string  `db:"name" json:"name"`
	DisplayName string  `db:"display_name" json:"displayName"`
	Description *string `db:"description" json:"description,omitempty"`
	IsSystem    bool    `db:"is_system" json:"isSystem"`
	IsDefault   bool    `db:"is_default" json:"isDefault"`
	CreatedBy   int64   `db:"created_by" json:"createdBy"`
	CreatedAt   int64   `db:"created_at" json:"createdAt"`
	UpdatedAt   int64   `db:"updated_at" json:"updatedAt"`
}

func (g *Group) FromCreateGroupRequest(req *openauth_v1.CreateGroupRequest, createdBy int64) *Group {
	g.Name = req.Name
	g.DisplayName = req.DisplayName
	g.Description = req.Description
	g.IsSystem = false
	g.IsDefault = req.IsDefault
	g.CreatedBy = createdBy
	g.CreatedAt = time.Now().Unix()
	g.UpdatedAt = time.Now().Unix()
	return g
}

// ToProtoGroup converts a Group DAO to protobuf Group
func (g *Group) ToProtoGroup() *openauth_v1.Group {
	proto := &openauth_v1.Group{
		Id:          g.ID,
		Name:        g.Name,
		DisplayName: g.DisplayName,
		CreatedBy:   g.CreatedBy,
		CreatedAt:   g.CreatedAt,
		UpdatedAt:   g.UpdatedAt,
		IsSystem:    g.IsSystem,
	}

	if g.Description != nil {
		proto.Description = g.Description
	}

	return proto
}

// ToProtoUserGroup converts a Group DAO to protobuf UserGroup for user group listings
func (g *Group) ToProtoUserGroup(assignedAt int64) *openauth_v1.UserGroup {
	return &openauth_v1.UserGroup{
		GroupId:          g.ID,
		GroupName:        g.Name,
		GroupDisplayName: g.DisplayName,
		GroupDescription: g.Description,
		IsSystem:         g.IsSystem,
		IsDefault:        g.IsDefault,
		AssignedAt:       assignedAt,
	}
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

type EffectivePermission struct {
	// Permission details
	PermissionId          int64   `db:"permission_id" json:"permissionId,omitempty"`
	PermissionName        string  `db:"permission_name" json:"permissionName,omitempty"`
	PermissionDisplayName string  `db:"permission_display_name" json:"permissionDisplayName,omitempty"`
	PermissionDescription *string `db:"permission_description" json:"permissionDescription,omitempty"`
	// Source of the permission: "direct" or "group"
	Source string `db:"source" json:"source,omitempty"`
	// If source is "group", this contains the group details
	GroupId          *int64  `db:"group_id" json:"groupId,omitempty"`
	GroupName        *string `db:"group_name" json:"groupName,omitempty"`
	GroupDisplayName *string `db:"group_display_name" json:"groupDisplayName,omitempty"`
	// If source is "direct", this may contain expiration info
	ExpiresAt *int64 `db:"expires_at" json:"expiresAt,omitempty"`
	// When this permission was granted
	GrantedAt int64 `db:"granted_at" json:"grantedAt,omitempty"`
	// Who granted this permission
	GrantedBy int64 `db:"granted_by" json:"grantedBy,omitempty"`
}

func (p *EffectivePermission) ToProtoUserEffectivePermission() *openauth_v1.EffectivePermission {
	return &openauth_v1.EffectivePermission{
		PermissionId:          p.PermissionId,
		PermissionName:        p.PermissionName,
		PermissionDisplayName: p.PermissionDisplayName,
		PermissionDescription: p.PermissionDescription,
		Source:                p.Source,
		GroupId:               p.GroupId,
		GroupName:             p.GroupName,
		GroupDisplayName:      p.GroupDisplayName,
		ExpiresAt:             p.ExpiresAt,
		GrantedAt:             p.GrantedAt,
		GrantedBy:             p.GrantedBy,
	}
}
