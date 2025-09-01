package postgresql

import (
	"context"
	"fmt"
	"time"

	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
)

// AssignPermissionToGroup assigns a permission to a group
func (r *Repository) AssignPermissionToGroup(ctx context.Context, groupID, permissionID, grantedBy int64) (*dao.GroupPermission, error) {
	// Check if assignment already exists
	exists, err := r.IsPermissionAssignedToGroup(ctx, groupID, permissionID)
	if err != nil {
		return nil, err
	}
	if exists {
		return nil, fmt.Errorf("permission %d is already assigned to group %d", permissionID, groupID)
	}

	// Validate that group and permission exist
	group, err := r.GetGroupByID(ctx, groupID)
	if err != nil {
		return nil, fmt.Errorf("failed to get group: %w", err)
	}
	if group == nil {
		return nil, fmt.Errorf("group with ID %d not found", groupID)
	}

	permission, err := r.GetPermissionByID(ctx, permissionID)
	if err != nil {
		return nil, fmt.Errorf("failed to get permission: %w", err)
	}
	if permission == nil {
		return nil, fmt.Errorf("permission with ID %d not found", permissionID)
	}

	query := `
		INSERT INTO group_permissions (group_id, permission_id, granted_by, created_at)
		VALUES ($1, $2, $3, $4)
		RETURNING id, group_id, permission_id, granted_by, created_at
	`

	now := time.Now().Unix()
	groupPermission := &dao.GroupPermission{}

	err = r.connManager.Primary().QueryRowContext(ctx, query, groupID, permissionID, grantedBy, now).Scan(
		&groupPermission.ID,
		&groupPermission.GroupID,
		&groupPermission.PermissionID,
		&groupPermission.GrantedBy,
		&groupPermission.CreatedAt,
	)
	if err != nil {
		return nil, fmt.Errorf("failed to assign permission to group: %w", err)
	}

	return groupPermission, nil
}

