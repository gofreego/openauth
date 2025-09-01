-- Create audit logs table for tracking critical operations
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id), -- Who performed the action
    entity_type VARCHAR(100) NOT NULL, -- users, groups, permissions, user_groups, etc.
    entity_id INTEGER, -- ID of the entity being modified (integer primary key)
    action VARCHAR(50) NOT NULL, -- create, update, delete, assign, revoke
    old_values JSONB, -- Previous state of the entity
    new_values JSONB, -- New state of the entity
    changes JSONB, -- Specific fields that changed
    reason TEXT, -- Optional reason for the change
    ip_address INET,
    user_agent TEXT,
    session_id INTEGER REFERENCES user_sessions(id),
    metadata JSONB, -- Additional context data
    severity VARCHAR(20) DEFAULT 'medium', -- low, medium, high, critical
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Create security events table for tracking security-related events
CREATE TABLE security_events (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    event_type VARCHAR(100) NOT NULL, -- login_success, login_failure, password_change, etc.
    severity VARCHAR(20) DEFAULT 'medium', -- low, medium, high, critical
    description TEXT,
    ip_address INET,
    user_agent TEXT,
    location VARCHAR(255),
    device_id VARCHAR(255),
    session_id INTEGER REFERENCES user_sessions(id),
    metadata JSONB,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_by INTEGER REFERENCES users(id),
    resolved_at BIGINT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Create login attempts table for tracking failed login attempts
CREATE TABLE login_attempts (
    id SERIAL PRIMARY KEY,
    identifier VARCHAR(255) NOT NULL, -- username, email, or phone
    identifier_type VARCHAR(20) NOT NULL, -- username, email, phone
    ip_address INET NOT NULL,
    user_agent TEXT,
    success BOOLEAN NOT NULL,
    failure_reason VARCHAR(255), -- invalid_credentials, account_locked, etc.
    user_id INTEGER REFERENCES users(id), -- Only set if login was successful
    session_id INTEGER REFERENCES user_sessions(id), -- Only set if login was successful
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Create indexes for audit_logs
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity_type ON audit_logs(entity_type);
CREATE INDEX idx_audit_logs_entity_id ON audit_logs(entity_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_severity ON audit_logs(severity);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX idx_audit_logs_session_id ON audit_logs(session_id);

-- Create indexes for security_events
CREATE INDEX idx_security_events_user_id ON security_events(user_id);
CREATE INDEX idx_security_events_event_type ON security_events(event_type);
CREATE INDEX idx_security_events_severity ON security_events(severity);
CREATE INDEX idx_security_events_resolved ON security_events(resolved);
CREATE INDEX idx_security_events_created_at ON security_events(created_at);
CREATE INDEX idx_security_events_ip_address ON security_events(ip_address);

-- Create indexes for login_attempts
CREATE INDEX idx_login_attempts_identifier ON login_attempts(identifier);
CREATE INDEX idx_login_attempts_identifier_type ON login_attempts(identifier_type);
CREATE INDEX idx_login_attempts_ip_address ON login_attempts(ip_address);
CREATE INDEX idx_login_attempts_success ON login_attempts(success);
CREATE INDEX idx_login_attempts_user_id ON login_attempts(user_id);
CREATE INDEX idx_login_attempts_created_at ON login_attempts(created_at);
