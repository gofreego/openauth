package postgresql

import (
	"context"
	"database/sql"
	"time"

	"github.com/gofreego/openauth/internal/models/dao"
)

// RevokeSession marks a session as revoked (soft delete approach 1)
func (r *Repository) RevokeSession(ctx context.Context, sessionUUID string) error {
	query := `UPDATE user_sessions SET is_active = false, status = 'revoked', revoked_at = $1 WHERE uuid = $2`
	revokedAt := time.Now().Unix()
	result, err := r.connManager.Primary().ExecContext(ctx, query, revokedAt, sessionUUID)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return sql.ErrNoRows
	}

	return nil
}

// RevokeUserSessions marks all user sessions as revoked
func (r *Repository) RevokeUserSessions(ctx context.Context, userUUID string) error {
	query := `UPDATE user_sessions SET is_active = false, status = 'revoked', revoked_at = $1 WHERE user_uuid = $2 AND is_active = true`
	revokedAt := time.Now().Unix()
	_, err := r.connManager.Primary().ExecContext(ctx, query, revokedAt, userUUID)
	return err
}

// LogoutSession marks a session as logged out
func (r *Repository) LogoutSession(ctx context.Context, sessionUUID string) error {
	query := `UPDATE user_sessions SET is_active = false, status = 'logged_out', revoked_at = $1 WHERE uuid = $2`
	loggedOutAt := time.Now().Unix()
	result, err := r.connManager.Primary().ExecContext(ctx, query, loggedOutAt, sessionUUID)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return sql.ErrNoRows
	}

	return nil
}

// CleanupOldSessions deletes old inactive sessions (cleanup strategy approach 2)
func (r *Repository) CleanupOldSessions(ctx context.Context, retentionDays int) (int64, error) {
	cutoffTime := time.Now().AddDate(0, 0, -retentionDays).Unix()
	query := `DELETE FROM user_sessions WHERE is_active = false AND last_activity_at < $1`
	result, err := r.connManager.Primary().ExecContext(ctx, query, cutoffTime)
	if err != nil {
		return 0, err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return 0, err
	}

	return rowsAffected, nil
}

// ArchiveOldSessions moves old sessions to archive table (archive pattern approach 3)
func (r *Repository) ArchiveOldSessions(ctx context.Context, retentionDays int) (int64, error) {
	cutoffTime := time.Now().AddDate(0, 0, -retentionDays).Unix()
	archivedAt := time.Now().Unix()

	// Start transaction
	tx, err := r.connManager.Primary().BeginTx(ctx, nil)
	if err != nil {
		return 0, err
	}
	defer tx.Rollback()

	// Move to archive table
	archiveQuery := `
		INSERT INTO user_sessions_archive 
		(original_id, uuid, user_id, user_uuid, session_token, refresh_token, 
		 device_id, device_name, device_type, user_agent, ip_address, location, 
		 lat, lon, is_active, status, expires_at, refresh_expires_at, 
		 last_activity_at, revoked_at, created_at, archived_at)
		SELECT id, uuid, user_id, user_uuid, session_token, refresh_token, 
		       device_id, device_name, device_type, user_agent, ip_address, location, 
		       lat, lon, is_active, 'archived', expires_at, refresh_expires_at, 
		       last_activity_at, revoked_at, created_at, $1
		FROM user_sessions 
		WHERE is_active = false AND last_activity_at < $2`

	result, err := tx.ExecContext(ctx, archiveQuery, archivedAt, cutoffTime)
	if err != nil {
		return 0, err
	}

	rowsArchived, err := result.RowsAffected()
	if err != nil {
		return 0, err
	}

	// Delete from main table
	deleteQuery := `DELETE FROM user_sessions WHERE is_active = false AND last_activity_at < $1`
	_, err = tx.ExecContext(ctx, deleteQuery, cutoffTime)
	if err != nil {
		return 0, err
	}

	// Commit transaction
	if err = tx.Commit(); err != nil {
		return 0, err
	}

	return rowsArchived, nil
}

// GetArchivedSessions retrieves archived sessions for a user
func (r *Repository) GetArchivedSessions(ctx context.Context, userUUID string, limit, offset int) ([]*dao.SessionArchive, error) {
	query := `
		SELECT id, original_id, uuid, user_id, user_uuid, session_token, refresh_token, 
			   device_id, device_name, device_type, user_agent, ip_address, location, 
			   lat, lon, is_active, status, expires_at, refresh_expires_at, 
			   last_activity_at, revoked_at, created_at, archived_at
		FROM user_sessions_archive 
		WHERE user_uuid = $1 
		ORDER BY archived_at DESC 
		LIMIT $2 OFFSET $3`

	rows, err := r.connManager.Replica().QueryContext(ctx, query, userUUID, limit, offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var archivedSessions []*dao.SessionArchive
	for rows.Next() {
		var session dao.SessionArchive
		err := rows.Scan(
			&session.ID, &session.OriginalID, &session.UUID, &session.UserID, &session.UserUUID,
			&session.SessionToken, &session.RefreshToken, &session.DeviceID,
			&session.DeviceName, &session.DeviceType, &session.UserAgent,
			&session.IPAddress, &session.Location, &session.Lat, &session.Lon,
			&session.IsActive, &session.Status, &session.ExpiresAt, &session.RefreshExpiresAt,
			&session.LastActivityAt, &session.RevokedAt, &session.CreatedAt, &session.ArchivedAt)

		if err != nil {
			return nil, err
		}

		archivedSessions = append(archivedSessions, &session)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return archivedSessions, nil
}

// GetActiveSessionsCount returns count of active sessions for a user
func (r *Repository) GetActiveSessionsCount(ctx context.Context, userUUID string) (int32, error) {
	query := `SELECT COUNT(*) FROM user_sessions WHERE user_uuid = $1 AND status = 'active'`
	var count int32
	err := r.connManager.Replica().QueryRowContext(ctx, query, userUUID).Scan(&count)
	return count, err
}
