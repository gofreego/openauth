-- Remove initial admin user
DELETE FROM user_groups WHERE user_id = (SELECT id FROM users WHERE username = 'admin');
DELETE FROM user_profiles WHERE user_id = (SELECT id FROM users WHERE username = 'admin');
DELETE FROM security_events WHERE user_id = (SELECT id FROM users WHERE username = 'admin') AND event_type = 'ADMIN_USER_CREATED';
DELETE FROM users WHERE username = 'admin';
