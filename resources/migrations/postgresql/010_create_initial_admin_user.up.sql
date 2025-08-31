-- Create initial root/admin user for system bootstrap
-- Default credentials: username=admin, password=admin123 (CHANGE IN PRODUCTION!)

INSERT INTO users (
    uuid, 
    username, 
    email, 
    password_hash, 
    email_verified, 
    phone_verified, 
    is_active, 
    is_locked, 
    failed_login_attempts, 
    password_changed_at, 
    created_at, 
    updated_at
) VALUES (
    gen_random_uuid(),
    'admin',
    'admin@openauth.local',
    '$2a$12$bMavjNGg74RQJdNa.n1VpeZgcTjtEcuGi7Pkg1JLP2MFg0qL0PmFi', -- bcrypt hash of 'admin123'
    true,
    false,
    true,
    false,
    0,
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Create profile for admin user
INSERT INTO user_profiles (
    uuid,
    user_id,
    profile_name,
    first_name,
    last_name,
    display_name,
    created_at,
    updated_at
) VALUES (
    gen_random_uuid(),
    (SELECT id FROM users WHERE username = 'admin'),
    'default',
    'System',
    'Administrator',
    'Admin',
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

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
