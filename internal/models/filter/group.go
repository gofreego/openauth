package filter

import (
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
)

// GroupFilter represents the filter criteria for querying groups
type GroupFilter struct {
	// Search term to filter by name, display_name, or description
	Search *string `json:"search,omitempty"`

	// IsSystem filters groups by system status
	IsSystem *bool `json:"is_system,omitempty"`

	// IsDefault filters groups by default status
	IsDefault *bool `json:"is_default,omitempty"`

	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`

	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`

	// All indicates whether to fetch all groups without pagination
	All bool `json:"all,omitempty"`
}

// FromListGroupsRequest creates a GroupFilter from a ListGroupsRequest
func FromListGroupsRequest(req *openauth_v1.ListGroupsRequest) *GroupFilter {
	filter := &GroupFilter{}

	// Set pagination with defaults
	filter.Limit = req.Limit
	if filter.Limit <= 0 || filter.Limit > 100 {
		filter.Limit = constants.DefaultPageSize
	}

	filter.Offset = req.Offset
	if filter.Offset < 0 {
		filter.Offset = 0
	}

	// Set search filter if provided
	if req.Search != nil && *req.Search != "" {
		filter.Search = req.Search
	}

	// Set all filter if provided
	filter.All = req.All

	// Note: IsSystem and IsDefault fields don't exist in ListGroupsRequest
	// They can be set separately if needed

	return filter
}

// HasSearch returns true if search filter is set and not empty
func (f *GroupFilter) HasSearch() bool {
	return f.Search != nil && *f.Search != ""
}

// HasIsSystem returns true if is_system filter is set
func (f *GroupFilter) HasIsSystem() bool {
	return f.IsSystem != nil
}

// HasIsDefault returns true if is_default filter is set
func (f *GroupFilter) HasIsDefault() bool {
	return f.IsDefault != nil
}
