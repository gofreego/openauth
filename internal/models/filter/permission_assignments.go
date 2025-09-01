package filter

import (
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
)

// GroupPermissionFilter represents the filter criteria for querying group permissions
type GroupPermissionFilter struct {
	// Group ID to filter by
	GroupID int64 `json:"group_id"`

	// Permission ID to filter by (optional)
	PermissionID *int64 `json:"permission_id,omitempty"`

	// Search term to filter by permission name, display_name, or description
	Search *string `json:"search,omitempty"`

	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`

	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`
}

// FromListGroupPermissionsRequest creates a GroupPermissionFilter from a ListGroupPermissionsRequest
func FromListGroupPermissionsRequest(req *openauth_v1.ListGroupPermissionsRequest) *GroupPermissionFilter {
	filter := &GroupPermissionFilter{
		GroupID: req.GroupId,
	}

	// Set pagination with defaults
	if req.Limit != nil {
		filter.Limit = *req.Limit
	}
	if filter.Limit <= 0 || filter.Limit > constants.MaxPageSize {
		filter.Limit = constants.DefaultPageSize
	}

	if req.Offset != nil {
		filter.Offset = *req.Offset
	}
	if filter.Offset < 0 {
		filter.Offset = 0
	}

	// Set search filter if provided
	if req.Search != nil && *req.Search != "" {
		filter.Search = req.Search
	}

	return filter
}

// UserPermissionFilter represents the filter criteria for querying user permissions
type UserPermissionFilter struct {
	// User ID to filter by
	UserID int64 `json:"user_id"`

	// Permission ID to filter by (optional)
	PermissionID *int64 `json:"permission_id,omitempty"`

	// Search term to filter by permission name, display_name, or description
	Search *string `json:"search,omitempty"`

	// Filter by expiration status
	// true: only show expired permissions
	// false: only show non-expired permissions
	// nil: show all permissions
	Expired *bool `json:"expired,omitempty"`

	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`

	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`
}

// FromListUserPermissionsRequest creates a UserPermissionFilter from a ListUserPermissionsRequest
func FromListUserPermissionsRequest(req *openauth_v1.ListUserPermissionsRequest) *UserPermissionFilter {
	filter := &UserPermissionFilter{
		UserID: req.UserId,
	}

	// Set pagination with defaults
	if req.Limit != nil {
		filter.Limit = *req.Limit
	}
	if filter.Limit <= 0 || filter.Limit > constants.MaxPageSize {
		filter.Limit = constants.DefaultPageSize
	}

	if req.Offset != nil {
		filter.Offset = *req.Offset
	}
	if filter.Offset < 0 {
		filter.Offset = 0
	}

	// Set search filter if provided
	if req.Search != nil && *req.Search != "" {
		filter.Search = req.Search
	}

	// Set expired filter if provided
	if req.Expired != nil {
		filter.Expired = req.Expired
	}

	return filter
}

// UserEffectivePermissionFilter represents the filter criteria for querying user effective permissions
type UserEffectivePermissionFilter struct {
	// User ID to filter by
	UserID int64 `json:"user_id"`

	// Search term to filter by permission name, display_name, or description
	Search *string `json:"search,omitempty"`

	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`

	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`
}

// FromGetUserEffectivePermissionsRequest creates a UserEffectivePermissionFilter from a GetUserEffectivePermissionsRequest
func FromGetUserEffectivePermissionsRequest(req *openauth_v1.GetUserEffectivePermissionsRequest) *UserEffectivePermissionFilter {
	filter := &UserEffectivePermissionFilter{
		UserID: req.UserId,
	}

	// Set pagination with defaults
	if req.Limit != nil {
		filter.Limit = *req.Limit
	}
	if filter.Limit <= 0 || filter.Limit > constants.MaxPageSize {
		filter.Limit = constants.DefaultPageSize
	}

	if req.Offset != nil {
		filter.Offset = *req.Offset
	}
	if filter.Offset < 0 {
		filter.Offset = 0
	}

	// Set search filter if provided
	if req.Search != nil && *req.Search != "" {
		filter.Search = req.Search
	}

	return filter
}
