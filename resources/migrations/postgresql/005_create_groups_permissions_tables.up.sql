-- Create permissions table
CREATE TABLE permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL, -- e.g., 'users.create', 'posts.delete'
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    is_system BOOLEAN DEFAULT FALSE, -- System permissions cannot be deleted
    created_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Create groups/roles table
CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    uuid UUID UNIQUE DEFAULT gen_random_uuid(),
    name VARCHAR(255) UNIQUE NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    is_system BOOLEAN DEFAULT FALSE, -- System groups cannot be deleted
    is_default BOOLEAN DEFAULT FALSE, -- Default group for new users
    created_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    updated_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
);

-- Create group permissions junction table
CREATE TABLE group_permissions (
    id SERIAL PRIMARY KEY,
    group_id INTEGER NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT, -- Who granted this permission
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    UNIQUE(group_id, permission_id)
);

-- Create user groups junction table
CREATE TABLE user_groups (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    group_id INTEGER NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    assigned_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT, -- Who assigned this group
    expires_at BIGINT, -- Optional expiration date
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    UNIQUE(user_id, group_id)
);

-- Create direct user permissions table (for permissions granted directly to users)
CREATE TABLE user_permissions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_by INTEGER NOT NULL REFERENCES users(id) ON DELETE RESTRICT, -- Who granted this permission
    expires_at BIGINT, -- Optional expiration date
    created_at BIGINT DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000,
    UNIQUE(user_id, permission_id)
);

-- Create indexes
CREATE INDEX idx_permissions_name ON permissions(name);
CREATE INDEX idx_permissions_system ON permissions(is_system);

CREATE INDEX idx_groups_uuid ON groups(uuid);
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

-- Add triggers
CREATE TRIGGER update_permissions_updated_at 
    BEFORE UPDATE ON permissions 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_groups_updated_at 
    BEFORE UPDATE ON groups 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
