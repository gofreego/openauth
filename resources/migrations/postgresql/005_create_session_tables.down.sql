-- Drop session tables and related objects
DROP INDEX IF EXISTS idx_session_activities_ip_address;
DROP INDEX IF EXISTS idx_session_activities_created_at;
DROP INDEX IF EXISTS idx_session_activities_activity_type;
DROP INDEX IF EXISTS idx_session_activities_session_id;
DROP INDEX IF EXISTS idx_user_sessions_last_activity_at;
DROP INDEX IF EXISTS idx_user_sessions_expires_at;
DROP INDEX IF EXISTS idx_user_sessions_is_active;
DROP INDEX IF EXISTS idx_user_sessions_device_id;
DROP INDEX IF EXISTS idx_user_sessions_refresh_token;
DROP INDEX IF EXISTS idx_user_sessions_session_token;
DROP INDEX IF EXISTS idx_user_sessions_user_id;
DROP TABLE IF EXISTS session_activities;
DROP TABLE IF EXISTS user_sessions;
