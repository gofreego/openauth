-- Drop groups and permissions tables and related objects
DROP TRIGGER IF EXISTS update_groups_updated_at ON groups;
DROP TRIGGER IF EXISTS update_permissions_updated_at ON permissions;

DROP INDEX IF EXISTS idx_user_permissions_expires_at;
DROP INDEX IF EXISTS idx_user_permissions_granted_by;
DROP INDEX IF EXISTS idx_user_permissions_permission_id;
DROP INDEX IF EXISTS idx_user_permissions_user_id;
DROP INDEX IF EXISTS idx_user_groups_expires_at;
DROP INDEX IF EXISTS idx_user_groups_assigned_by;
DROP INDEX IF EXISTS idx_user_groups_group_id;
DROP INDEX IF EXISTS idx_user_groups_user_id;
DROP INDEX IF EXISTS idx_group_permissions_granted_by;
DROP INDEX IF EXISTS idx_group_permissions_permission_id;
DROP INDEX IF EXISTS idx_group_permissions_group_id;
DROP INDEX IF EXISTS idx_groups_default;
DROP INDEX IF EXISTS idx_groups_system;
DROP INDEX IF EXISTS idx_groups_name;
DROP INDEX IF EXISTS idx_permissions_system;
DROP INDEX IF EXISTS idx_permissions_action;
DROP INDEX IF EXISTS idx_permissions_resource;
DROP INDEX IF EXISTS idx_permissions_name;

DROP TABLE IF EXISTS user_permissions;
DROP TABLE IF EXISTS user_groups;
DROP TABLE IF EXISTS group_permissions;
DROP TABLE IF EXISTS groups;
DROP TABLE IF EXISTS permissions;