// RemovePermissionFromGroup removes a permission from a group
func (r *Repository) RemovePermissionFromGroup(ctx context.Context, groupID, permissionID int64) error {
	query := `DELETE FROM group_permissions WHERE group_id = $1 AND permission_id = $2`

	result, err := r.connManager.Primary().ExecContext(ctx, query, groupID, permissionID)
	if err != nil {
		return fmt.Errorf("failed to remove permission from group: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("permission %d is not assigned to group %d", permissionID, groupID)
	}

	return nil
}

// ListGroupPermissions retrieves permissions assigned to a group with filtering and pagination
func (r *Repository) ListGroupPermissions(ctx context.Context, filters *filter.GroupPermissionFilter) ([]*dao.GroupPermission, error) {
	baseQuery := `
		SELECT gp.id, gp.group_id, gp.permission_id, gp.granted_by, gp.created_at
		FROM group_permissions gp
		JOIN permissions p ON gp.permission_id = p.id
		WHERE gp.group_id = $1
	`

	args := []interface{}{filters.GroupID}
	argIndex := 2

	// Add search filter if provided
	if filters.Search != nil {
		baseQuery += fmt.Sprintf(" AND (p.name ILIKE $%d OR p.display_name ILIKE $%d OR p.description ILIKE $%d)", argIndex, argIndex, argIndex)
		searchTerm := "%" + *filters.Search + "%"
		args = append(args, searchTerm)
		argIndex++
	}

	// Add permission ID filter if provided
	if filters.PermissionID != nil {
		baseQuery += fmt.Sprintf(" AND gp.permission_id = $%d", argIndex)
		args = append(args, *filters.PermissionID)
		argIndex++
	}

	// Add ordering and pagination
	baseQuery += " ORDER BY gp.created_at DESC"
	baseQuery += fmt.Sprintf(" LIMIT $%d OFFSET $%d", argIndex, argIndex+1)
	args = append(args, filters.Limit, filters.Offset)

	rows, err := r.connManager.Primary().QueryContext(ctx, baseQuery, args...)
	if err != nil {
		return nil, fmt.Errorf("failed to list group permissions: %w", err)
	}
	defer rows.Close()

	var groupPermissions []*dao.GroupPermission
	for rows.Next() {
		gp := &dao.GroupPermission{}
		err := rows.Scan(
			&gp.ID,
			&gp.GroupID,
			&gp.PermissionID,
			&gp.GrantedBy,
			&gp.CreatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan group permission: %w", err)
		}
		groupPermissions = append(groupPermissions, gp)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating group permissions: %w", err)
	}

	return groupPermissions, nil
}

// IsPermissionAssignedToGroup checks if a permission is assigned to a group
func (r *Repository) IsPermissionAssignedToGroup(ctx context.Context, groupID, permissionID int64) (bool, error) {
	query := `SELECT EXISTS(SELECT 1 FROM group_permissions WHERE group_id = $1 AND permission_id = $2)`

	var exists bool
	err := r.connManager.Primary().QueryRowContext(ctx, query, groupID, permissionID).Scan(&exists)
	if err != nil {
		return false, fmt.Errorf("failed to check if permission is assigned to group: %w", err)
	}

	return exists, nil
}

// AssignPermissionToUser assigns a permission directly to a user
func (r *Repository) AssignPermissionToUser(ctx context.Context, userID, permissionID, grantedBy int64, expiresAt *int64) (*dao.UserPermission, error) {
	// Check if assignment already exists
	exists, err := r.IsPermissionAssignedToUser(ctx, userID, permissionID)
	if err != nil {
		return nil, err
	}
	if exists {
		return nil, fmt.Errorf("permission %d is already assigned to user %d", permissionID, userID)
	}

	// Validate that user and permission exist
	user, err := r.GetUserByID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to get user: %w", err)
	}
	if user == nil {
		return nil, fmt.Errorf("user with ID %d not found", userID)
	}

	permission, err := r.GetPermissionByID(ctx, permissionID)
	if err != nil {
		return nil, fmt.Errorf("failed to get permission: %w", err)
	}
	if permission == nil {
		return nil, fmt.Errorf("permission with ID %d not found", permissionID)
	}

	query := `
		INSERT INTO user_permissions (user_id, permission_id, granted_by, expires_at, created_at)
		VALUES ($1, $2, $3, $4, $5)
		RETURNING id, user_id, permission_id, granted_by, expires_at, created_at
	`

	now := time.Now().Unix()
	userPermission := &dao.UserPermission{}

	err = r.connManager.Primary().QueryRowContext(ctx, query, userID, permissionID, grantedBy, expiresAt, now).Scan(
		&userPermission.ID,
		&userPermission.UserID,
		&userPermission.PermissionID,
		&userPermission.GrantedBy,
		&userPermission.ExpiresAt,
		&userPermission.CreatedAt,
	)
	if err != nil {
		return nil, fmt.Errorf("failed to assign permission to user: %w", err)
	}

	return userPermission, nil
}

