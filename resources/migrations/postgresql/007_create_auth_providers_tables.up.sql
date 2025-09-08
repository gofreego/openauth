
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


