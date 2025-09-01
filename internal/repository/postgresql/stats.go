package postgresql

import (
	"context"
	"fmt"
)

// GetTotalUsers returns the total number of users in the system
func (r *Repository) GetTotalUsers(ctx context.Context) (int64, error) {
	query := "SELECT COUNT(*) FROM users"

	var count int64
	err := r.connManager.Primary().QueryRowContext(ctx, query).Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("failed to get total users count: %w", err)
	}

	return count, nil
}

// GetTotalPermissions returns the total number of permissions in the system
func (r *Repository) GetTotalPermissions(ctx context.Context) (int64, error) {
	query := "SELECT COUNT(*) FROM permissions"

	var count int64
	err := r.connManager.Primary().QueryRowContext(ctx, query).Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("failed to get total permissions count: %w", err)
	}

	return count, nil
}

// GetTotalGroups returns the total number of groups in the system
func (r *Repository) GetTotalGroups(ctx context.Context) (int64, error) {
	query := "SELECT COUNT(*) FROM groups"

	var count int64
	err := r.connManager.Primary().QueryRowContext(ctx, query).Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("failed to get total groups count: %w", err)
	}

	return count, nil
}

// GetActiveUsers returns the number of users with active sessions
func (r *Repository) GetActiveUsers(ctx context.Context) (int64, error) {
	query := `
		SELECT COUNT(DISTINCT s.user_id) 
		FROM user_sessions s 
		WHERE s.expires_at > EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) * 1000
		AND s.is_active = true
		AND s.status = 'active'
	`

	var count int64
	err := r.connManager.Primary().QueryRowContext(ctx, query).Scan(&count)
	if err != nil {
		return 0, fmt.Errorf("failed to get active users count: %w", err)
	}

	return count, nil
}
