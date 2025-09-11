package postgresql

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
	"time"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
)

// Config Entity Repository Methods

// CreateConfigEntity creates a new config entity in the database
func (r *Repository) CreateConfigEntity(ctx context.Context, entity *dao.ConfigEntity) (*dao.ConfigEntity, error) {
	logger.Debug(ctx, "Creating config entity with name: %s", entity.Name)

	query := `
		INSERT INTO config_entities (name, display_name, description, read_perm, write_perm, created_by, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
		RETURNING id`

	err := r.connManager.Primary().QueryRowContext(ctx, query,
		entity.Name,
		entity.DisplayName,
		entity.Description,
		entity.ReadPerm,
		entity.WritePerm,
		entity.CreatedBy,
		entity.CreatedAt,
		entity.UpdatedAt,
	).Scan(&entity.ID)

	if err != nil {
		logger.Error(ctx, "Failed to create config entity: %v", err)
		return nil, fmt.Errorf("failed to create config entity: %w", err)
	}

	logger.Debug(ctx, "Config entity created successfully with ID: %d", entity.ID)
	return entity, nil
}

// GetConfigEntityByID retrieves a config entity by ID
func (r *Repository) GetConfigEntityByID(ctx context.Context, id int64) (*dao.ConfigEntity, error) {
	logger.Debug(ctx, "Getting config entity by ID: %d", id)

	entity := &dao.ConfigEntity{}
	query := `
		SELECT id, name, display_name, description, read_perm, write_perm, created_by, created_at, updated_at
		FROM config_entities
		WHERE id = $1`

	err := r.connManager.Primary().QueryRowContext(ctx, query, id).Scan(
		&entity.ID,
		&entity.Name,
		&entity.DisplayName,
		&entity.Description,
		&entity.ReadPerm,
		&entity.WritePerm,
		&entity.CreatedBy,
		&entity.CreatedAt,
		&entity.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			logger.Debug(ctx, "Config entity not found with ID: %d", id)
			return nil, nil
		}
		logger.Error(ctx, "Failed to get config entity by ID: %v", err)
		return nil, fmt.Errorf("failed to get config entity: %w", err)
	}

	logger.Debug(ctx, "Config entity retrieved successfully: %s", entity.Name)
	return entity, nil
}

// GetConfigEntityByName retrieves a config entity by name
func (r *Repository) GetConfigEntityByName(ctx context.Context, name string) (*dao.ConfigEntity, error) {
	logger.Debug(ctx, "Getting config entity by name: %s", name)

	entity := &dao.ConfigEntity{}
	query := `
		SELECT id, name, display_name, description, read_perm, write_perm, created_by, created_at, updated_at
		FROM config_entities
		WHERE name = $1`

	err := r.connManager.Primary().QueryRowContext(ctx, query, name).Scan(
		&entity.ID,
		&entity.Name,
		&entity.DisplayName,
		&entity.Description,
		&entity.ReadPerm,
		&entity.WritePerm,
		&entity.CreatedBy,
		&entity.CreatedAt,
		&entity.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			logger.Debug(ctx, "Config entity not found with name: %s", name)
			return nil, nil
		}
		logger.Error(ctx, "Failed to get config entity by name: %v", err)
		return nil, fmt.Errorf("failed to get config entity: %w", err)
	}

	logger.Debug(ctx, "Config entity retrieved successfully: %s", entity.Name)
	return entity, nil
}

