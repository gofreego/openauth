package postgresql

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
	"time"

	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
)

// CreateGroup creates a new group in the database
func (r *Repository) CreateGroup(ctx context.Context, group *dao.Group) (*dao.Group, error) {
	query := `
		INSERT INTO groups (name, display_name, description, is_system, is_default, created_by, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
		RETURNING id`

	err := r.connManager.Primary().QueryRowContext(ctx, query,
		group.Name, group.DisplayName, group.Description,
		group.IsSystem, group.IsDefault, group.CreatedBy, group.CreatedAt, group.UpdatedAt,
	).Scan(&group.ID)

	if err != nil {
		return nil, fmt.Errorf("failed to create group: %w", err)
	}

	return group, nil
}

// GetGroupByID retrieves a group by its ID
func (r *Repository) GetGroupByID(ctx context.Context, id int64) (*dao.Group, error) {
	query := `
		SELECT id, name, display_name, description, is_system, is_default, created_by, created_at, updated_at
		FROM groups
		WHERE id = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, id)
	return r.scanGroup(row)
}

// GetGroupByUUID retrieves a group by its UUID
func (r *Repository) GetGroupByUUID(ctx context.Context, uuid string) (*dao.Group, error) {
	query := `
		SELECT id, name, display_name, description, is_system, is_default, created_by, created_at, updated_at
		FROM groups
		WHERE uuid = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, uuid)
	return r.scanGroup(row)
}

