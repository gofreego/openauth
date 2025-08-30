-- Insert default permissions
INSERT INTO permissions (name, display_name, description, resource, action, is_system) VALUES
    -- User management permissions
    ('users.create', 'Create Users', 'Create new user accounts', 'users', 'create', true),
    ('users.read', 'Read Users', 'View user accounts and profiles', 'users', 'read', true),
    ('users.update', 'Update Users', 'Modify user accounts and profiles', 'users', 'update', true),
    ('users.delete', 'Delete Users', 'Delete user accounts', 'users', 'delete', true),
    ('users.list', 'List Users', 'List all user accounts', 'users', 'list', true),
    
    -- Group management permissions
    ('groups.create', 'Create Groups', 'Create new user groups/roles', 'groups', 'create', true),
    ('groups.read', 'Read Groups', 'View user groups/roles', 'groups', 'read', true),
    ('groups.update', 'Update Groups', 'Modify user groups/roles', 'groups', 'update', true),
    ('groups.delete', 'Delete Groups', 'Delete user groups/roles', 'groups', 'delete', true),
    ('groups.assign', 'Assign Groups', 'Assign groups to users', 'groups', 'assign', true),
    ('groups.revoke', 'Revoke Groups', 'Remove groups from users', 'groups', 'revoke', true),
    
    -- Permission management permissions
    ('permissions.create', 'Create Permissions', 'Create new permissions', 'permissions', 'create', true),
    ('permissions.read', 'Read Permissions', 'View permissions', 'permissions', 'read', true),
    ('permissions.update', 'Update Permissions', 'Modify permissions', 'permissions', 'update', true),
    ('permissions.delete', 'Delete Permissions', 'Delete permissions', 'permissions', 'delete', true),
    ('permissions.assign', 'Assign Permissions', 'Assign permissions to users or groups', 'permissions', 'assign', true),
    ('permissions.revoke', 'Revoke Permissions', 'Remove permissions from users or groups', 'permissions', 'revoke', true),
    
    -- Session management permissions
    ('sessions.read', 'Read Sessions', 'View user sessions', 'sessions', 'read', true),
    ('sessions.terminate', 'Terminate Sessions', 'Terminate user sessions', 'sessions', 'terminate', true),
    
    -- Audit and security permissions
    ('audit.read', 'Read Audit Logs', 'View audit logs and security events', 'audit', 'read', true),
    ('security.manage', 'Manage Security', 'Manage security settings and events', 'security', 'manage', true),
    
    -- System administration permissions
    ('system.admin', 'System Administration', 'Full system administration access', 'system', 'admin', true),
    ('system.config', 'System Configuration', 'Manage system configuration', 'system', 'config', true);

-- Insert default groups
INSERT INTO groups (name, display_name, description, is_system, is_default) VALUES
    ('super_admin', 'Super Administrator', 'Full system access with all permissions', true, false),
    ('admin', 'Administrator', 'Administrative access to most system features', true, false),
    ('moderator', 'Moderator', 'Moderate users and content', true, false),
    ('user', 'User', 'Standard user with basic permissions', true, true),
    ('guest', 'Guest', 'Limited access for guest users', true, false);

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