// ListConfigEntities lists config entities with filtering and pagination
func (r *Repository) ListConfigEntities(ctx context.Context, filters *filter.ConfigEntityFilter) ([]*dao.ConfigEntity, error) {
	logger.Debug(ctx, "Listing config entities with filters")

	var conditions []string
	var args []interface{}
	argIndex := 1

	// Build WHERE conditions
	if filters.Search != nil && *filters.Search != "" {
		conditions = append(conditions, fmt.Sprintf("(name ILIKE $%d OR display_name ILIKE $%d)", argIndex, argIndex))
		args = append(args, "%"+*filters.Search+"%")
		argIndex++
	}

	// Build query
	query := `
		SELECT id, name, display_name, description, read_perm, write_perm, created_by, created_at, updated_at
		FROM config_entities`

	if len(conditions) > 0 {
		query += " WHERE " + strings.Join(conditions, " AND ")
	}

	query += " ORDER BY name ASC"

	// Add pagination
	if !filters.All {
		query += fmt.Sprintf(" LIMIT $%d OFFSET $%d", argIndex, argIndex+1)
		args = append(args, filters.Limit, filters.Offset)
	}

	rows, err := r.connManager.Primary().QueryContext(ctx, query, args...)
	if err != nil {
		logger.Error(ctx, "Failed to list config entities: %v", err)
		return nil, fmt.Errorf("failed to list config entities: %w", err)
	}
	defer rows.Close()

	var entities []*dao.ConfigEntity
	for rows.Next() {
		entity := &dao.ConfigEntity{}
		err := rows.Scan(
			&entity.ID,
			&entity.Name,
			&entity.DisplayName,
			&entity.Description,
			&entity.ReadPerm,
			&entity.WritePerm,
			&entity.CreatedBy,
			&entity.CreatedAt,
			&entity.UpdatedAt,
		)
		if err != nil {
			logger.Error(ctx, "Failed to scan config entity: %v", err)
			return nil, fmt.Errorf("failed to scan config entity: %w", err)
		}
		entities = append(entities, entity)
	}

	if err = rows.Err(); err != nil {
		logger.Error(ctx, "Error iterating config entities: %v", err)
		return nil, fmt.Errorf("error iterating config entities: %w", err)
	}

	logger.Debug(ctx, "Successfully retrieved %d config entities", len(entities))
	return entities, nil
}

// UpdateConfigEntity updates a config entity
func (r *Repository) UpdateConfigEntity(ctx context.Context, id int64, updates map[string]interface{}) (*dao.ConfigEntity, error) {
	logger.Debug(ctx, "Updating config entity with ID: %d", id)

	if len(updates) == 0 {
		return r.GetConfigEntityByID(ctx, id)
	}

	// Build dynamic update query
	var setParts []string
	var args []interface{}
	argIndex := 1

	for field, value := range updates {
		setParts = append(setParts, fmt.Sprintf("%s = $%d", field, argIndex))
		args = append(args, value)
		argIndex++
	}

	// Always update the updated_at timestamp
	setParts = append(setParts, fmt.Sprintf("updated_at = $%d", argIndex))
	args = append(args, time.Now().UnixMilli())
	argIndex++

	// Add ID for WHERE clause
	args = append(args, id)

	query := fmt.Sprintf(`
		UPDATE config_entities
		SET %s
		WHERE id = $%d
		RETURNING id, name, display_name, description, read_perm, write_perm, created_by, created_at, updated_at`,
		strings.Join(setParts, ", "), argIndex)

	entity := &dao.ConfigEntity{}
	err := r.connManager.Primary().QueryRowContext(ctx, query, args...).Scan(
		&entity.ID,
		&entity.Name,
		&entity.DisplayName,
		&entity.Description,
		&entity.ReadPerm,
		&entity.WritePerm,
		&entity.CreatedBy,
		&entity.CreatedAt,
		&entity.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			logger.Warn(ctx, "Config entity not found for update with ID: %d", id)
			return nil, fmt.Errorf("config entity not found")
		}
		logger.Error(ctx, "Failed to update config entity: %v", err)
		return nil, fmt.Errorf("failed to update config entity: %w", err)
	}

	logger.Debug(ctx, "Config entity updated successfully: %d", entity.ID)
	return entity, nil
}

