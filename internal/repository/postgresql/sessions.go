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

// CreateSession creates a new session in the database
func (r *Repository) CreateSession(ctx context.Context, session *dao.Session) (*dao.Session, error) {
	query := `
		INSERT INTO user_sessions (uuid, user_id, user_uuid, session_token, refresh_token, 
			device_id, device_name, device_type, user_agent, ip_address, location, 
			is_active, status, expires_at, refresh_expires_at, last_activity_at, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
		RETURNING id, uuid, user_id, user_uuid, session_token, refresh_token, 
			device_id, device_name, device_type, user_agent, ip_address, location, 
			is_active, status, expires_at, refresh_expires_at, last_activity_at, created_at`

	row := r.connManager.Primary().QueryRowContext(ctx, query,
		session.UUID, session.UserID, session.UserUUID, session.SessionToken,
		session.RefreshToken, session.DeviceID, session.DeviceName, session.DeviceType,
		session.UserAgent, session.IPAddress, session.Location, session.IsActive,
		session.Status, session.ExpiresAt, session.RefreshExpiresAt, session.LastActivityAt, session.CreatedAt)

	var createdSession dao.Session
	err := row.Scan(
		&createdSession.ID, &createdSession.UUID, &createdSession.UserID, &createdSession.UserUUID,
		&createdSession.SessionToken, &createdSession.RefreshToken, &createdSession.DeviceID,
		&createdSession.DeviceName, &createdSession.DeviceType, &createdSession.UserAgent,
		&createdSession.IPAddress, &createdSession.Location, &createdSession.IsActive,
		&createdSession.Status, &createdSession.ExpiresAt, &createdSession.RefreshExpiresAt,
		&createdSession.LastActivityAt, &createdSession.CreatedAt)
	if err != nil {
		return nil, err
	}

	return &createdSession, nil
}

// GetSessionByToken retrieves a session by its session token
func (r *Repository) GetSessionByToken(ctx context.Context, sessionToken string) (*dao.Session, error) {
	query := `
		SELECT id, uuid, user_id, user_uuid, session_token, refresh_token, 
			device_id, device_name, device_type, user_agent, ip_address, location, 
			is_active, status, expires_at, refresh_expires_at, last_activity_at, created_at
		FROM user_sessions 
		WHERE session_token = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, sessionToken)
	return r.scanSession(row)
}

// GetSessionByUUID retrieves a session by its UUID
func (r *Repository) GetSessionByUUID(ctx context.Context, sessionUUID string) (*dao.Session, error) {
	query := `
		SELECT id, uuid, user_id, user_uuid, session_token, refresh_token, 
			device_id, device_name, device_type, user_agent, ip_address, location, 
			is_active, status, expires_at, refresh_expires_at, last_activity_at, created_at
		FROM user_sessions 
		WHERE uuid = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, sessionUUID)
	return r.scanSession(row)
}

