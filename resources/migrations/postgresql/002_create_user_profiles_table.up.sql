-- User profiles
CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    profile_name VARCHAR(100),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    display_name VARCHAR(100),
    bio TEXT,
    avatar_url VARCHAR(500),
    date_of_birth DATE,
    gender VARCHAR(50),
    timezone VARCHAR(100),
    locale VARCHAR(20),
    country VARCHAR(2),
    city VARCHAR(255),
    address TEXT,
    postal_code VARCHAR(25),
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