// DeleteConfigEntity deletes a config entity
func (r *Repository) DeleteConfigEntity(ctx context.Context, id int64) error {
	logger.Debug(ctx, "Deleting config entity with ID: %d", id)

	query := `DELETE FROM config_entities WHERE id = $1`
	result, err := r.connManager.Primary().ExecContext(ctx, query, id)
	if err != nil {
		logger.Error(ctx, "Failed to delete config entity: %v", err)
		return fmt.Errorf("failed to delete config entity: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		logger.Error(ctx, "Failed to get rows affected: %v", err)
		return fmt.Errorf("failed to verify deletion: %w", err)
	}

	if rowsAffected == 0 {
		logger.Warn(ctx, "No config entity found to delete with ID: %d", id)
		return fmt.Errorf("config entity not found")
	}

	logger.Debug(ctx, "Config entity deleted successfully: %d", id)
	return nil
}

// Config Repository Methods

// CreateConfig creates a new config in the database
func (r *Repository) CreateConfig(ctx context.Context, config *dao.Config) (*dao.Config, error) {
	logger.Debug(ctx, "Creating config with key: %s for entity: %d", config.Key, config.EntityID)

	query := `
		INSERT INTO configs (entity_id, key, display_name, description, value, type, metadata, created_by, updated_by, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
		RETURNING id`

	err := r.connManager.Primary().QueryRowContext(ctx, query,
		config.EntityID,
		config.Key,
		config.DisplayName,
		config.Description,
		config.Value,
		config.Type,
		config.Metadata,
		config.CreatedBy,
		config.UpdatedBy,
		config.CreatedAt,
		config.UpdatedAt,
	).Scan(&config.ID)

	if err != nil {
		logger.Error(ctx, "Failed to create config: %v", err)
		return nil, fmt.Errorf("failed to create config: %w", err)
	}

	logger.Debug(ctx, "Config created successfully with ID: %d", config.ID)
	return config, nil
}

// GetConfigByID retrieves a config by ID
func (r *Repository) GetConfigByID(ctx context.Context, id int64) (*dao.Config, error) {
	logger.Debug(ctx, "Getting config by ID: %d", id)

	config := &dao.Config{}
	query := `
		SELECT id, entity_id, key, display_name, description, value, type, metadata, created_by, updated_by, created_at, updated_at
		FROM configs
		WHERE id = $1`

	err := r.connManager.Primary().QueryRowContext(ctx, query, id).Scan(
		&config.ID,
		&config.EntityID,
		&config.Key,
		&config.DisplayName,
		&config.Description,
		&config.Value,
		&config.Type,
		&config.Metadata,
		&config.CreatedBy,
		&config.UpdatedBy,
		&config.CreatedAt,
		&config.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			logger.Debug(ctx, "Config not found with ID: %d", id)
			return nil, nil
		}
		logger.Error(ctx, "Failed to get config by ID: %v", err)
		return nil, fmt.Errorf("failed to get config: %w", err)
	}

	logger.Debug(ctx, "Config retrieved successfully: %s", config.Key)
	return config, nil
}

// GetConfigByEntityAndKey retrieves a config by entity ID and key
func (r *Repository) GetConfigByEntityAndKey(ctx context.Context, entityID int64, key string) (*dao.Config, error) {
	logger.Debug(ctx, "Getting config by entity ID: %d and key: %s", entityID, key)

	config := &dao.Config{}
	query := `
		SELECT id, entity_id, key, display_name, description, value, type, metadata, created_by, updated_by, created_at, updated_at
		FROM configs
		WHERE entity_id = $1 AND key = $2`

	err := r.connManager.Primary().QueryRowContext(ctx, query, entityID, key).Scan(
		&config.ID,
		&config.EntityID,
		&config.Key,
		&config.DisplayName,
		&config.Description,
		&config.Value,
		&config.Type,
		&config.Metadata,
		&config.CreatedBy,
		&config.UpdatedBy,
		&config.CreatedAt,
		&config.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			logger.Debug(ctx, "Config not found with entity ID: %d and key: %s", entityID, key)
			return nil, nil
		}
		logger.Error(ctx, "Failed to get config by entity and key: %v", err)
		return nil, fmt.Errorf("failed to get config: %w", err)
	}

	logger.Debug(ctx, "Config retrieved successfully: %s", config.Key)
	return config, nil
}

