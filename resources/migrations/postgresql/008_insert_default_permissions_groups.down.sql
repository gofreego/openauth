-- Remove seeded data and triggers

DROP TRIGGER IF EXISTS trigger_log_user_permission_changes ON user_permissions;
DROP TRIGGER IF EXISTS trigger_log_user_group_changes ON user_groups;
DROP TRIGGER IF EXISTS trigger_log_group_permission_changes ON group_permissions;
DROP FUNCTION IF EXISTS log_permission_changes();

DROP TRIGGER IF EXISTS trigger_add_user_to_default_group ON users;
DROP FUNCTION IF EXISTS add_user_to_default_group();

-- Remove admin from super_admin
DELETE FROM user_groups WHERE user_id = (SELECT id FROM users WHERE username = 'admin') AND group_id = (SELECT id FROM groups WHERE name = 'super_admin');

-- Remove group permissions
DELETE FROM group_permissions;

-- Remove groups
DELETE FROM groups WHERE name IN ('super_admin','admin','moderator','user','guest');

-- Remove permissions
DELETE FROM permissions WHERE name IN (
    'users.create','users.read','users.update','users.delete','users.list',
    'groups.create','groups.read','groups.update','groups.delete','groups.assign','groups.revoke',
    'permissions.create','permissions.read','permissions.update','permissions.delete','permissions.assign','permissions.revoke',
    'sessions.read','sessions.terminate','audit.read','security.manage','system.admin','system.config'
);

-- Remove providers
DELETE FROM auth_providers WHERE name IN ('google','facebook','github','microsoft','apple','linkedin');


