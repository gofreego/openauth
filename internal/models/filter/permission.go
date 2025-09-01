package filter

import (
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
)

// PermissionFilter represents the filter criteria for querying permissions
type PermissionFilter struct {
	// Search term to filter by name, display_name, or description
	Search *string `json:"search,omitempty"`

	// Resource filters permissions by resource name (e.g., "user", "group")
	Resource *string `json:"resource,omitempty"`

	// Action filters permissions by action (e.g., "create", "read", "update", "delete")
	Action *string `json:"action,omitempty"`

	// IsSystem filters permissions by system status
	IsSystem *bool `json:"is_system,omitempty"`

	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`

	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`
}

// FromListPermissionsRequest creates a PermissionFilter from a ListPermissionsRequest
func FromListPermissionsRequest(req *openauth_v1.ListPermissionsRequest) *PermissionFilter {
	filter := &PermissionFilter{}

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

	// Note: Resource, Action, and IsSystem fields don't exist in ListPermissionsRequest
	// They can be set separately if needed

	return filter
}

// HasSearch returns true if search filter is set and not empty
func (f *PermissionFilter) HasSearch() bool {
	return f.Search != nil && *f.Search != ""
}

// HasResource returns true if resource filter is set and not empty
func (f *PermissionFilter) HasResource() bool {
	return f.Resource != nil && *f.Resource != ""
}

// HasAction returns true if action filter is set and not empty
func (f *PermissionFilter) HasAction() bool {
	return f.Action != nil && *f.Action != ""
}

// HasIsSystem returns true if is_system filter is set
func (f *PermissionFilter) HasIsSystem() bool {
	return f.IsSystem != nil
}