// RemovePermissionFromUser removes a permission directly assigned to a user
func (r *Repository) RemovePermissionFromUser(ctx context.Context, userID, permissionID int64) error {
	query := `DELETE FROM user_permissions WHERE user_id = $1 AND permission_id = $2`

	result, err := r.connManager.Primary().ExecContext(ctx, query, userID, permissionID)
	if err != nil {
		return fmt.Errorf("failed to remove permission from user: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("permission %d is not assigned to user %d", permissionID, userID)
	}

	return nil
}

// ListUserPermissions retrieves permissions directly assigned to a user with filtering and pagination
func (r *Repository) ListUserPermissions(ctx context.Context, filters *filter.UserPermissionFilter) ([]*dao.UserPermission, error) {
	baseQuery := `
		SELECT up.id, up.user_id, up.permission_id, up.granted_by, up.expires_at, up.created_at
		FROM user_permissions up
		JOIN permissions p ON up.permission_id = p.id
		WHERE up.user_id = $1
	`

	args := []interface{}{filters.UserID}
	argIndex := 2

	// Add search filter if provided
	if filters.Search != nil {
		baseQuery += fmt.Sprintf(" AND (p.name ILIKE $%d OR p.display_name ILIKE $%d OR p.description ILIKE $%d)", argIndex, argIndex, argIndex)
		searchTerm := "%" + *filters.Search + "%"
		args = append(args, searchTerm)
		argIndex++
	}

	// Add permission ID filter if provided
	if filters.PermissionID != nil {
		baseQuery += fmt.Sprintf(" AND up.permission_id = $%d", argIndex)
		args = append(args, *filters.PermissionID)
		argIndex++
	}

	// Add expiration filter if provided
	if filters.Expired != nil {
		now := time.Now().Unix()
		if *filters.Expired {
			// Show only expired permissions
			baseQuery += fmt.Sprintf(" AND up.expires_at IS NOT NULL AND up.expires_at < $%d", argIndex)
			args = append(args, now)
		} else {
			// Show only non-expired permissions
			baseQuery += fmt.Sprintf(" AND (up.expires_at IS NULL OR up.expires_at >= $%d)", argIndex)
			args = append(args, now)
		}
		argIndex++
	}

	// Add ordering and pagination
	baseQuery += " ORDER BY up.created_at DESC"
	baseQuery += fmt.Sprintf(" LIMIT $%d OFFSET $%d", argIndex, argIndex+1)
	args = append(args, filters.Limit, filters.Offset)

	rows, err := r.connManager.Primary().QueryContext(ctx, baseQuery, args...)
	if err != nil {
		return nil, fmt.Errorf("failed to list user permissions: %w", err)
	}
	defer rows.Close()

	var userPermissions []*dao.UserPermission
	for rows.Next() {
		up := &dao.UserPermission{}
		err := rows.Scan(
			&up.ID,
			&up.UserID,
			&up.PermissionID,
			&up.GrantedBy,
			&up.ExpiresAt,
			&up.CreatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan user permission: %w", err)
		}
		userPermissions = append(userPermissions, up)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating user permissions: %w", err)
	}

	return userPermissions, nil
}

// GetUserEffectivePermissions retrieves all effective permissions for a user (direct + group permissions)
func (r *Repository) GetUserEffectivePermissions(ctx context.Context, filters *filter.UserEffectivePermissionFilter) ([]*dao.Permission, error) {
	baseQuery := `
		SELECT DISTINCT p.id, p.name, p.display_name, p.description, p.is_system, p.created_by, p.created_at, p.updated_at
		FROM permissions p
		WHERE p.id IN (
			-- Direct user permissions
			SELECT up.permission_id 
			FROM user_permissions up 
			WHERE up.user_id = $1 
			AND (up.expires_at IS NULL OR up.expires_at >= $2)
			
			UNION
			
			-- Group permissions through user's group memberships
			SELECT gp.permission_id 
			FROM group_permissions gp
			JOIN user_groups ug ON gp.group_id = ug.group_id
			WHERE ug.user_id = $1
			AND (ug.expires_at IS NULL OR ug.expires_at >= $2)
		)
	`

	args := []interface{}{filters.UserID, time.Now().Unix()}
	argIndex := 3

	// Add search filter if provided
	if filters.Search != nil {
		baseQuery += fmt.Sprintf(" AND (p.name ILIKE $%d OR p.display_name ILIKE $%d OR p.description ILIKE $%d)", argIndex, argIndex, argIndex)
		searchTerm := "%" + *filters.Search + "%"
		args = append(args, searchTerm)
		argIndex++
	}

	// Add ordering and pagination
	baseQuery += " ORDER BY p.name"
	baseQuery += fmt.Sprintf(" LIMIT $%d OFFSET $%d", argIndex, argIndex+1)
	args = append(args, filters.Limit, filters.Offset)

	rows, err := r.connManager.Primary().QueryContext(ctx, baseQuery, args...)
	if err != nil {
		return nil, fmt.Errorf("failed to get user effective permissions: %w", err)
	}
	defer rows.Close()

	var permissions []*dao.Permission
	for rows.Next() {
		p := &dao.Permission{}
		err := rows.Scan(
			&p.ID,
			&p.Name,
			&p.DisplayName,
			&p.Description,
			&p.IsSystem,
			&p.CreatedBy,
			&p.CreatedAt,
			&p.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan permission: %w", err)
		}
		permissions = append(permissions, p)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating permissions: %w", err)
	}

	return permissions, nil
}

// IsPermissionAssignedToUser checks if a permission is directly assigned to a user
func (r *Repository) IsPermissionAssignedToUser(ctx context.Context, userID, permissionID int64) (bool, error) {
	query := `SELECT EXISTS(SELECT 1 FROM user_permissions WHERE user_id = $1 AND permission_id = $2)`

	var exists bool
	err := r.connManager.Primary().QueryRowContext(ctx, query, userID, permissionID).Scan(&exists)
	if err != nil {
		return false, fmt.Errorf("failed to check if permission is assigned to user: %w", err)
	}

	return exists, nil
}
