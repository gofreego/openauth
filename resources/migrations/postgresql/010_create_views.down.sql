-- Drop views and indexes
DROP INDEX IF EXISTS idx_user_sessions_detailed_is_active;
DROP INDEX IF EXISTS idx_user_sessions_detailed_user_id;
DROP INDEX IF EXISTS idx_user_effective_permissions_permission_name;
DROP INDEX IF EXISTS idx_user_effective_permissions_user_id;

DROP VIEW IF EXISTS audit_logs_detailed;
DROP VIEW IF EXISTS failed_login_summary;
DROP VIEW IF EXISTS recent_security_events;
DROP VIEW IF EXISTS user_sessions_detailed;
DROP VIEW IF EXISTS user_effective_permissions;
