-- Create useful views for the authentication system

-- View to get all effective permissions for a user (from groups and direct permissions)
CREATE VIEW user_effective_permissions AS
SELECT DISTINCT
    u.id as user_id,
    u.username,
    p.id as permission_id,
    p.name as permission_name,
    p.display_name as permission_display_name,
    p.resource,
    p.action,
    CASE 
        WHEN up.id IS NOT NULL THEN 'direct'
        ELSE 'group'
    END as permission_source,
    CASE 
        WHEN up.id IS NOT NULL THEN NULL
        ELSE g.name
    END as source_group_name,
    CASE 
        WHEN up.expires_at IS NOT NULL AND up.expires_at < CURRENT_TIMESTAMP THEN TRUE
        WHEN ug.expires_at IS NOT NULL AND ug.expires_at < CURRENT_TIMESTAMP THEN TRUE
        ELSE FALSE
    END as is_expired
FROM users u
LEFT JOIN user_groups ug ON u.id = ug.user_id
LEFT JOIN groups g ON ug.group_id = g.id
LEFT JOIN group_permissions gp ON g.id = gp.group_id
LEFT JOIN permissions p ON gp.permission_id = p.id
LEFT JOIN user_permissions up ON u.id = up.user_id AND p.id = up.permission_id
WHERE 
    u.is_active = TRUE 
    AND (
        (ug.expires_at IS NULL OR ug.expires_at > CURRENT_TIMESTAMP)
        OR (up.expires_at IS NULL OR up.expires_at > CURRENT_TIMESTAMP)
    )
    AND p.id IS NOT NULL;

-- View to get user sessions with additional information
CREATE VIEW user_sessions_detailed AS
SELECT 
    s.id as session_id,
    s.user_id,
    u.username,
    u.email,
    s.session_token,
    s.device_name,
    s.device_type,
    s.ip_address,
    s.location,
    s.is_active,
    s.expires_at,
    s.last_activity_at,
    s.created_at as session_created_at,
    CASE 
        WHEN s.expires_at < CURRENT_TIMESTAMP THEN TRUE
        ELSE FALSE
    END as is_expired,
    EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - s.last_activity_at))/60 as minutes_since_last_activity
FROM user_sessions s
JOIN users u ON s.user_id = u.id;

-- View for recent security events
CREATE VIEW recent_security_events AS
SELECT 
    se.id,
    se.user_id,
    u.username,
    u.email,
    se.event_type,
    se.severity,
    se.description,
    se.ip_address,
    se.location,
    se.resolved,
    se.resolved_by,
    resolver.username as resolved_by_username,
    se.created_at,
    EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - se.created_at))/3600 as hours_ago
FROM security_events se
LEFT JOIN users u ON se.user_id = u.id
LEFT JOIN users resolver ON se.resolved_by = resolver.id
WHERE se.created_at > CURRENT_TIMESTAMP - INTERVAL '30 days'
ORDER BY se.created_at DESC;

-- View for failed login attempts summary
CREATE VIEW failed_login_summary AS
SELECT 
    la.ip_address,
    la.identifier,
    la.identifier_type,
    COUNT(*) as failed_attempts,
    MAX(la.created_at) as last_attempt,
    COUNT(DISTINCT la.identifier) as unique_identifiers,
    array_agg(DISTINCT la.failure_reason) as failure_reasons
FROM login_attempts la
WHERE 
    la.success = FALSE 
    AND la.created_at > CURRENT_TIMESTAMP - INTERVAL '24 hours'
GROUP BY la.ip_address, la.identifier, la.identifier_type
HAVING COUNT(*) >= 3
ORDER BY failed_attempts DESC, last_attempt DESC;

-- View for audit log summary with human-readable information
CREATE VIEW audit_logs_detailed AS
SELECT 
    al.id,
    al.user_id,
    u.username as performed_by,
    al.entity_type,
    al.entity_id,
    al.action,
    al.old_values,
    al.new_values,
    al.changes,
    al.reason,
    al.severity,
    al.ip_address,
    al.created_at,
    CASE al.entity_type
        WHEN 'users' THEN (SELECT username FROM users WHERE id = al.entity_id::UUID)
        WHEN 'groups' THEN (SELECT name FROM groups WHERE id = al.entity_id::UUID)
        WHEN 'permissions' THEN (SELECT name FROM permissions WHERE id = al.entity_id::UUID)
        ELSE 'Unknown'
    END as entity_name
FROM audit_logs al
LEFT JOIN users u ON al.user_id = u.id
ORDER BY al.created_at DESC;

-- Create indexes on views for better performance
CREATE INDEX idx_user_effective_permissions_user_id ON user_effective_permissions(user_id);
CREATE INDEX idx_user_effective_permissions_permission_name ON user_effective_permissions(permission_name);
CREATE INDEX idx_user_sessions_detailed_user_id ON user_sessions_detailed(user_id);
CREATE INDEX idx_user_sessions_detailed_is_active ON user_sessions_detailed(is_active);
