package constants

const (
	// Permission validation constants
	MaxPermissionNameLength        = 100
	MaxPermissionDisplayNameLength = 200
	MaxPermissionDescriptionLength = 500

	// System Permissions (from migrations)
	// User management permissions
	PermissionUsersCreate = "users.create"
	PermissionUsersRead   = "users.read"
	PermissionUsersUpdate = "users.update"
	PermissionUsersDelete = "users.delete"
	PermissionUsersList   = "users.list"

	// User profile permissions
	PermissionProfilesCreate = "profiles.create"
	PermissionProfilesRead   = "profiles.read"
	PermissionProfilesUpdate = "profiles.update"
	PermissionProfilesDelete = "profiles.delete"
	PermissionProfilesList   = "profiles.list"

	// Group management permissions
	PermissionGroupsCreate = "groups.create"
	PermissionGroupsRead   = "groups.read"
	PermissionGroupsUpdate = "groups.update"
	PermissionGroupsDelete = "groups.delete"
	PermissionGroupsAssign = "groups.assign"
	PermissionGroupsRevoke = "groups.revoke"

	// Permission management permissions
	PermissionPermissionsCreate = "permissions.create"
	PermissionPermissionsRead   = "permissions.read"
	PermissionPermissionsUpdate = "permissions.update"
	PermissionPermissionsDelete = "permissions.delete"
	PermissionPermissionsAssign = "permissions.assign"
	PermissionPermissionsRevoke = "permissions.revoke"

	// Session management permissions
	PermissionSessionsRead      = "sessions.read"
	PermissionSessionsTerminate = "sessions.terminate"

	// Audit and security permissions
	PermissionAuditRead      = "audit.read"
	PermissionSecurityManage = "security.manage"

	// System administration permissions
	PermissionSystemAdmin  = "system.admin"
	PermissionSystemConfig = "system.config"

	// Config management permissions
	PermissionConfigEntitiesCreate = "config.entity.create"
	PermissionConfigEntitiesRead   = "config.entity.read"
)
