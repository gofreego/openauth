-- Remove user_uuid column from user_sessions table
DROP INDEX IF EXISTS idx_user_sessions_user_uuid;
ALTER TABLE user_sessions DROP COLUMN user_uuid;
