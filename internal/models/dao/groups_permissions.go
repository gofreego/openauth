package dao

import (
	"time"

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

// ToProtoGroupPermission converts a GroupPermission DAO to protobuf GroupPermission
func (gp *GroupPermission) ToProtoGroupPermission() *openauth_v1.GroupPermission {
	return &openauth_v1.GroupPermission{
		Id:           gp.ID,
		GroupId:      gp.GroupID,
		PermissionId: gp.PermissionID,
		GrantedBy:    gp.GrantedBy,
		CreatedAt:    gp.CreatedAt,
	}
}

// ToProtoGroupPermissionWithDetails converts a GroupPermission DAO to protobuf GroupPermission with additional details
func (gp *GroupPermission) ToProtoGroupPermissionWithDetails(
	permissionName, permissionDisplayName string,
	permissionDescription *string,
	groupName, groupDisplayName string,
	groupDescription *string,
) *openauth_v1.GroupPermission {
	proto := &openauth_v1.GroupPermission{
		Id:                    gp.ID,
		GroupId:               gp.GroupID,
		PermissionId:          gp.PermissionID,
		PermissionName:        permissionName,
		PermissionDisplayName: permissionDisplayName,
		GroupName:             groupName,
		GroupDisplayName:      groupDisplayName,
		GrantedBy:             gp.GrantedBy,
		CreatedAt:             gp.CreatedAt,
	}

	if permissionDescription != nil {
		proto.PermissionDescription = permissionDescription
	}

	if groupDescription != nil {
		proto.GroupDescription = groupDescription
	}

	return proto
}

// ToProtoUserPermission converts a UserPermission DAO to protobuf UserPermission
func (up *UserPermission) ToProtoUserPermission() *openauth_v1.UserPermission {
	proto := &openauth_v1.UserPermission{
		Id:           up.ID,
		UserId:       up.UserID,
		PermissionId: up.PermissionID,
		GrantedBy:    up.GrantedBy,
		CreatedAt:    up.CreatedAt,
	}

	if up.ExpiresAt != nil {
		proto.ExpiresAt = up.ExpiresAt
	}

	return proto
}

// ToProtoUserPermissionWithDetails converts a UserPermission DAO to protobuf UserPermission with additional details
func (up *UserPermission) ToProtoUserPermissionWithDetails(
	permissionName, permissionDisplayName string,
	permissionDescription *string,
	userUuid, username string,
	userEmail, userDisplayName *string,
) *openauth_v1.UserPermission {
	proto := &openauth_v1.UserPermission{
		Id:                    up.ID,
		UserId:                up.UserID,
		PermissionId:          up.PermissionID,
		PermissionName:        permissionName,
		PermissionDisplayName: permissionDisplayName,
		UserUuid:              userUuid,
		Username:              username,
		GrantedBy:             up.GrantedBy,
		CreatedAt:             up.CreatedAt,
	}

	if permissionDescription != nil {
		proto.PermissionDescription = permissionDescription
	}

	if userEmail != nil {
		proto.UserEmail = userEmail
	}

	if userDisplayName != nil {
		proto.UserDisplayName = userDisplayName
	}

	if up.ExpiresAt != nil {
		proto.ExpiresAt = up.ExpiresAt
	}

	return proto
}
