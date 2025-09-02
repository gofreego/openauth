package postgresql

import (
	"context"
	"fmt"

	"github.com/google/uuid"
)

// ListUserProfileUUIDs implements service.Repository.
func (r *Repository) ListUserProfileUUIDs(ctx context.Context, userID int64) ([]uuid.UUID, error) {
	query := `SELECT uuid FROM user_profiles WHERE user_id = $1 ORDER BY created_at ASC`

	rows, err := r.connManager.Primary().QueryContext(ctx, query, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to list user profile UUIDs: %w", err)
	}
	defer rows.Close()

	var profileUUIDs []uuid.UUID
	for rows.Next() {
		var profileUUID uuid.UUID
		err := rows.Scan(&profileUUID)
		if err != nil {
			return nil, fmt.Errorf("failed to scan profile UUID: %w", err)
		}
		profileUUIDs = append(profileUUIDs, profileUUID)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating profile UUIDs: %w", err)
	}

	return profileUUIDs, nil
}
