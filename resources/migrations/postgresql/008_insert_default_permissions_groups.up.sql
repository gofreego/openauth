-- Seed default permissions, groups, admin membership, providers, and triggers (v2)

-- Permissions and groups
INSERT INTO permissions (name, display_name, description, is_system, created_by) VALUES
    ('users.create', 'Create Users', 'Create new user accounts', true, (SELECT id FROM users WHERE username = 'admin')),
    ('users.read', 'Read Users', 'View user accounts and profiles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('users.update', 'Update Users', 'Modify user accounts and profiles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('users.delete', 'Delete Users', 'Delete user accounts', true, (SELECT id FROM users WHERE username = 'admin')),
    ('users.list', 'List Users', 'List all user accounts', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.create', 'Create Groups', 'Create new user groups/roles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.read', 'Read Groups', 'View user groups/roles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.update', 'Update Groups', 'Modify user groups/roles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.delete', 'Delete Groups', 'Delete user groups/roles', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.assign', 'Assign Groups', 'Assign groups to users', true, (SELECT id FROM users WHERE username = 'admin')),
    ('groups.revoke', 'Revoke Groups', 'Remove groups from users', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.create', 'Create Permissions', 'Create new permissions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.read', 'Read Permissions', 'View permissions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.update', 'Update Permissions', 'Modify permissions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.delete', 'Delete Permissions', 'Delete permissions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.assign', 'Assign Permissions', 'Assign permissions to users or groups', true, (SELECT id FROM users WHERE username = 'admin')),
    ('permissions.revoke', 'Revoke Permissions', 'Remove permissions from users or groups', true, (SELECT id FROM users WHERE username = 'admin')),
    ('sessions.read', 'Read Sessions', 'View user sessions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('sessions.terminate', 'Terminate Sessions', 'Terminate user sessions', true, (SELECT id FROM users WHERE username = 'admin')),
    ('audit.read', 'Read Audit Logs', 'View audit logs and security events', true, (SELECT id FROM users WHERE username = 'admin')),
    ('security.manage', 'Manage Security', 'Manage security settings and events', true, (SELECT id FROM users WHERE username = 'admin')),
    ('system.admin', 'System Administration', 'Full system administration access', true, (SELECT id FROM users WHERE username = 'admin')),
    ('system.config', 'System Configuration', 'Manage system configuration', true, (SELECT id FROM users WHERE username = 'admin'));

INSERT INTO groups (name, display_name, description, is_system, is_default, created_by) VALUES
    ('super_admin', 'Super Administrator', 'Full system access with all permissions', true, false, (SELECT id FROM users WHERE username = 'admin'));

INSERT INTO group_permissions (group_id, permission_id, granted_by)
SELECT (SELECT id FROM groups WHERE name = 'super_admin'), p.id, (SELECT id FROM users WHERE username = 'admin')
FROM permissions p;

-- Add admin to super_admin
INSERT INTO user_groups (user_id, group_id, assigned_by, created_at)
VALUES (
    (SELECT id FROM users WHERE username = 'admin'),
    (SELECT id FROM groups WHERE name = 'super_admin'),
    (SELECT id FROM users WHERE username = 'admin'),
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Default OAuth providers
INSERT INTO auth_providers (name, display_name, auth_url, token_url, user_info_url, scope, is_enabled) VALUES
    ('google', 'Google','https://accounts.google.com/o/oauth2/v2/auth','https://oauth2.googleapis.com/token','https://www.googleapis.com/oauth2/v2/userinfo','openid email profile',true),
    ('facebook', 'Facebook','https://www.facebook.com/v18.0/dialog/oauth','https://graph.facebook.com/v18.0/oauth/access_token','https://graph.facebook.com/v18.0/me?fields=id,name,email,picture','email,public_profile',true),
    ('github', 'GitHub','https://github.com/login/oauth/authorize','https://github.com/login/oauth/access_token','https://api.github.com/user','user:email',true),
    ('microsoft', 'Microsoft','https://login.microsoftonline.com/common/oauth2/v2.0/authorize','https://login.microsoftonline.com/common/oauth2/v2.0/token','https://graph.microsoft.com/v1.0/me','openid email profile',true),
    ('apple', 'Apple','https://appleid.apple.com/auth/authorize','https://appleid.apple.com/auth/token','https://appleid.apple.com/auth/userinfo','openid email name',false),
    ('linkedin', 'LinkedIn','https://www.linkedin.com/oauth/v2/authorization','https://www.linkedin.com/oauth/v2/accessToken','https://api.linkedin.com/v2/people/~:(id,firstName,lastName,emailAddress,profilePicture)','r_liteprofile r_emailaddress',false);

-- Default group assignment trigger
CREATE OR REPLACE FUNCTION add_user_to_default_group()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_groups (user_id, group_id, assigned_by)
    SELECT NEW.id, g.id, NEW.id
    FROM groups g
    WHERE g.is_default = true
    AND NOT EXISTS (
        SELECT 1 FROM user_groups ug 
        WHERE ug.user_id = NEW.id AND ug.group_id = g.id
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_add_user_to_default_group
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE FUNCTION add_user_to_default_group();

-- Audit logging triggers for RBAC changes
CREATE OR REPLACE FUNCTION log_permission_changes()
RETURNS TRIGGER AS $$
DECLARE
    current_user_id INTEGER;
    entity_name VARCHAR(100);
BEGIN
    BEGIN
        current_user_id := current_setting('app.current_user_id', true)::INTEGER;
    EXCEPTION WHEN OTHERS THEN
        current_user_id := NULL;
    END;

    IF TG_TABLE_NAME = 'group_permissions' THEN
        entity_name := 'group_permissions';
        IF TG_OP = 'INSERT' THEN
            INSERT INTO audit_logs (user_id, entity_type, entity_id, action, new_values, severity, created_at)
            VALUES (current_user_id, entity_name, NEW.id, 'assign_permission',
                jsonb_build_object('group_id', NEW.group_id,'permission_id', NEW.permission_id,'granted_by', NEW.granted_by),
                'high', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000 );
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO audit_logs (user_id, entity_type, entity_id, action, old_values, severity, created_at)
            VALUES (current_user_id, entity_name, OLD.id, 'revoke_permission',
                jsonb_build_object('group_id', OLD.group_id,'permission_id', OLD.permission_id,'granted_by', OLD.granted_by),
                'high', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000 );
        END IF;
    ELSIF TG_TABLE_NAME = 'user_groups' THEN
        entity_name := 'user_groups';
        IF TG_OP = 'INSERT' THEN
            INSERT INTO audit_logs (user_id, entity_type, entity_id, action, new_values, severity, created_at)
            VALUES (current_user_id, entity_name, NEW.id, 'assign_group',
                jsonb_build_object('user_id', NEW.user_id,'group_id', NEW.group_id,'assigned_by', NEW.assigned_by,'expires_at', NEW.expires_at),
                'high', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000 );
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO audit_logs (user_id, entity_type, entity_id, action, old_values, severity, created_at)
            VALUES (current_user_id, entity_name, OLD.id, 'revoke_group',
                jsonb_build_object('user_id', OLD.user_id,'group_id', OLD.group_id,'assigned_by', OLD.assigned_by,'expires_at', OLD.expires_at),
                'high', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000 );
        END IF;
    ELSIF TG_TABLE_NAME = 'user_permissions' THEN
        entity_name := 'user_permissions';
        IF TG_OP = 'INSERT' THEN
            INSERT INTO audit_logs (user_id, entity_type, entity_id, action, new_values, severity, created_at)
            VALUES (current_user_id, entity_name, NEW.id, 'assign_direct_permission',
                jsonb_build_object('user_id', NEW.user_id,'permission_id', NEW.permission_id,'granted_by', NEW.granted_by,'expires_at', NEW.expires_at),
                'critical', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000 );
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO audit_logs (user_id, entity_type, entity_id, action, old_values, severity, created_at)
            VALUES (current_user_id, entity_name, OLD.id, 'revoke_direct_permission',
                jsonb_build_object('user_id', OLD.user_id,'permission_id', OLD.permission_id,'granted_by', OLD.granted_by,'expires_at', OLD.expires_at),
                'critical', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000 );
        END IF;
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_group_permission_changes
    AFTER INSERT OR DELETE ON group_permissions
    FOR EACH ROW
    EXECUTE FUNCTION log_permission_changes();

CREATE TRIGGER trigger_log_user_group_changes
    AFTER INSERT OR DELETE ON user_groups
    FOR EACH ROW
    EXECUTE FUNCTION log_permission_changes();

CREATE TRIGGER trigger_log_user_permission_changes
    AFTER INSERT OR DELETE ON user_permissions
    FOR EACH ROW
    EXECUTE FUNCTION log_permission_changes();


