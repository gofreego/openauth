package postgresql

import (
	"context"

	"github.com/google/uuid"
)

// ListUserProfileUUIDs implements service.Repository.
func (r *Repository) ListUserProfileUUIDs(ctx context.Context, userID int64) ([]uuid.UUID, error) {
	panic("unimplemented")
}