// GetSessionByRefreshToken retrieves a session by its refresh token
func (r *Repository) GetSessionByRefreshToken(ctx context.Context, refreshToken string) (*dao.Session, error) {
	query := `
		SELECT id, uuid, user_id, user_uuid, session_token, refresh_token, 
			device_id, device_name, device_type, user_agent, ip_address, location, 
			is_active, status, expires_at, refresh_expires_at, last_activity_at, created_at
		FROM user_sessions 
		WHERE refresh_token = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, refreshToken)
	return r.scanSession(row)
}

// UpdateSession updates a session by its UUID
func (r *Repository) UpdateSession(ctx context.Context, sessionUUID string, updates map[string]interface{}) (*dao.Session, error) {
	if len(updates) == 0 {
		return r.GetSessionByUUID(ctx, sessionUUID)
	}

	setParts := make([]string, 0, len(updates))
	args := make([]interface{}, 0, len(updates)+1)
	argIndex := 1

	for field, value := range updates {
		setParts = append(setParts, fmt.Sprintf("%s = $%d", field, argIndex))
		args = append(args, value)
		argIndex++
	}

	// Add UUID as the last parameter
	args = append(args, sessionUUID)

	query := fmt.Sprintf(`
		UPDATE user_sessions 
		SET %s 
		WHERE uuid = $%d
		RETURNING id, uuid, user_id, user_uuid, session_token, refresh_token, 
			device_id, device_name, device_type, user_agent, ip_address, location, 
			is_active, status, expires_at, refresh_expires_at, last_activity_at, created_at`,
		strings.Join(setParts, ", "), argIndex)

	row := r.connManager.Primary().QueryRowContext(ctx, query, args...)
	return r.scanSession(row)
}

// DeleteSession deletes a session by its UUID
func (r *Repository) DeleteSession(ctx context.Context, sessionUUID string) error {
	query := `DELETE FROM user_sessions WHERE uuid = $1`
	result, err := r.connManager.Primary().ExecContext(ctx, query, sessionUUID)
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

// DeleteUserSessions deletes all sessions for a user
func (r *Repository) DeleteUserSessions(ctx context.Context, userUUID string) error {
	query := `DELETE FROM user_sessions WHERE user_uuid = $1`
	_, err := r.connManager.Primary().ExecContext(ctx, query, userUUID)
	return err
}

// ListUserSessions retrieves sessions for a user with pagination
func (r *Repository) ListUserSessions(ctx context.Context, filters *filter.UserSessionsFilter) ([]*dao.Session, error) {
	// Build the base query
	listQuery := `
		SELECT id, uuid, user_id, user_uuid, session_token, refresh_token, 
			device_id, device_name, device_type, user_agent, ip_address, location, 
			is_active, status, expires_at, refresh_expires_at, last_activity_at, created_at
		FROM user_sessions 
		WHERE user_uuid = $1`

	args := []interface{}{filters.UserUUID}
	argIndex := 2

	// Add active filter if requested
	if filters.ActiveOnly {
		listQuery += " AND is_active = $2"
		args = append(args, true)
		argIndex++
	}

	// Add ordering and pagination to list query
	listQuery += fmt.Sprintf(" ORDER BY last_activity_at DESC LIMIT $%d OFFSET $%d", argIndex, argIndex+1)
	args = append(args, filters.Limit, filters.Offset)

	// Execute list query
	rows, err := r.connManager.Primary().QueryContext(ctx, listQuery, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var sessions []*dao.Session
	for rows.Next() {
		session, err := r.scanSessionFromRows(rows)
		if err != nil {
			return nil, err
		}
		sessions = append(sessions, session)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return sessions, nil
}

// UpdateLastActivity updates the last activity timestamp for a session
func (r *Repository) UpdateLastActivity(ctx context.Context, sessionUUID string) error {
	query := `UPDATE user_sessions SET last_activity_at = $1 WHERE uuid = $2`
	_, err := r.connManager.Primary().ExecContext(ctx, query, time.Now().Unix(), sessionUUID)
	return err
}

// Helper function to scan a session from a single row
func (r *Repository) scanSession(row *sql.Row) (*dao.Session, error) {
	var session dao.Session
	err := row.Scan(
		&session.ID, &session.UUID, &session.UserID, &session.UserUUID,
		&session.SessionToken, &session.RefreshToken, &session.DeviceID,
		&session.DeviceName, &session.DeviceType, &session.UserAgent,
		&session.IPAddress, &session.Location, &session.IsActive,
		&session.Status, &session.ExpiresAt, &session.RefreshExpiresAt,
		&session.LastActivityAt, &session.CreatedAt)

	if err != nil {
		return nil, err
	}

	return &session, nil
}

// Helper function to scan a session from sql.Rows
func (r *Repository) scanSessionFromRows(rows *sql.Rows) (*dao.Session, error) {
	var session dao.Session
	err := rows.Scan(
		&session.ID, &session.UUID, &session.UserID, &session.UserUUID,
		&session.SessionToken, &session.RefreshToken, &session.DeviceID,
		&session.DeviceName, &session.DeviceType, &session.UserAgent,
		&session.IPAddress, &session.Location, &session.IsActive,
		&session.Status, &session.ExpiresAt, &session.RefreshExpiresAt,
		&session.LastActivityAt, &session.CreatedAt)

	if err != nil {
		return nil, err
	}

	return &session, nil
}
