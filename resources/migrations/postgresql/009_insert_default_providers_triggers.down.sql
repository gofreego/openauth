-- Drop triggers and functions
DROP TRIGGER IF EXISTS trigger_log_user_permission_changes ON user_permissions;
DROP TRIGGER IF EXISTS trigger_log_user_group_changes ON user_groups;
DROP TRIGGER IF EXISTS trigger_log_group_permission_changes ON group_permissions;
DROP TRIGGER IF EXISTS trigger_add_user_to_default_group ON users;

DROP FUNCTION IF EXISTS log_permission_changes();
DROP FUNCTION IF EXISTS add_user_to_default_group();

-- Remove default OAuth providers
DELETE FROM auth_providers WHERE name IN ('google', 'facebook', 'github', 'microsoft', 'apple', 'linkedin');
