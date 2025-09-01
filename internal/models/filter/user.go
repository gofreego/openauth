package filter

import "github.com/gofreego/openauth/api/openauth_v1"

// UserFilter represents the filter criteria for querying users
type UserFilter struct {
	// Search term to filter by username, email, phone, or name
	Search *string `json:"search,omitempty"`

	// Email filters users by email
	Email *string `json:"email,omitempty"`

	// Username filters users by username
	Username *string `json:"username,omitempty"`

	// Phone filters users by phone number
	Phone *string `json:"phone,omitempty"`

	// IsActive filters users by active status
	IsActive *bool `json:"is_active,omitempty"`

	// IsLocked filters users by locked status
	IsLocked *bool `json:"is_locked,omitempty"`

	// EmailVerified filters users by email verification status
	EmailVerified *bool `json:"email_verified,omitempty"`

	// PhoneVerified filters users by phone verification status
	PhoneVerified *bool `json:"phone_verified,omitempty"`

	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`

	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`
}

// FromListUsersRequest creates a UserFilter from a ListUsersRequest
func FromListUsersRequest(req *openauth_v1.ListUsersRequest) *UserFilter {
	filter := &UserFilter{}

	// Set pagination with defaults
	filter.Limit = req.Limit
	if filter.Limit <= 0 || filter.Limit > 100 {
		filter.Limit = 10
	}

	filter.Offset = req.Offset
	if filter.Offset < 0 {
		filter.Offset = 0
	}

	// Set search filter if provided
	if req.Search != nil && *req.Search != "" {
		filter.Search = req.Search
	}

	// Set other filters if they exist in the request
	// Note: Check the actual ListUsersRequest structure for available fields

	return filter
}

// HasSearch returns true if search filter is set and not empty
func (f *UserFilter) HasSearch() bool {
	return f.Search != nil && *f.Search != ""
}

// HasEmail returns true if email filter is set and not empty
func (f *UserFilter) HasEmail() bool {
	return f.Email != nil && *f.Email != ""
}

// HasUsername returns true if username filter is set and not empty
func (f *UserFilter) HasUsername() bool {
	return f.Username != nil && *f.Username != ""
}

// HasPhone returns true if phone filter is set and not empty
func (f *UserFilter) HasPhone() bool {
	return f.Phone != nil && *f.Phone != ""
}

// HasIsActive returns true if is_active filter is set
func (f *UserFilter) HasIsActive() bool {
	return f.IsActive != nil
}

// HasIsLocked returns true if is_locked filter is set
func (f *UserFilter) HasIsLocked() bool {
	return f.IsLocked != nil
}

// HasEmailVerified returns true if email_verified filter is set
func (f *UserFilter) HasEmailVerified() bool {
	return f.EmailVerified != nil
}

// HasPhoneVerified returns true if phone_verified filter is set
func (f *UserFilter) HasPhoneVerified() bool {
	return f.PhoneVerified != nil
}
