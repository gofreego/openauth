-- Add login_token fields to user_sessions for delegated login support
ALTER TABLE user_sessions
    ADD COLUMN login_token UUID,
    ADD COLUMN login_token_expires_at BIGINT;

CREATE UNIQUE INDEX idx_user_sessions_login_token ON user_sessions(login_token) WHERE login_token IS NOT NULL;