// GetConfigByEntityNameAndKey retrieves a config by entity name and key
func (r *Repository) GetConfigByEntityNameAndKey(ctx context.Context, entityName, key string) (*dao.Config, error) {
	logger.Debug(ctx, "Getting config by entity name: %s and key: %s", entityName, key)

	config := &dao.Config{}
	query := `
		SELECT c.id, c.entity_id, c.key, c.display_name, c.description, c.value, c.type, c.metadata, c.created_by, c.updated_by, c.created_at, c.updated_at
		FROM configs c
		JOIN config_entities e ON c.entity_id = e.id
		WHERE e.name = $1 AND c.key = $2`

	err := r.connManager.Primary().QueryRowContext(ctx, query, entityName, key).Scan(
		&config.ID,
		&config.EntityID,
		&config.Key,
		&config.DisplayName,
		&config.Description,
		&config.Value,
		&config.Type,
		&config.Metadata,
		&config.CreatedBy,
		&config.UpdatedBy,
		&config.CreatedAt,
		&config.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			logger.Debug(ctx, "Config not found with entity name: %s and key: %s", entityName, key)
			return nil, nil
		}
		logger.Error(ctx, "Failed to get config by entity name and key: %v", err)
		return nil, fmt.Errorf("failed to get config: %w", err)
	}

	logger.Debug(ctx, "Config retrieved successfully: %s", config.Key)
	return config, nil
}

// GetConfigsByEntityAndKeys retrieves multiple configs by entity ID and keys
func (r *Repository) GetConfigsByEntityAndKeys(ctx context.Context, entityID int64, keys []string) (map[string]*dao.Config, error) {
	logger.Debug(ctx, "Getting %d configs by entity ID: %d", len(keys), entityID)

	if len(keys) == 0 {
		return make(map[string]*dao.Config), nil
	}

	// Build placeholders for keys
	placeholders := make([]string, len(keys))
	args := []interface{}{entityID}
	for i, key := range keys {
		placeholders[i] = fmt.Sprintf("$%d", i+2)
		args = append(args, key)
	}

	query := fmt.Sprintf(`
		SELECT id, entity_id, key, display_name, description, value, type, metadata, created_by, updated_by, created_at, updated_at
		FROM configs
		WHERE entity_id = $1 AND key IN (%s)`, strings.Join(placeholders, ","))

	rows, err := r.connManager.Primary().QueryContext(ctx, query, args...)
	if err != nil {
		logger.Error(ctx, "Failed to get configs by entity and keys: %v", err)
		return nil, fmt.Errorf("failed to get configs: %w", err)
	}
	defer rows.Close()

	configs := make(map[string]*dao.Config)
	for rows.Next() {
		config := &dao.Config{}
		err := rows.Scan(
			&config.ID,
			&config.EntityID,
			&config.Key,
			&config.DisplayName,
			&config.Description,
			&config.Value,
			&config.Type,
			&config.Metadata,
			&config.CreatedBy,
			&config.UpdatedBy,
			&config.CreatedAt,
			&config.UpdatedAt,
		)
		if err != nil {
			logger.Error(ctx, "Failed to scan config: %v", err)
			return nil, fmt.Errorf("failed to scan config: %w", err)
		}
		configs[config.Key] = config
	}

	if err = rows.Err(); err != nil {
		logger.Error(ctx, "Error iterating configs: %v", err)
		return nil, fmt.Errorf("error iterating configs: %w", err)
	}

	logger.Debug(ctx, "Successfully retrieved %d configs", len(configs))
	return configs, nil
}

