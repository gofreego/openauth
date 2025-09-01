-- Create user sessions table for session management
CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_uuid UUID NOT NULL,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    refresh_token VARCHAR(255) UNIQUE,
    device_id VARCHAR(255),
    device_name VARCHAR(255),
    device_type VARCHAR(50), -- web, mobile, desktop
    user_agent TEXT,
    ip_address INET,
    location VARCHAR(255),
    lat DECIMAL(9,6),
    lon DECIMAL(9,6),
    is_active BOOLEAN DEFAULT TRUE,
    status VARCHAR(20) DEFAULT 'active',
    expires_at BIGINT NOT NULL,
    refresh_expires_at BIGINT,
    last_activity_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    revoked_at BIGINT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Create session activities table for tracking session events
CREATE TABLE session_activities (
    id SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL REFERENCES user_sessions(id) ON DELETE CASCADE,
    activity_type VARCHAR(50) NOT NULL, -- login, logout, refresh, access
    ip_address INET,
    user_agent TEXT,
    location VARCHAR(255),
    metadata JSONB,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Create archive table for historical session data
CREATE TABLE user_sessions_archive (
    id BIGSERIAL PRIMARY KEY,
    original_id BIGINT NOT NULL, -- Reference to original session ID
    uuid UUID NOT NULL,
    user_id INTEGER NOT NULL,
    user_uuid UUID NOT NULL,
    session_token VARCHAR(255),
    refresh_token VARCHAR(255),
    device_id VARCHAR(255),
    device_name VARCHAR(255),
    device_type VARCHAR(50),
    user_agent TEXT,
    ip_address INET,
    location VARCHAR(255),
    lat DECIMAL(9,6),
    lon DECIMAL(9,6),
    is_active BOOLEAN DEFAULT false,
    status VARCHAR(20) DEFAULT 'archived',
    expires_at BIGINT NOT NULL,
    refresh_expires_at BIGINT,
    last_activity_at BIGINT NOT NULL,
    revoked_at BIGINT,
    created_at BIGINT NOT NULL,
    archived_at BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Create indexes
CREATE INDEX idx_user_sessions_uuid ON user_sessions(uuid);
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_user_uuid ON user_sessions(user_uuid);
CREATE INDEX idx_user_sessions_session_token ON user_sessions(session_token);
CREATE INDEX idx_user_sessions_refresh_token ON user_sessions(refresh_token);
CREATE INDEX idx_user_sessions_device_id ON user_sessions(device_id);
CREATE INDEX idx_user_sessions_is_active ON user_sessions(is_active);
CREATE INDEX idx_user_sessions_status ON user_sessions(status);
CREATE INDEX idx_user_sessions_status_last_activity ON user_sessions(status, last_activity_at);
CREATE INDEX idx_user_sessions_expires_at ON user_sessions(expires_at);
CREATE INDEX idx_user_sessions_last_activity_at ON user_sessions(last_activity_at);
CREATE INDEX idx_user_sessions_revoked_at ON user_sessions(revoked_at);

CREATE INDEX idx_session_activities_session_id ON session_activities(session_id);
CREATE INDEX idx_session_activities_activity_type ON session_activities(activity_type);
CREATE INDEX idx_session_activities_created_at ON session_activities(created_at);
CREATE INDEX idx_session_activities_ip_address ON session_activities(ip_address);

-- Create indexes for archive table
CREATE INDEX idx_user_sessions_archive_user_uuid ON user_sessions_archive(user_uuid);
CREATE INDEX idx_user_sessions_archive_status ON user_sessions_archive(status);
CREATE INDEX idx_user_sessions_archive_archived_at ON user_sessions_archive(archived_at);
CREATE INDEX idx_user_sessions_archive_original_id ON user_sessions_archive(original_id);
CREATE INDEX idx_user_sessions_archive_user_id ON user_sessions_archive(user_id);

-- Add constraints to ensure valid status values
ALTER TABLE user_sessions ADD CONSTRAINT chk_session_status 
    CHECK (status IN ('active', 'expired', 'revoked', 'logged_out'));

ALTER TABLE user_sessions_archive ADD CONSTRAINT chk_archive_session_status 
    CHECK (status IN ('archived', 'deleted'));
