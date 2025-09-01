-- Insert default OAuth providers
INSERT INTO auth_providers (name, display_name, auth_url, token_url, user_info_url, scope, is_enabled) VALUES
    ('google', 'Google', 
     'https://accounts.google.com/o/oauth2/v2/auth',
     'https://oauth2.googleapis.com/token',
     'https://www.googleapis.com/oauth2/v2/userinfo',
     'openid email profile',
     true),
    
    ('facebook', 'Facebook',
     'https://www.facebook.com/v18.0/dialog/oauth',
     'https://graph.facebook.com/v18.0/oauth/access_token',
     'https://graph.facebook.com/v18.0/me?fields=id,name,email,picture',
     'email,public_profile',
     true),
    
    ('github', 'GitHub',
     'https://github.com/login/oauth/authorize',
     'https://github.com/login/oauth/access_token',
     'https://api.github.com/user',
     'user:email',
     true),
    
    ('microsoft', 'Microsoft',
     'https://login.microsoftonline.com/common/oauth2/v2.0/authorize',
     'https://login.microsoftonline.com/common/oauth2/v2.0/token',
     'https://graph.microsoft.com/v1.0/me',
     'openid email profile',
     true),
    
    ('apple', 'Apple',
     'https://appleid.apple.com/auth/authorize',
     'https://appleid.apple.com/auth/token',
     'https://appleid.apple.com/auth/userinfo',
     'openid email name',
     false),
    
    ('linkedin', 'LinkedIn',
     'https://www.linkedin.com/oauth/v2/authorization',
     'https://www.linkedin.com/oauth/v2/accessToken',
     'https://api.linkedin.com/v2/people/~:(id,firstName,lastName,emailAddress,profilePicture)',
     'r_liteprofile r_emailaddress',
     false);

-- Create function to automatically add user to default group
CREATE OR REPLACE FUNCTION add_user_to_default_group()
RETURNS TRIGGER AS $$
BEGIN
    -- Add user to default group if one exists
    INSERT INTO user_groups (user_id, group_id)
    SELECT NEW.id, g.id
    FROM groups g
    WHERE g.is_default = true
    AND NOT EXISTS (
        SELECT 1 FROM user_groups ug 
        WHERE ug.user_id = NEW.id AND ug.group_id = g.id
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically add new users to default group
CREATE TRIGGER trigger_add_user_to_default_group
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE FUNCTION add_user_to_default_group();

-- Create function to log critical permission and group changes
CREATE OR REPLACE FUNCTION log_permission_changes()
RETURNS TRIGGER AS $$
DECLARE
    current_user_id INTEGER;
    entity_name VARCHAR(100);
    old_data JSONB;
    new_data JSONB;
BEGIN
    -- Get current user ID from session (you may need to set this in your application)
    -- For now, we'll use a placeholder approach with error handling
    BEGIN
        current_user_id := current_setting('app.current_user_id', true)::INTEGER;
    EXCEPTION WHEN OTHERS THEN
        current_user_id := NULL;
    END;
    
    IF TG_TABLE_NAME = 'group_permissions' THEN
        entity_name := 'group_permissions';
        
        IF TG_OP = 'INSERT' THEN
            INSERT INTO audit_logs (
                user_id, entity_type, entity_id, action, 
                new_values, severity, created_at
            ) VALUES (
                current_user_id, entity_name, NEW.id, 'assign_permission',
                jsonb_build_object(
                    'group_id', NEW.group_id,
                    'permission_id', NEW.permission_id,
                    'granted_by', NEW.granted_by
                ),
                'high', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
            );
            
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO audit_logs (
                user_id, entity_type, entity_id, action,
                old_values, severity, created_at
            ) VALUES (
                current_user_id, entity_name, OLD.id, 'revoke_permission',
                jsonb_build_object(
                    'group_id', OLD.group_id,
                    'permission_id', OLD.permission_id,
                    'granted_by', OLD.granted_by
                ),
                'high', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
            );
        END IF;
        
    ELSIF TG_TABLE_NAME = 'user_groups' THEN
        entity_name := 'user_groups';
        
        IF TG_OP = 'INSERT' THEN
            INSERT INTO audit_logs (
                user_id, entity_type, entity_id, action,
                new_values, severity, created_at
            ) VALUES (
                current_user_id, entity_name, NEW.id, 'assign_group',
                jsonb_build_object(
                    'user_id', NEW.user_id,
                    'group_id', NEW.group_id,
                    'assigned_by', NEW.assigned_by,
                    'expires_at', NEW.expires_at
                ),
                'high', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
            );
            
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO audit_logs (
                user_id, entity_type, entity_id, action,
                old_values, severity, created_at
            ) VALUES (
                current_user_id, entity_name, OLD.id, 'revoke_group',
                jsonb_build_object(
                    'user_id', OLD.user_id,
                    'group_id', OLD.group_id,
                    'assigned_by', OLD.assigned_by,
                    'expires_at', OLD.expires_at
                ),
                'high', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
            );
        END IF;
        
    ELSIF TG_TABLE_NAME = 'user_permissions' THEN
        entity_name := 'user_permissions';
        
        IF TG_OP = 'INSERT' THEN
            INSERT INTO audit_logs (
                user_id, entity_type, entity_id, action,
                new_values, severity, created_at
            ) VALUES (
                current_user_id, entity_name, NEW.id, 'assign_direct_permission',
                jsonb_build_object(
                    'user_id', NEW.user_id,
                    'permission_id', NEW.permission_id,
                    'granted_by', NEW.granted_by,
                    'expires_at', NEW.expires_at
                ),
                'critical', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
            );
            
        ELSIF TG_OP = 'DELETE' THEN
            INSERT INTO audit_logs (
                user_id, entity_type, entity_id, action,
                old_values, severity, created_at
            ) VALUES (
                current_user_id, entity_name, OLD.id, 'revoke_direct_permission',
                jsonb_build_object(
                    'user_id', OLD.user_id,
                    'permission_id', OLD.permission_id,
                    'granted_by', OLD.granted_by,
                    'expires_at', OLD.expires_at
                ),
                'critical', EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
            );
        END IF;
    END IF;
    
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for logging permission changes
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
