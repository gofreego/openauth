-- Add user_uuid field to user_sessions table for easier lookups
ALTER TABLE user_sessions ADD COLUMN user_uuid UUID;

-- Update user_uuid values from the users table
UPDATE user_sessions 
SET user_uuid = users.uuid 
FROM users 
WHERE user_sessions.user_id = users.id;

-- Make user_uuid NOT NULL after updating values
ALTER TABLE user_sessions ALTER COLUMN user_uuid SET NOT NULL;

-- Add index for user_uuid
CREATE INDEX idx_user_sessions_user_uuid ON user_sessions(user_uuid);
