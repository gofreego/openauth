package filter

// GroupUsersFilter represents the filter criteria for listing users in a group
type GroupUsersFilter struct {
	// GroupID is the ID of the group to list users for
	GroupID int64 `json:"group_id"`
	
	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`
	
	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`
}

// UserGroupsFilter represents the filter criteria for listing groups for a user
type UserGroupsFilter struct {
	// UserID is the ID of the user to list groups for
	UserID int64 `json:"user_id"`
	
	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`
	
	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`
}

// UserSessionsFilter represents the filter criteria for listing user sessions
type UserSessionsFilter struct {
	// UserUUID is the UUID of the user to list sessions for
	UserUUID string `json:"user_uuid"`
	
	// ActiveOnly filters to only active sessions
	ActiveOnly bool `json:"active_only,omitempty"`
	
	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`
	
	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`
}

// UserProfilesFilter represents the filter criteria for listing user profiles
type UserProfilesFilter struct {
	// UserUUID is the UUID of the user to list profiles for
	UserUUID string `json:"user_uuid"`
	
	// Limit for pagination (number of records to return)
	Limit int32 `json:"limit,omitempty"`
	
	// Offset for pagination (number of records to skip)
	Offset int32 `json:"offset,omitempty"`
}

// NewGroupUsersFilter creates a new GroupUsersFilter with default pagination
func NewGroupUsersFilter(groupID int64, limit, offset int32) *GroupUsersFilter {
	if limit <= 0 || limit > 100 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}
	
	return &GroupUsersFilter{
		GroupID: groupID,
		Limit:   limit,
		Offset:  offset,
	}
}

// NewUserGroupsFilter creates a new UserGroupsFilter with default pagination
func NewUserGroupsFilter(userID int64, limit, offset int32) *UserGroupsFilter {
	if limit <= 0 || limit > 100 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}
	
	return &UserGroupsFilter{
		UserID: userID,
		Limit:  limit,
		Offset: offset,
	}
}

// NewUserSessionsFilter creates a new UserSessionsFilter with default pagination
func NewUserSessionsFilter(userUUID string, limit, offset int32, activeOnly bool) *UserSessionsFilter {
	if limit <= 0 || limit > 100 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}
	
	return &UserSessionsFilter{
		UserUUID:   userUUID,
		ActiveOnly: activeOnly,
		Limit:      limit,
		Offset:     offset,
	}
}

// NewUserProfilesFilter creates a new UserProfilesFilter with default pagination
func NewUserProfilesFilter(userUUID string, limit, offset int32) *UserProfilesFilter {
	if limit <= 0 || limit > 100 {
		limit = 10
	}
	if offset < 0 {
		offset = 0
	}
	
	return &UserProfilesFilter{
		UserUUID: userUUID,
		Limit:    limit,
		Offset:   offset,
	}
}
