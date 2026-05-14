-- Revert login_token fields from user_sessions
DROP INDEX IF EXISTS idx_user_sessions_login_token;

ALTER TABLE user_sessions
    DROP COLUMN IF EXISTS login_token,
    DROP COLUMN IF EXISTS login_token_expires_at;
