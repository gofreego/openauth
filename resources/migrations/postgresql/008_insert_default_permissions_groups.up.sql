-- Insert default permissions
INSERT INTO permissions (id, name, display_name, description, resource, action, is_system) VALUES
    -- User management permissions
    (gen_random_uuid(), 'users.create', 'Create Users', 'Create new user accounts', 'users', 'create', true),
    (gen_random_uuid(), 'users.read', 'Read Users', 'View user accounts and profiles', 'users', 'read', true),
    (gen_random_uuid(), 'users.update', 'Update Users', 'Modify user accounts and profiles', 'users', 'update', true),
    (gen_random_uuid(), 'users.delete', 'Delete Users', 'Delete user accounts', 'users', 'delete', true),
    (gen_random_uuid(), 'users.list', 'List Users', 'List all user accounts', 'users', 'list', true),
    
    -- Group management permissions
    (gen_random_uuid(), 'groups.create', 'Create Groups', 'Create new user groups/roles', 'groups', 'create', true),
    (gen_random_uuid(), 'groups.read', 'Read Groups', 'View user groups/roles', 'groups', 'read', true),
    (gen_random_uuid(), 'groups.update', 'Update Groups', 'Modify user groups/roles', 'groups', 'update', true),
    (gen_random_uuid(), 'groups.delete', 'Delete Groups', 'Delete user groups/roles', 'groups', 'delete', true),
    (gen_random_uuid(), 'groups.assign', 'Assign Groups', 'Assign groups to users', 'groups', 'assign', true),
    (gen_random_uuid(), 'groups.revoke', 'Revoke Groups', 'Remove groups from users', 'groups', 'revoke', true),
    
    -- Permission management permissions
    (gen_random_uuid(), 'permissions.create', 'Create Permissions', 'Create new permissions', 'permissions', 'create', true),
    (gen_random_uuid(), 'permissions.read', 'Read Permissions', 'View permissions', 'permissions', 'read', true),
    (gen_random_uuid(), 'permissions.update', 'Update Permissions', 'Modify permissions', 'permissions', 'update', true),
    (gen_random_uuid(), 'permissions.delete', 'Delete Permissions', 'Delete permissions', 'permissions', 'delete', true),
    (gen_random_uuid(), 'permissions.assign', 'Assign Permissions', 'Assign permissions to users or groups', 'permissions', 'assign', true),
    (gen_random_uuid(), 'permissions.revoke', 'Revoke Permissions', 'Remove permissions from users or groups', 'permissions', 'revoke', true),
    
    -- Session management permissions
    (gen_random_uuid(), 'sessions.read', 'Read Sessions', 'View user sessions', 'sessions', 'read', true),
    (gen_random_uuid(), 'sessions.terminate', 'Terminate Sessions', 'Terminate user sessions', 'sessions', 'terminate', true),
    
    -- Audit and security permissions
    (gen_random_uuid(), 'audit.read', 'Read Audit Logs', 'View audit logs and security events', 'audit', 'read', true),
    (gen_random_uuid(), 'security.manage', 'Manage Security', 'Manage security settings and events', 'security', 'manage', true),
    
    -- System administration permissions
    (gen_random_uuid(), 'system.admin', 'System Administration', 'Full system administration access', 'system', 'admin', true),
    (gen_random_uuid(), 'system.config', 'System Configuration', 'Manage system configuration', 'system', 'config', true);

-- Insert default groups
INSERT INTO groups (id, name, display_name, description, is_system, is_default) VALUES
    (gen_random_uuid(), 'super_admin', 'Super Administrator', 'Full system access with all permissions', true, false),
    (gen_random_uuid(), 'admin', 'Administrator', 'Administrative access to most system features', true, false),
    (gen_random_uuid(), 'moderator', 'Moderator', 'Moderate users and content', true, false),
    (gen_random_uuid(), 'user', 'User', 'Standard user with basic permissions', true, true),
    (gen_random_uuid(), 'guest', 'Guest', 'Limited access for guest users', true, false);

-- Assign all permissions to super_admin group
INSERT INTO group_permissions (group_id, permission_id, granted_by)
SELECT 
    (SELECT id FROM groups WHERE name = 'super_admin'),
    p.id,
    NULL
FROM permissions p;

-- Assign basic permissions to admin group (all except system.admin)
INSERT INTO group_permissions (group_id, permission_id, granted_by)
SELECT 
    (SELECT id FROM groups WHERE name = 'admin'),
    p.id,
    NULL
FROM permissions p
WHERE p.name != 'system.admin';

-- Assign moderate permissions to moderator group
INSERT INTO group_permissions (group_id, permission_id, granted_by)
SELECT 
    (SELECT id FROM groups WHERE name = 'moderator'),
    p.id,
    NULL
FROM permissions p
WHERE p.name IN (
    'users.read', 'users.list', 'users.update',
    'groups.read', 'sessions.read', 'sessions.terminate',
    'audit.read'
);

-- Assign basic permissions to user group
INSERT INTO group_permissions (group_id, permission_id, granted_by)
SELECT 
    (SELECT id FROM groups WHERE name = 'user'),
    p.id,
    NULL
FROM permissions p
WHERE p.name IN ('users.read', 'sessions.read');

-- No permissions for guest group (they get minimal access)
