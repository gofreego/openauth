package postgresql

import (
	"context"
	"database/sql"
	"fmt"
	"strings"

	"github.com/gofreego/openauth/internal/models/dao"
)

// CreatePermission creates a new permission in the database
func (r *Repository) CreatePermission(ctx context.Context, permission *dao.Permission) (*dao.Permission, error) {
	query := `
		INSERT INTO permissions (name, display_name, description, resource, action, is_system, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
		RETURNING id`

	var id int64
	err := r.connManager.Primary().QueryRowContext(ctx, query,
		permission.Name,
		permission.DisplayName,
		permission.Description,
		permission.Resource,
		permission.Action,
		permission.IsSystem,
		permission.CreatedAt,
		permission.UpdatedAt,
	).Scan(&id)

	if err != nil {
		return nil, fmt.Errorf("failed to create permission: %w", err)
	}

	permission.ID = id
	return permission, nil
}

// GetPermissionByID retrieves a permission by its ID
func (r *Repository) GetPermissionByID(ctx context.Context, id int64) (*dao.Permission, error) {
	query := `
		SELECT id, name, display_name, description, resource, action, is_system, created_at, updated_at
		FROM permissions
		WHERE id = $1`

	permission := &dao.Permission{}
	err := r.connManager.Primary().QueryRowContext(ctx, query, id).Scan(
		&permission.ID,
		&permission.Name,
		&permission.DisplayName,
		&permission.Description,
		&permission.Resource,
		&permission.Action,
		&permission.IsSystem,
		&permission.CreatedAt,
		&permission.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("failed to get permission: %w", err)
	}

	return permission, nil
}

// GetPermissionByName retrieves a permission by its name
func (r *Repository) GetPermissionByName(ctx context.Context, name string) (*dao.Permission, error) {
	query := `
		SELECT id, name, display_name, description, resource, action, is_system, created_at, updated_at
		FROM permissions
		WHERE name = $1`

	permission := &dao.Permission{}
	err := r.connManager.Primary().QueryRowContext(ctx, query, name).Scan(
		&permission.ID,
		&permission.Name,
		&permission.DisplayName,
		&permission.Description,
		&permission.Resource,
		&permission.Action,
		&permission.IsSystem,
		&permission.CreatedAt,
		&permission.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, fmt.Errorf("failed to get permission by name: %w", err)
	}

	return permission, nil
}

// ListPermissions retrieves permissions with filtering and pagination
func (r *Repository) ListPermissions(ctx context.Context, limit, offset int32, filters map[string]interface{}) ([]*dao.Permission, int32, error) {
	// Build WHERE clause
	var whereConditions []string
	var args []interface{}
	argIndex := 1

	if search, ok := filters["search"]; ok {
		whereConditions = append(whereConditions, fmt.Sprintf("(name ILIKE $%d OR display_name ILIKE $%d OR description ILIKE $%d)", argIndex, argIndex+1, argIndex+2))
		searchPattern := fmt.Sprintf("%%%s%%", search)
		args = append(args, searchPattern, searchPattern, searchPattern)
		argIndex += 3
	}

	if resource, ok := filters["resource"]; ok {
		whereConditions = append(whereConditions, fmt.Sprintf("resource = $%d", argIndex))
		args = append(args, resource)
		argIndex++
	}

	if action, ok := filters["action"]; ok {
		whereConditions = append(whereConditions, fmt.Sprintf("action = $%d", argIndex))
		args = append(args, action)
		argIndex++
	}

	if isSystem, ok := filters["is_system"]; ok {
		whereConditions = append(whereConditions, fmt.Sprintf("is_system = $%d", argIndex))
		args = append(args, isSystem)
		argIndex++
	}

	whereClause := ""
	if len(whereConditions) > 0 {
		whereClause = "WHERE " + strings.Join(whereConditions, " AND ")
	}

	// Count query
	countQuery := fmt.Sprintf("SELECT COUNT(*) FROM permissions %s", whereClause)
	var totalCount int32
	err := r.connManager.Primary().QueryRowContext(ctx, countQuery, args...).Scan(&totalCount)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count permissions: %w", err)
	}

	// Data query
	dataQuery := fmt.Sprintf(`
		SELECT id, name, display_name, description, resource, action, is_system, created_at, updated_at
		FROM permissions
		%s
		ORDER BY created_at DESC
		LIMIT $%d OFFSET $%d`, whereClause, argIndex, argIndex+1)

	args = append(args, limit, offset)

	rows, err := r.connManager.Primary().QueryContext(ctx, dataQuery, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query permissions: %w", err)
	}
	defer rows.Close()

	var permissions []*dao.Permission
	for rows.Next() {
		permission := &dao.Permission{}
		err := rows.Scan(
			&permission.ID,
			&permission.Name,
			&permission.DisplayName,
			&permission.Description,
			&permission.Resource,
			&permission.Action,
			&permission.IsSystem,
			&permission.CreatedAt,
			&permission.UpdatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan permission: %w", err)
		}
		permissions = append(permissions, permission)
	}

	if err = rows.Err(); err != nil {
		return nil, 0, fmt.Errorf("error iterating permissions: %w", err)
	}

	return permissions, totalCount, nil
}

// UpdatePermission updates an existing permission
func (r *Repository) UpdatePermission(ctx context.Context, id int64, updates map[string]interface{}) (*dao.Permission, error) {
	if len(updates) == 0 {
		return r.GetPermissionByID(ctx, id)
	}

	// Build SET clause
	var setClause []string
	var args []interface{}
	argIndex := 1

	for field, value := range updates {
		setClause = append(setClause, fmt.Sprintf("%s = $%d", field, argIndex))
		args = append(args, value)
		argIndex++
	}

	args = append(args, id) // WHERE id = $last

	query := fmt.Sprintf(`
		UPDATE permissions 
		SET %s
		WHERE id = $%d
		RETURNING id, name, display_name, description, resource, action, is_system, created_at, updated_at`,
		strings.Join(setClause, ", "), argIndex)

	permission := &dao.Permission{}
	err := r.connManager.Primary().QueryRowContext(ctx, query, args...).Scan(
		&permission.ID,
		&permission.Name,
		&permission.DisplayName,
		&permission.Description,
		&permission.Resource,
		&permission.Action,
		&permission.IsSystem,
		&permission.CreatedAt,
		&permission.UpdatedAt,
	)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("permission not found")
		}
		return nil, fmt.Errorf("failed to update permission: %w", err)
	}

	return permission, nil
}

// DeletePermission deletes a permission by ID
func (r *Repository) DeletePermission(ctx context.Context, id int64) error {
	query := `DELETE FROM permissions WHERE id = $1`

	result, err := r.connManager.Primary().ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to delete permission: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("permission not found")
	}

	return nil
}
