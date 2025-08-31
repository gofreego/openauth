package constants

const (
	// Permission validation constants
	MaxPermissionNameLength        = 100
	MaxPermissionDisplayNameLength = 200
	MaxPermissionDescriptionLength = 500
	MaxResourceNameLength          = 50
	MaxActionNameLength            = 50

	// Common permission actions
	// These represent the operations that can be performed on resources
	ActionCreate = "create" // Create new instances of a resource
	ActionRead   = "read"   // View/retrieve a resource
	ActionUpdate = "update" // Modify existing resource
	ActionDelete = "delete" // Remove a resource
	ActionList   = "list"   // Browse/list multiple resources

	// Additional common actions
	ActionPublish = "publish" // Publish content (for content management)
	ActionApprove = "approve" // Approve requests (for workflow systems)
	ActionArchive = "archive" // Archive/deactivate resources
	ActionExport  = "export"  // Export data from resources

	// Common resources
	// These represent the entities/domain objects in the system
	ResourceUsers       = "users"       // User account management
	ResourceGroups      = "groups"      // Group/role management
	ResourcePermissions = "permissions" // Permission management
	ResourceSessions    = "sessions"    // Session management

	// Additional common resources (examples for extension)
	ResourcePosts    = "posts"    // Blog posts or content management
	ResourceOrders   = "orders"   // Order management (e-commerce)
	ResourceReports  = "reports"  // Report generation and viewing
	ResourceSettings = "settings" // System configuration
)

// Example permission combinations:
//
// User Management:
// - "users.create" -> Create new user accounts
// - "users.read" -> View user profiles
// - "users.update" -> Modify user information
// - "users.delete" -> Remove user accounts
// - "users.list" -> Browse all users
//
// Group Management:
// - "groups.create" -> Create new groups/roles
// - "groups.read" -> View group details
// - "groups.update" -> Modify group settings
// - "groups.delete" -> Remove groups
// - "groups.list" -> Browse all groups
//
// Permission Management:
// - "permissions.create" -> Create new permissions
// - "permissions.read" -> View permission details
// - "permissions.update" -> Modify permissions
// - "permissions.delete" -> Remove permissions (non-system only)
// - "permissions.list" -> Browse all permissions
//
// Content Management (example):
// - "posts.create" -> Create new posts
// - "posts.publish" -> Publish posts to make them public
// - "posts.archive" -> Archive old posts
// - "posts.export" -> Export posts to external formats
