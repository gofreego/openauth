-- Core schema initialization (v2)

-- Users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    name VARCHAR(255),
    avatar_url TEXT,
    password_hash VARCHAR(255),
    email_verified BOOLEAN DEFAULT FALSE,
    phone_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    is_locked BOOLEAN DEFAULT FALSE,
    failed_login_attempts INTEGER DEFAULT 0,
    last_login_at BIGINT,
    password_changed_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE INDEX idx_users_uuid ON users(uuid);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_active ON users(is_active);
CREATE INDEX idx_users_created_at ON users(created_at);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Initial admin user
INSERT INTO users (
    uuid,
    name,
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
    'Administrator',
    'admin',
    'admin@openauth.local',
    '$2a$12$bMavjNGg74RQJdNa.n1VpeZgcTjtEcuGi7Pkg1JLP2MFg0qL0PmFi',
    true,
    false,
    true,
    false,
    0,
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- User profiles
CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    profile_name VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    display_name VARCHAR(255),
    bio TEXT,
    avatar_url VARCHAR(500),
    date_of_birth DATE,
    gender VARCHAR(20),
    timezone VARCHAR(100),
    locale VARCHAR(10),
    country VARCHAR(2),
    city VARCHAR(255),
    address TEXT,
    postal_code VARCHAR(20),
    website_url VARCHAR(500),
    metadata JSONB,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE INDEX idx_user_profiles_uuid ON user_profiles(uuid);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_user_profiles_display_name ON user_profiles(display_name);
CREATE INDEX idx_user_profiles_country ON user_profiles(country);

CREATE TRIGGER update_user_profiles_updated_at 
    BEFORE UPDATE ON user_profiles 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- OTP and verification tokens
CREATE TABLE otp_verifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    identifier VARCHAR(255),
    otp_code VARCHAR(10) NOT NULL,
    otp_type VARCHAR(50) NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    expires_at BIGINT NOT NULL,
    attempts INTEGER DEFAULT 0,
    max_attempts INTEGER DEFAULT 3,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE TABLE password_reset_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at BIGINT NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE TABLE email_verification_tokens (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at BIGINT NOT NULL,
    is_used BOOLEAN DEFAULT FALSE,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE INDEX idx_otp_verifications_user_id ON otp_verifications(user_id);
CREATE INDEX idx_otp_verifications_identifier ON otp_verifications(identifier);
CREATE INDEX idx_otp_verifications_otp_code ON otp_verifications(otp_code);
CREATE INDEX idx_otp_verifications_expires_at ON otp_verifications(expires_at);
CREATE INDEX idx_otp_verifications_type ON otp_verifications(otp_type);
CREATE INDEX idx_password_reset_tokens_user_id ON password_reset_tokens(user_id);
CREATE INDEX idx_password_reset_tokens_token ON password_reset_tokens(token);
CREATE INDEX idx_password_reset_tokens_expires_at ON password_reset_tokens(expires_at);
CREATE INDEX idx_email_verification_tokens_user_id ON email_verification_tokens(user_id);
CREATE INDEX idx_email_verification_tokens_token ON email_verification_tokens(token);
CREATE INDEX idx_email_verification_tokens_expires_at ON email_verification_tokens(expires_at);

-- Sessions
CREATE TABLE user_sessions (
    id SERIAL PRIMARY KEY,
    uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_uuid UUID NOT NULL,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    refresh_token VARCHAR(255) UNIQUE,
    device_id VARCHAR(255),
    device_name VARCHAR(255),
    device_type VARCHAR(50),
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

CREATE TABLE session_activities (
    id SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL REFERENCES user_sessions(id) ON DELETE CASCADE,
    activity_type VARCHAR(50) NOT NULL,
    ip_address INET,
    user_agent TEXT,
    location VARCHAR(255),
    metadata JSONB,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE TABLE user_sessions_archive (
    id BIGSERIAL PRIMARY KEY,
    original_id BIGINT NOT NULL,
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
CREATE INDEX idx_user_sessions_archive_user_uuid ON user_sessions_archive(user_uuid);
CREATE INDEX idx_user_sessions_archive_status ON user_sessions_archive(status);
CREATE INDEX idx_user_sessions_archive_archived_at ON user_sessions_archive(archived_at);
CREATE INDEX idx_user_sessions_archive_original_id ON user_sessions_archive(original_id);
CREATE INDEX idx_user_sessions_archive_user_id ON user_sessions_archive(user_id);

ALTER TABLE user_sessions ADD CONSTRAINT chk_session_status 
    CHECK (status IN ('active', 'expired', 'revoked', 'logged_out'));

ALTER TABLE user_sessions_archive ADD CONSTRAINT chk_archive_session_status 
    CHECK (status IN ('archived', 'deleted'));

-- Audit and security
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    entity_type VARCHAR(100) NOT NULL,
    entity_id INTEGER,
    action VARCHAR(50) NOT NULL,
    old_values JSONB,
    new_values JSONB,
    changes JSONB,
    reason TEXT,
    ip_address INET,
    user_agent TEXT,
    session_id INTEGER REFERENCES user_sessions(id),
    metadata JSONB,
    severity VARCHAR(20) DEFAULT 'medium',
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE TABLE security_events (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    event_type VARCHAR(100) NOT NULL,
    severity VARCHAR(20) DEFAULT 'medium',
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

CREATE TABLE login_attempts (
    id SERIAL PRIMARY KEY,
    identifier VARCHAR(255) NOT NULL,
    identifier_type VARCHAR(20) NOT NULL,
    ip_address INET NOT NULL,
    user_agent TEXT,
    success BOOLEAN NOT NULL,
    failure_reason VARCHAR(255),
    user_id INTEGER REFERENCES users(id),
    session_id INTEGER REFERENCES user_sessions(id),
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity_type ON audit_logs(entity_type);
CREATE INDEX idx_audit_logs_entity_id ON audit_logs(entity_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_severity ON audit_logs(severity);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX idx_audit_logs_session_id ON audit_logs(session_id);
CREATE INDEX idx_security_events_user_id ON security_events(user_id);
CREATE INDEX idx_security_events_event_type ON security_events(event_type);
CREATE INDEX idx_security_events_severity ON security_events(severity);
CREATE INDEX idx_security_events_resolved ON security_events(resolved);
CREATE INDEX idx_security_events_created_at ON security_events(created_at);
CREATE INDEX idx_security_events_ip_address ON security_events(ip_address);
CREATE INDEX idx_login_attempts_identifier ON login_attempts(identifier);
CREATE INDEX idx_login_attempts_identifier_type ON login_attempts(identifier_type);
CREATE INDEX idx_login_attempts_ip_address ON login_attempts(ip_address);
CREATE INDEX idx_login_attempts_success ON login_attempts(success);
CREATE INDEX idx_login_attempts_user_id ON login_attempts(user_id);
CREATE INDEX idx_login_attempts_created_at ON login_attempts(created_at);

-- RBAC: permissions, groups, links
CREATE TABLE permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    is_system BOOLEAN DEFAULT FALSE,
    created_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    is_system BOOLEAN DEFAULT FALSE,
    is_default BOOLEAN DEFAULT FALSE,
    created_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE TABLE group_permissions (
    id SERIAL PRIMARY KEY,
    group_id INTEGER NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    UNIQUE(group_id, permission_id)
);

CREATE TABLE user_groups (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    group_id INTEGER NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    assigned_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    expires_at BIGINT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    UNIQUE(user_id, group_id)
);

CREATE TABLE user_permissions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    expires_at BIGINT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    UNIQUE(user_id, permission_id)
);

CREATE INDEX idx_permissions_name ON permissions(name);
CREATE INDEX idx_permissions_system ON permissions(is_system);
CREATE INDEX idx_groups_name ON groups(name);
CREATE INDEX idx_groups_system ON groups(is_system);
CREATE INDEX idx_groups_default ON groups(is_default);
CREATE INDEX idx_group_permissions_group_id ON group_permissions(group_id);
CREATE INDEX idx_group_permissions_permission_id ON group_permissions(permission_id);
CREATE INDEX idx_group_permissions_granted_by ON group_permissions(granted_by);
CREATE INDEX idx_user_groups_user_id ON user_groups(user_id);
CREATE INDEX idx_user_groups_group_id ON user_groups(group_id);
CREATE INDEX idx_user_groups_assigned_by ON user_groups(assigned_by);
CREATE INDEX idx_user_groups_expires_at ON user_groups(expires_at);
CREATE INDEX idx_user_permissions_user_id ON user_permissions(user_id);
CREATE INDEX idx_user_permissions_permission_id ON user_permissions(permission_id);
CREATE INDEX idx_user_permissions_granted_by ON user_permissions(granted_by);
CREATE INDEX idx_user_permissions_expires_at ON user_permissions(expires_at);

CREATE TRIGGER update_permissions_updated_at 
    BEFORE UPDATE ON permissions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_groups_updated_at 
    BEFORE UPDATE ON groups 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- OAuth providers and external accounts
CREATE TABLE auth_providers (
    id SERIAL PRIMARY KEY,
    uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    display_name VARCHAR(255) NOT NULL,
    client_id VARCHAR(500),
    client_secret VARCHAR(500),
    auth_url VARCHAR(500),
    token_url VARCHAR(500),
    user_info_url VARCHAR(500),
    scope VARCHAR(500),
    is_enabled BOOLEAN DEFAULT TRUE,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE TABLE user_external_accounts (
    id SERIAL PRIMARY KEY,
    uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider_id INTEGER NOT NULL REFERENCES auth_providers(id) ON DELETE CASCADE,
    external_user_id VARCHAR(255) NOT NULL,
    external_username VARCHAR(255),
    external_email VARCHAR(255),
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at BIGINT,
    external_data JSONB,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    UNIQUE(provider_id, external_user_id)
);

CREATE INDEX idx_auth_providers_uuid ON auth_providers(uuid);
CREATE INDEX idx_auth_providers_name ON auth_providers(name);
CREATE INDEX idx_auth_providers_enabled ON auth_providers(is_enabled);
CREATE INDEX idx_user_external_accounts_uuid ON user_external_accounts(uuid);
CREATE INDEX idx_user_external_accounts_user_id ON user_external_accounts(user_id);
CREATE INDEX idx_user_external_accounts_provider_id ON user_external_accounts(provider_id);
CREATE INDEX idx_user_external_accounts_external_user_id ON user_external_accounts(external_user_id);

CREATE TRIGGER update_auth_providers_updated_at 
    BEFORE UPDATE ON auth_providers 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_external_accounts_updated_at 
    BEFORE UPDATE ON user_external_accounts 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