// GetConfigsByEntityNameAndKeys retrieves multiple configs by entity name and keys
func (r *Repository) GetConfigsByEntityNameAndKeys(ctx context.Context, entityName string, keys []string) (map[string]*dao.Config, error) {
	logger.Debug(ctx, "Getting %d configs by entity name: %s", len(keys), entityName)

	if len(keys) == 0 {
		return make(map[string]*dao.Config), nil
	}

	// Build placeholders for keys
	placeholders := make([]string, len(keys))
	args := []interface{}{entityName}
	for i, key := range keys {
		placeholders[i] = fmt.Sprintf("$%d", i+2)
		args = append(args, key)
	}

	query := fmt.Sprintf(`
		SELECT c.id, c.entity_id, c.key, c.display_name, c.description, c.value, c.type, c.metadata, c.created_by, c.updated_by, c.created_at, c.updated_at
		FROM configs c
		JOIN config_entities e ON c.entity_id = e.id
		WHERE e.name = $1 AND c.key IN (%s)`, strings.Join(placeholders, ","))

	rows, err := r.connManager.Primary().QueryContext(ctx, query, args...)
	if err != nil {
		logger.Error(ctx, "Failed to get configs by entity name and keys: %v", err)
		return nil, fmt.Errorf("failed to get configs: %w", err)
	}
	defer rows.Close()

	configs := make(map[string]*dao.Config)
	for rows.Next() {
		config := &dao.Config{}
		err := rows.Scan(
			&config.ID,
			&config.EntityID,
			&config.Key,
			&config.DisplayName,
			&config.Description,
			&config.Value,
			&config.Type,
			&config.Metadata,
			&config.CreatedBy,
			&config.UpdatedBy,
			&config.CreatedAt,
			&config.UpdatedAt,
		)
		if err != nil {
			logger.Error(ctx, "Failed to scan config: %v", err)
			return nil, fmt.Errorf("failed to scan config: %w", err)
		}
		configs[config.Key] = config
	}

	if err = rows.Err(); err != nil {
		logger.Error(ctx, "Error iterating configs: %v", err)
		return nil, fmt.Errorf("error iterating configs: %w", err)
	}

	logger.Debug(ctx, "Successfully retrieved %d configs", len(configs))
	return configs, nil
}

// ListConfigs lists configs with filtering and pagination
func (r *Repository) ListConfigs(ctx context.Context, filters *filter.ConfigFilter) ([]*dao.Config, int64, error) {
	logger.Debug(ctx, "Listing configs with filters")

	var conditions []string
	var args []interface{}
	argIndex := 1

	// Build WHERE conditions
	if filters.EntityID != nil {
		conditions = append(conditions, fmt.Sprintf("c.entity_id = $%d", argIndex))
		args = append(args, *filters.EntityID)
		argIndex++
	}

	if filters.Search != nil && *filters.Search != "" {
		conditions = append(conditions, fmt.Sprintf("(c.key ILIKE $%d OR c.display_name ILIKE $%d)", argIndex, argIndex))
		args = append(args, "%"+*filters.Search+"%")
		argIndex++
	}

	// Build base query
	baseQuery := `
		FROM configs c
		JOIN config_entities e ON c.entity_id = e.id`

	if len(conditions) > 0 {
		baseQuery += " WHERE " + strings.Join(conditions, " AND ")
	}

	// Get total count
	countQuery := "SELECT COUNT(*) " + baseQuery
	var total int64
	err := r.connManager.Primary().QueryRowContext(ctx, countQuery, args...).Scan(&total)
	if err != nil {
		logger.Error(ctx, "Failed to get configs count: %v", err)
		return nil, 0, fmt.Errorf("failed to get configs count: %w", err)
	}

	// Build main query
	query := `
		SELECT c.id, c.entity_id, c.key, c.display_name, c.description, c.value, c.type, c.metadata, c.created_by, c.updated_by, c.created_at, c.updated_at
		` + baseQuery + ` ORDER BY e.name ASC, c.key ASC`

	// Add pagination
	if !filters.All {
		query += fmt.Sprintf(" LIMIT $%d OFFSET $%d", argIndex, argIndex+1)
		args = append(args, filters.Limit, filters.Offset)
	}

	rows, err := r.connManager.Primary().QueryContext(ctx, query, args...)
	if err != nil {
		logger.Error(ctx, "Failed to list configs: %v", err)
		return nil, 0, fmt.Errorf("failed to list configs: %w", err)
	}
	defer rows.Close()

	var configs []*dao.Config
	for rows.Next() {
		config := &dao.Config{}
		err := rows.Scan(
			&config.ID,
			&config.EntityID,
			&config.Key,
			&config.DisplayName,
			&config.Description,
			&config.Value,
			&config.Type,
			&config.Metadata,
			&config.CreatedBy,
			&config.UpdatedBy,
			&config.CreatedAt,
			&config.UpdatedAt,
		)
		if err != nil {
			logger.Error(ctx, "Failed to scan config: %v", err)
			return nil, 0, fmt.Errorf("failed to scan config: %w", err)
		}
		configs = append(configs, config)
	}

	if err = rows.Err(); err != nil {
		logger.Error(ctx, "Error iterating configs: %v", err)
		return nil, 0, fmt.Errorf("error iterating configs: %w", err)
	}

	logger.Debug(ctx, "Successfully retrieved %d configs out of %d total", len(configs), total)
	return configs, total, nil
}