// GetGroupByName retrieves a group by its name
func (r *Repository) GetGroupByName(ctx context.Context, name string) (*dao.Group, error) {
	query := `
		SELECT id, name, display_name, description, is_system, is_default, created_by, created_at, updated_at
		FROM groups
		WHERE name = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, name)
	return r.scanGroup(row)
}

// ListGroups retrieves groups with filtering and pagination
func (r *Repository) ListGroups(ctx context.Context, filters *filter.GroupFilter) ([]*dao.Group, error) {
	// Build the WHERE clause
	var conditions []string
	var args []interface{}
	argIndex := 1

	if filters.HasSearch() {
		conditions = append(conditions, fmt.Sprintf("(name ILIKE $%d OR display_name ILIKE $%d OR description ILIKE $%d)", argIndex, argIndex+1, argIndex+2))
		searchPattern := "%" + *filters.Search + "%"
		args = append(args, searchPattern, searchPattern, searchPattern)
		argIndex += 3
	}

	if filters.HasIsSystem() {
		conditions = append(conditions, fmt.Sprintf("is_system = $%d", argIndex))
		args = append(args, *filters.IsSystem)
		argIndex++
	}

	if filters.HasIsDefault() {
		conditions = append(conditions, fmt.Sprintf("is_default = $%d", argIndex))
		args = append(args, *filters.IsDefault)
		argIndex++
	}

	whereClause := ""
	if len(conditions) > 0 {
		whereClause = "WHERE " + strings.Join(conditions, " AND ")
	}

	// Get groups with pagination
	query := fmt.Sprintf(`
		SELECT id, name, display_name, description, is_system, is_default, created_by, created_at, updated_at
		FROM groups
		%s
		ORDER BY created_at DESC
		LIMIT $%d OFFSET $%d`, whereClause, argIndex, argIndex+1)

	args = append(args, filters.Limit, filters.Offset)

	rows, err := r.connManager.Primary().QueryContext(ctx, query, args...)
	if err != nil {
		return nil, fmt.Errorf("failed to list groups: %w", err)
	}
	defer rows.Close()

	var groups []*dao.Group
	for rows.Next() {
		group, err := r.scanGroupFromRows(rows)
		if err != nil {
			return nil, fmt.Errorf("failed to scan group: %w", err)
		}
		groups = append(groups, group)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("rows iteration error: %w", err)
	}

	return groups, nil
}

// UpdateGroup updates a group in the database
func (r *Repository) UpdateGroup(ctx context.Context, id int64, updates map[string]interface{}) (*dao.Group, error) {
	if len(updates) == 0 {
		return r.GetGroupByID(ctx, id)
	}

	// Build SET clause
	var setParts []string
	var args []interface{}
	argIndex := 1

	for field, value := range updates {
		setParts = append(setParts, fmt.Sprintf("%s = $%d", field, argIndex))
		args = append(args, value)
		argIndex++
	}

	query := fmt.Sprintf(`
		UPDATE groups
		SET %s
		WHERE id = $%d
		RETURNING id, name, display_name, description, is_system, is_default, created_by, created_at, updated_at`,
		strings.Join(setParts, ", "), argIndex)

	args = append(args, id)

	row := r.connManager.Primary().QueryRowContext(ctx, query, args...)
	return r.scanGroup(row)
}

// DeleteGroup deletes a group from the database
func (r *Repository) DeleteGroup(ctx context.Context, id int64) error {
	// First, remove all user assignments from this group
	_, err := r.connManager.Primary().ExecContext(ctx, "DELETE FROM user_groups WHERE group_id = $1", id)
	if err != nil {
		return fmt.Errorf("failed to remove user assignments: %w", err)
	}

	// Then, remove all permission assignments from this group
	_, err = r.connManager.Primary().ExecContext(ctx, "DELETE FROM group_permissions WHERE group_id = $1", id)
	if err != nil {
		return fmt.Errorf("failed to remove permission assignments: %w", err)
	}

	// Finally, delete the group
	result, err := r.connManager.Primary().ExecContext(ctx, "DELETE FROM groups WHERE id = $1", id)
	if err != nil {
		return fmt.Errorf("failed to delete group: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to check affected rows: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("group not found")
	}

	return nil
}

// CheckGroupNameExists checks if a group name already exists
func (r *Repository) CheckGroupNameExists(ctx context.Context, name string) (bool, error) {
	query := "SELECT EXISTS(SELECT 1 FROM groups WHERE name = $1)"
	var exists bool
	err := r.connManager.Primary().QueryRowContext(ctx, query, name).Scan(&exists)
	if err != nil {
		return false, fmt.Errorf("failed to check group name existence: %w", err)
	}
	return exists, nil
}

// AssignUserToGroup assigns a user to a group
func (r *Repository) AssignUserToGroup(ctx context.Context, userID, groupID int64, assignedBy int64, expiresAt *int64) error {
	query := `
		INSERT INTO user_groups (user_id, group_id, assigned_by, expires_at, created_at)
		VALUES ($1, $2, $3, $4, $5)`

	_, err := r.connManager.Primary().ExecContext(ctx, query, userID, groupID, assignedBy, expiresAt, time.Now().Unix())
	if err != nil {
		return fmt.Errorf("failed to assign user to group: %w", err)
	}

	return nil
}

// RemoveUserFromGroup removes a user from a group
func (r *Repository) RemoveUserFromGroup(ctx context.Context, userID, groupID int64) error {
	result, err := r.connManager.Primary().ExecContext(ctx, "DELETE FROM user_groups WHERE user_id = $1 AND group_id = $2", userID, groupID)
	if err != nil {
		return fmt.Errorf("failed to remove user from group: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to check affected rows: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("user group assignment not found")
	}

	return nil
}

// ListGroupUsers retrieves all users in a specific group
func (r *Repository) ListGroupUsers(ctx context.Context, filters *filter.GroupUsersFilter) ([]*dao.User, error) {
	// Get users with pagination
	query := `
		SELECT u.id, u.uuid, u.username, u.email, u.phone, u.name, u.avatar_url,
			   u.password_hash, u.email_verified, u.phone_verified, u.is_active, u.is_locked,
			   u.failed_login_attempts, u.last_login_at, u.password_changed_at, u.created_at, u.updated_at
		FROM users u
		INNER JOIN user_groups ug ON u.id = ug.user_id
		WHERE ug.group_id = $1
		ORDER BY u.created_at DESC
		LIMIT $2 OFFSET $3`

	rows, err := r.connManager.Primary().QueryContext(ctx, query, filters.GroupID, filters.Limit, filters.Offset)
	if err != nil {
		return nil, fmt.Errorf("failed to list group users: %w", err)
	}
	defer rows.Close()

	var users []*dao.User
	for rows.Next() {
		user, err := r.scanUserFromRows(rows)
		if err != nil {
			return nil, fmt.Errorf("failed to scan user: %w", err)
		}
		users = append(users, user)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("rows iteration error: %w", err)
	}

	return users, nil
}

// ListUserGroups retrieves all groups for a specific user
func (r *Repository) ListUserGroups(ctx context.Context, filters *filter.UserGroupsFilter) ([]*dao.Group, error) {
	// Get groups with pagination
	query := `
		SELECT g.id, g.name, g.display_name, g.description, g.is_system, g.is_default, g.created_at, g.updated_at
		FROM groups g
		INNER JOIN user_groups ug ON g.id = ug.group_id
		WHERE ug.user_id = $1
		ORDER BY g.created_at DESC
		LIMIT $2 OFFSET $3`

	rows, err := r.connManager.Primary().QueryContext(ctx, query, filters.UserID, filters.Limit, filters.Offset)
	if err != nil {
		return nil, fmt.Errorf("failed to list user groups: %w", err)
	}
	defer rows.Close()

	var groups []*dao.Group
	for rows.Next() {
		group, err := r.scanGroupFromRows(rows)
		if err != nil {
			return nil, fmt.Errorf("failed to scan group: %w", err)
		}
		groups = append(groups, group)
	}

	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("rows iteration error: %w", err)
	}

	return groups, nil
}

// IsUserInGroup checks if a user is in a specific group
func (r *Repository) IsUserInGroup(ctx context.Context, userID, groupID int64) (bool, error) {
	query := "SELECT EXISTS(SELECT 1 FROM user_groups WHERE user_id = $1 AND group_id = $2)"
	var exists bool
	err := r.connManager.Primary().QueryRowContext(ctx, query, userID, groupID).Scan(&exists)
	if err != nil {
		return false, fmt.Errorf("failed to check group membership: %w", err)
	}
	return exists, nil
}

// Helper methods for scanning

// scanGroup scans a single group from a sql.Row
func (r *Repository) scanGroup(row *sql.Row) (*dao.Group, error) {
	var group dao.Group
	err := row.Scan(
		&group.ID, &group.Name, &group.DisplayName,
		&group.Description, &group.IsSystem, &group.IsDefault,
		&group.CreatedBy, &group.CreatedAt, &group.UpdatedAt)

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("group not found")
		}
		return nil, err
	}

	return &group, nil
}

// scanGroupFromRows scans a single group from sql.Rows
func (r *Repository) scanGroupFromRows(rows *sql.Rows) (*dao.Group, error) {
	var group dao.Group
	err := rows.Scan(
		&group.ID, &group.Name, &group.DisplayName,
		&group.Description, &group.IsSystem, &group.IsDefault, &group.CreatedBy,
		&group.CreatedAt, &group.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &group, nil
}
