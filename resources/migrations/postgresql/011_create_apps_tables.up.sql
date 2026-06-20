CREATE TABLE apps (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    url VARCHAR(2048) NOT NULL,
    logo_url VARCHAR(2048),
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

CREATE TABLE user_apps (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    app_id INTEGER NOT NULL REFERENCES apps(id) ON DELETE CASCADE,
    assigned_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    UNIQUE(user_id, app_id)
);

CREATE INDEX idx_apps_name ON apps(name);
CREATE INDEX idx_user_apps_user_id ON user_apps(user_id);
CREATE INDEX idx_user_apps_app_id ON user_apps(app_id);

CREATE TRIGGER update_apps_updated_at 
    BEFORE UPDATE ON apps 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert system permissions for App management
-- Using system creator userID 1 (admin)
INSERT INTO permissions (name, display_name, description, is_system, created_by) VALUES
('apps.create', 'Create Apps', 'Ability to create apps', true, 1),
('apps.read', 'Read Apps', 'Ability to view app details', true, 1),
('apps.update', 'Update Apps', 'Ability to modify apps', true, 1),
('apps.delete', 'Delete Apps', 'Ability to delete apps', true, 1),
('apps.assign', 'Assign Apps', 'Ability to assign apps to users', true, 1),
('apps.list', 'List Apps', 'Ability to list all apps in system', true, 1);
