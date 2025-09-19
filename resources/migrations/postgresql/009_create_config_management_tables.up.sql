-- Config Management Service Schema

-- Config Entity table
CREATE TABLE config_entities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    display_name VARCHAR(255),
    description TEXT,
    read_perm INTEGER NOT NULL REFERENCES permissions(id) ON DELETE RESTRICT,
    write_perm INTEGER NOT NULL REFERENCES permissions(id) ON DELETE RESTRICT,  
    is_system BOOLEAN DEFAULT FALSE,
    created_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Config table
CREATE TABLE configs (
    id SERIAL PRIMARY KEY,
    entity_id INTEGER NOT NULL REFERENCES config_entities(id) ON DELETE CASCADE,
    key VARCHAR(255) NOT NULL,
    display_name VARCHAR(255),
    description TEXT,
    value JSONB,
    type VARCHAR(20) NOT NULL CHECK (type IN ('string', 'int', 'float', 'bool', 'json', 'choice')),
    metadata JSONB,
    is_system BOOLEAN DEFAULT FALSE,
    created_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    updated_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    UNIQUE(entity_id, key)
);

-- Indexes for config_entities table
CREATE INDEX idx_config_entities_name ON config_entities(name);
CREATE INDEX idx_config_entities_display_name ON config_entities(display_name);

-- Indexes for configs table
CREATE INDEX idx_configs_entity_id ON configs(entity_id);
CREATE INDEX idx_configs_key ON configs(key);
CREATE INDEX idx_configs_display_name ON configs(display_name);

-- Update triggers for config_entities table
CREATE TRIGGER update_config_entities_updated_at 
    BEFORE UPDATE ON config_entities 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Update triggers for configs table
CREATE TRIGGER update_configs_updated_at 
    BEFORE UPDATE ON configs 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
