package filter

import (
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
)

// ConfigEntityFilter represents the filter criteria for querying config entities
type ConfigEntityFilter struct {
	// Search term to filter by name or display_name
	Search *string `json:"search,omitempty"`

	// Status filters entities by status (active, deprecated, maintenance)
	Status *string `json:"status,omitempty"`

	// ReadPerm filters entities by read permission ID
	ReadPerm *int64 `json:"read_perm,omitempty"`

	// WritePerm filters entities by write permission ID
	WritePerm *int64 `json:"write_perm,omitempty"`

	// CreatedBy filters entities by creator user ID
	CreatedBy *int64 `json:"created_by,omitempty"`

	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`

	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`

	// All indicates whether to fetch all entities without pagination
	All bool `json:"all,omitempty"`
}

// NewConfigEntityFilterFromProtoRequest creates a ConfigEntityFilter from protobuf request
func NewConfigEntityFilterFromProtoRequest(req *openauth_v1.ListConfigEntitiesRequest) *ConfigEntityFilter {
	filter := &ConfigEntityFilter{
		Limit:  req.Limit,
		Offset: req.Offset,
		All:    req.All,
	}

	if req.Search != nil {
		filter.Search = req.Search
	}

	// Set default limit if not specified
	if filter.Limit == 0 && !filter.All {
		filter.Limit = constants.DefaultPageSize
	}

	return filter
}

// ConfigFilter represents the filter criteria for querying configs
type ConfigFilter struct {
	// EntityID filters configs by parent entity ID
	EntityID *int64 `json:"entity_id,omitempty"`

	// Search term to filter by key or display_name
	Search *string `json:"search,omitempty"`

	// Type filters configs by value type (string, int, float, bool, json, choice)
	Type *string `json:"type,omitempty"`

	// CreatedBy filters configs by creator user ID
	CreatedBy *int64 `json:"created_by,omitempty"`

	// UpdatedBy filters configs by last updater user ID
	UpdatedBy *int64 `json:"updated_by,omitempty"`

	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`

	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`

	// All indicates whether to fetch all configs without pagination
	All bool `json:"all,omitempty"`
}

// NewConfigFilterFromProtoRequest creates a ConfigFilter from protobuf request
func NewConfigFilterFromProtoRequest(req *openauth_v1.ListConfigsRequest) *ConfigFilter {
	filter := &ConfigFilter{
		Limit:  req.Limit,
		Offset: req.Offset,
		All:    req.All,
	}

	if req.EntityId != nil {
		filter.EntityID = req.EntityId
	}

	if req.Search != nil {
		filter.Search = req.Search
	}

	if req.Type != nil {
		filter.Type = req.Type
	}

	// Set default limit if not specified
	if filter.Limit == 0 && !filter.All {
		filter.Limit = constants.DefaultPageSize
	}

	return filter
}
