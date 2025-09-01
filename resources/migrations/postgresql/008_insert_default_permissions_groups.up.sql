-- Insert default permissions
INSERT INTO permissions (name, display_name, description, is_system, created_by) VALUES
    -- User management permissions
    ('users.create', 'Create Users', 'Create new user accounts', true, (SELECT id FROM users WHERE username = 'admin')),
    ('users.read', 'Read Users', 'View user accounts and profiles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('users.update', 'Update Users', 'Modify user accounts and profiles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('users.delete', 'Delete Users', 'Delete user accounts', true, (SELECT id FROM users WHERE username = 'admin')),
    ('users.list', 'List Users', 'List all user accounts', true, (SELECT id FROM users WHERE username = 'admin')),
    
    -- Group management permissions
    ('groups.create', 'Create Groups', 'Create new user groups/roles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.read', 'Read Groups', 'View user groups/roles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.update', 'Update Groups', 'Modify user groups/roles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.delete', 'Delete Groups', 'Delete user groups/roles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.assign', 'Assign Groups', 'Assign groups to users', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.revoke', 'Revoke Groups', 'Remove groups from users', true, (SELECT id FROM users WHERE username = 'admin')),
    
    -- Permission management permissions
    ('permissions.create', 'Create Permissions', 'Create new permissions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.read', 'Read Permissions', 'View permissions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.update', 'Update Permissions', 'Modify permissions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.delete', 'Delete Permissions', 'Delete permissions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.assign', 'Assign Permissions', 'Assign permissions to users or groups', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.revoke', 'Revoke Permissions', 'Remove permissions from users or groups', true, (SELECT id FROM users WHERE username = 'admin')),
    
    -- Session management permissions
    ('sessions.read', 'Read Sessions', 'View user sessions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('sessions.terminate', 'Terminate Sessions', 'Terminate user sessions', true, (SELECT id FROM users WHERE username = 'admin')),
    
    -- Audit and security permissions
    ('audit.read', 'Read Audit Logs', 'View audit logs and security events', true, (SELECT id FROM users WHERE username = 'admin')),
    ('security.manage', 'Manage Security', 'Manage security settings and events', true, (SELECT id FROM users WHERE username = 'admin')),
    
    -- System administration permissions
    ('system.admin', 'System Administration', 'Full system administration access', true, (SELECT id FROM users WHERE username = 'admin')),
    ('system.config', 'System Configuration', 'Manage system configuration', true, (SELECT id FROM users WHERE username = 'admin'));

-- Insert default groups
INSERT INTO groups (name, display_name, description, is_system, is_default, created_by) VALUES
    ('super_admin', 'Super Administrator', 'Full system access with all permissions', true, false, (SELECT id FROM users WHERE username = 'admin')),
    ('admin', 'Administrator', 'Administrative access to most system features', true, false, (SELECT id FROM users WHERE username = 'admin')),
    ('moderator', 'Moderator', 'Moderate users and content', true, false, (SELECT id FROM users WHERE username = 'admin')),
    ('user', 'User', 'Standard user with basic permissions', true, true, (SELECT id FROM users WHERE username = 'admin')),
    ('guest', 'Guest', 'Limited access for guest users', true, false, (SELECT id FROM users WHERE username = 'admin'));

-- Assign all permissions to super_admin group
INSERT INTO group_permissions (group_id, permission_id, granted_by)
SELECT 
    (SELECT id FROM groups WHERE name = 'super_admin'),
    p.id,
    (SELECT id FROM users WHERE username = 'admin')
FROM permissions p;

-- Assign basic permissions to admin group (all except system.admin)
INSERT INTO group_permissions (group_id, permission_id, granted_by)
SELECT 
    (SELECT id FROM groups WHERE name = 'admin'),
    p.id,
    (SELECT id FROM users WHERE username = 'admin')
FROM permissions p
WHERE p.name != 'system.admin';

-- Assign moderate permissions to moderator group
INSERT INTO group_permissions (group_id, permission_id, granted_by)
SELECT 
    (SELECT id FROM groups WHERE name = 'moderator'),
    p.id,
    (SELECT id FROM users WHERE username = 'admin')
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
    (SELECT id FROM users WHERE username = 'admin')
FROM permissions p
WHERE p.name IN ('users.read', 'sessions.read');

-- No permissions for guest group (they get minimal access)