// UpdateConfig updates a config
func (r *Repository) UpdateConfig(ctx context.Context, id int64, updates map[string]interface{}) (*dao.Config, error) {
	logger.Debug(ctx, "Updating config with ID: %d", id)

	if len(updates) == 0 {
		return r.GetConfigByID(ctx, id)
	}

	// Build dynamic update query
	var setParts []string
	var args []interface{}
	argIndex := 1

	for field, value := range updates {
		setParts = append(setParts, fmt.Sprintf("%s = $%d", field, argIndex))
		args = append(args, value)
		argIndex++
	}

	// Always update the updated_at timestamp
	setParts = append(setParts, fmt.Sprintf("updated_at = $%d", argIndex))
	args = append(args, time.Now().UnixMilli())
	argIndex++

	// Add ID for WHERE clause
	args = append(args, id)

	query := fmt.Sprintf(`
		UPDATE configs
		SET %s
		WHERE id = $%d
		RETURNING id, entity_id, key, display_name, description, value, type, metadata, created_by, updated_by, created_at, updated_at`,
		strings.Join(setParts, ", "), argIndex)

	config := &dao.Config{}
	err := r.connManager.Primary().QueryRowContext(ctx, query, args...).Scan(
		&config.ID,
		&config.EntityID,
		&config.Key,
		&config.DisplayName,
		&config.Description,
		&config.Value,
		&config.Type,
		&config.Metadata,
		&config.CreatedBy,
		&config.UpdatedBy,
		&config.CreatedAt,
		&config.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			logger.Warn(ctx, "Config not found for update with ID: %d", id)
			return nil, fmt.Errorf("config not found")
		}
		logger.Error(ctx, "Failed to update config: %v", err)
		return nil, fmt.Errorf("failed to update config: %w", err)
	}

	logger.Debug(ctx, "Config updated successfully: %d", config.ID)
	return config, nil
}

// DeleteConfig deletes a config
func (r *Repository) DeleteConfig(ctx context.Context, id int64) error {
	logger.Debug(ctx, "Deleting config with ID: %d", id)

	query := `DELETE FROM configs WHERE id = $1`
	result, err := r.connManager.Primary().ExecContext(ctx, query, id)
	if err != nil {
		logger.Error(ctx, "Failed to delete config: %v", err)
		return fmt.Errorf("failed to delete config: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		logger.Error(ctx, "Failed to get rows affected: %v", err)
		return fmt.Errorf("failed to verify deletion: %w", err)
	}

	if rowsAffected == 0 {
		logger.Warn(ctx, "No config found to delete with ID: %d", id)
		return fmt.Errorf("config not found")
	}

	logger.Debug(ctx, "Config deleted successfully: %d", id)
	return nil
}
