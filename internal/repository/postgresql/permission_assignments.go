package postgresql

import (
	"context"
	"fmt"
	"time"

	"github.com/gofreego/openauth/internal/models/dao"
)

// AssignPermissionToGroup assigns a permission to a group
func (r *Repository) AssignPermissionToGroup(ctx context.Context, groupID, permissionID, grantedBy int64) error {
	// Check if assignment already exists
	exists, err := r.IsPermissionAssignedToGroup(ctx, groupID, permissionID)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("permission %d is already assigned to group %d", permissionID, groupID)
	}

	// Validate that group and permission exist
	group, err := r.GetGroupByID(ctx, groupID)
	if err != nil {
		return fmt.Errorf("failed to get group: %w", err)
	}
	if group == nil {
		return fmt.Errorf("group with ID %d not found", groupID)
	}

	permission, err := r.GetPermissionByID(ctx, permissionID)
	if err != nil {
		return fmt.Errorf("failed to get permission: %w", err)
	}
	if permission == nil {
		return fmt.Errorf("permission with ID %d not found", permissionID)
	}

	query := `
		INSERT INTO group_permissions (group_id, permission_id, granted_by, created_at)
		VALUES ($1, $2, $3, $4)
		`

	now := time.Now().Unix()

	result, err := r.connManager.Primary().ExecContext(ctx, query, groupID, permissionID, grantedBy, now)
	if err != nil {
		return fmt.Errorf("failed to assign permission to group: %w", err)
	}

	if rows, err := result.RowsAffected(); err != nil {
		return fmt.Errorf("failed to assign permission to group: %w", err)
	} else if rows == 0 {
		return fmt.Errorf("failed to assign permission to group: no rows affected")
	}
	return nil
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
func (r *Repository) ListGroupPermissions(ctx context.Context, groupId int64) ([]*dao.EffectivePermission, error) {
	baseQuery := `
		SELECT p.id, p.name, p.display_name, p.description, p.is_system, "group", gp.expires_at, gp.granted_by, gp.created_at
		FROM group_permissions gp
		JOIN permissions p ON gp.permission_id = p.id
		WHERE gp.group_id = $1
	`
	baseQuery += " ORDER BY gp.created_at DESC"

	rows, err := r.connManager.Primary().QueryContext(ctx, baseQuery, groupId)
	if err != nil {
		return nil, fmt.Errorf("failed to list group permissions: %w", err)
	}
	defer rows.Close()

	var groupPermissions []*dao.EffectivePermission
	for rows.Next() {
		gp := &dao.EffectivePermission{}
		err := rows.Scan(&gp.GroupId, &gp.GroupName)
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
func (r *Repository) AssignPermissionToUser(ctx context.Context, userID, permissionID, grantedBy int64, expiresAt *int64) error {
	// Check if assignment already exists
	exists, err := r.IsPermissionAssignedToUser(ctx, userID, permissionID)
	if err != nil {
		return fmt.Errorf("failed to check if permission is assigned to user: %w", err)
	}
	if exists {
		return fmt.Errorf("permission %d is already assigned to user %d", permissionID, userID)
	}

	// Validate that user and permission exist
	user, err := r.GetUserByID(ctx, userID)
	if err != nil {
		return fmt.Errorf("failed to get user: %w", err)
	}
	if user == nil {
		return fmt.Errorf("user with ID %d not found", userID)
	}

	permission, err := r.GetPermissionByID(ctx, permissionID)
	if err != nil {
		return fmt.Errorf("failed to get permission: %w", err)
	}
	if permission == nil {
		return fmt.Errorf("permission with ID %d not found", permissionID)
	}

	query := `
		INSERT INTO user_permissions (user_id, permission_id, granted_by, expires_at, created_at)
		VALUES ($1, $2, $3, $4, $5)
	`

	now := time.Now().Unix()

	result, err := r.connManager.Primary().ExecContext(ctx, query, userID, permissionID, grantedBy, expiresAt, now)
	if err != nil {
		return fmt.Errorf("failed to assign permission to user: %w", err)
	}

	if rows, err := result.RowsAffected(); err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	} else if rows == 0 {
		return fmt.Errorf("permission is not assigned, no rows affected")
	}
	return nil
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
func (r *Repository) ListUserPermissions(ctx context.Context, userId int64) ([]*dao.EffectivePermission, error) {
	baseQuery := `
		SELECT up.id, up.user_id, up.permission_id, up.granted_by, up.expires_at, up.created_at
		FROM user_permissions up
		JOIN permissions p ON up.permission_id = p.id
		WHERE up.user_id = $1
	`

	baseQuery += " ORDER BY up.created_at DESC"

	rows, err := r.connManager.Primary().QueryContext(ctx, baseQuery, userId)
	if err != nil {
		return nil, fmt.Errorf("failed to list user permissions: %w", err)
	}
	defer rows.Close()

	var userPermissions []*dao.EffectivePermission
	for rows.Next() {
		p := &dao.EffectivePermission{}
		err := rows.Scan(&p.PermissionId, &p.PermissionName, &p.PermissionDisplayName, &p.PermissionDescription, &p.GrantedBy, &p.GrantedAt)
		if err != nil {
			return nil, fmt.Errorf("failed to scan user permission: %w", err)
		}
		userPermissions = append(userPermissions, p)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating user permissions: %w", err)
	}

	return userPermissions, nil
}

// GetUserEffectivePermissions retrieves all effective permissions for a user (direct + group permissions)
func (r *Repository) GetUserEffectivePermissions(ctx context.Context, userId int64) ([]*dao.EffectivePermission, error) {
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
	rows, err := r.connManager.Primary().QueryContext(ctx, baseQuery, userId, time.Now().UnixMilli())
	if err != nil {
		return nil, fmt.Errorf("failed to get user effective permissions: %w", err)
	}
	defer rows.Close()

	var permissions []*dao.EffectivePermission
	for rows.Next() {
		p := &dao.EffectivePermission{}
		err := rows.Scan(
			&p.PermissionId,
			&p.PermissionName,
			&p.PermissionDisplayName,
			&p.PermissionDescription,
			&p.GrantedBy,
			&p.GrantedAt,
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

// GetUserEffectivePermissionNames implements service.Repository.
func (r *Repository) GetUserEffectivePermissionNames(ctx context.Context, userId int64) ([]string, error) {
	panic("unimplemented")
}
