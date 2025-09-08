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