-- Default credentials: username=admin, password=admin123 (CHANGE IN PRODUCTION!)

-- Assign admin user to super_admin group
INSERT INTO user_groups (user_id, group_id, assigned_by, created_at)
VALUES (
    (SELECT id FROM users WHERE username = 'admin'),
    (SELECT id FROM groups WHERE name = 'super_admin'),
    (SELECT id FROM users WHERE username = 'admin'), -- Self-assigned
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Log the creation for security audit
INSERT INTO security_events (
    event_type,
    user_id,
    description,
    ip_address,
    user_agent,
    created_at
) VALUES (
    'ADMIN_USER_CREATED',
    (SELECT id FROM users WHERE username = 'admin'),
    '{"action": "initial_admin_user_created", "username": "admin", "source": "migration"}',
    '127.0.0.1',
    'Database Migration',
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);
