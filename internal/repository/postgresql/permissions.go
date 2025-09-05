package postgresql

import (
	"context"
	"database/sql"
	"fmt"
	"strings"

	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
)

// CreatePermission creates a new permission in the database
func (r *Repository) CreatePermission(ctx context.Context, permission *dao.Permission) (*dao.Permission, error) {
	query := `
		INSERT INTO permissions (name, display_name, description, is_system, created_by, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
		RETURNING id`

	var id int64
	err := r.connManager.Primary().QueryRowContext(ctx, query,
		permission.Name,
		permission.DisplayName,
		permission.Description,
		permission.IsSystem,
		permission.CreatedBy,
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
		SELECT id, name, display_name, description, is_system, created_by, created_at, updated_at
		FROM permissions
		WHERE id = $1`

	permission := &dao.Permission{}
	err := r.connManager.Primary().QueryRowContext(ctx, query, id).Scan(
		&permission.ID,
		&permission.Name,
		&permission.DisplayName,
		&permission.Description,
		&permission.IsSystem,
		&permission.CreatedBy,
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
		SELECT id, name, display_name, description, is_system, created_by, created_at, updated_at
		FROM permissions
		WHERE name = $1`

	permission := &dao.Permission{}
	err := r.connManager.Primary().QueryRowContext(ctx, query, name).Scan(
		&permission.ID,
		&permission.Name,
		&permission.DisplayName,
		&permission.Description,
		&permission.IsSystem,
		&permission.CreatedBy,
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
func (r *Repository) ListPermissions(ctx context.Context, filters *filter.PermissionFilter) ([]*dao.Permission, error) {
	// Build WHERE clause
	var whereConditions []string
	var args []interface{}
	argIndex := 1

	if filters.HasSearch() {
		whereConditions = append(whereConditions, fmt.Sprintf("(name ILIKE $%d OR display_name ILIKE $%d OR description ILIKE $%d)", argIndex, argIndex+1, argIndex+2))
		searchPattern := fmt.Sprintf("%%%s%%", *filters.Search)
		args = append(args, searchPattern, searchPattern, searchPattern)
		argIndex += 3
	}

	if filters.HasResource() {
		// Parse resource from name field (format: "resource.action")
		whereConditions = append(whereConditions, fmt.Sprintf("name LIKE $%d", argIndex))
		args = append(args, fmt.Sprintf("%s.%%", *filters.Resource))
		argIndex++
	}

	if filters.HasAction() {
		// Parse action from name field (format: "resource.action")
		whereConditions = append(whereConditions, fmt.Sprintf("name LIKE $%d", argIndex))
		args = append(args, fmt.Sprintf("%%.%s", *filters.Action))
		argIndex++
	}

	if filters.HasIsSystem() {
		whereConditions = append(whereConditions, fmt.Sprintf("is_system = $%d", argIndex))
		args = append(args, *filters.IsSystem)
		argIndex++
	}

	whereClause := ""
	if len(whereConditions) > 0 {
		whereClause = "WHERE " + strings.Join(whereConditions, " AND ")
	}

	// Data query
	dataQuery := fmt.Sprintf(`
		SELECT id, name, display_name, description, is_system, created_by, created_at, updated_at
		FROM permissions
		%s
		ORDER BY created_at DESC`, whereClause)

	if !filters.All {
		dataQuery += fmt.Sprintf(" LIMIT $%d OFFSET $%d", argIndex, argIndex+1)
		args = append(args, filters.Limit, filters.Offset)
	}

	rows, err := r.connManager.Primary().QueryContext(ctx, dataQuery, args...)
	if err != nil {
		return nil, fmt.Errorf("failed to query permissions: %w", err)
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
			&permission.IsSystem,
			&permission.CreatedBy,
			&permission.CreatedAt,
			&permission.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan permission: %w", err)
		}
		permissions = append(permissions, permission)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating permissions: %w", err)
	}

	return permissions, nil
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
		RETURNING id, name, display_name, description, is_system, created_by, created_at, updated_at`,
		strings.Join(setClause, ", "), argIndex)

	permission := &dao.Permission{}
	err := r.connManager.Primary().QueryRowContext(ctx, query, args...).Scan(
		&permission.ID,
		&permission.Name,
		&permission.DisplayName,
		&permission.Description,
		&permission.IsSystem,
		&permission.CreatedBy,
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
