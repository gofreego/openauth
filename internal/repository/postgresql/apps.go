package postgresql

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
	"time"

	"github.com/gofreego/openauth/internal/models/dao"
)

// CreateApp creates a new app in the database
func (r *Repository) CreateApp(ctx context.Context, app *dao.App) (*dao.App, error) {
	query := `
		INSERT INTO apps (name, description, url, logo_url, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6)
		RETURNING id, name, description, url, logo_url, created_at, updated_at`

	row := r.connManager.Primary().QueryRowContext(ctx, query,
		app.Name, app.Description, app.URL, app.LogoURL, app.CreatedAt, app.UpdatedAt)

	var createdApp dao.App
	err := row.Scan(
		&createdApp.ID, &createdApp.Name, &createdApp.Description, &createdApp.URL,
		&createdApp.LogoURL, &createdApp.CreatedAt, &createdApp.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &createdApp, nil
}

// GetAppByID retrieves an app by ID
func (r *Repository) GetAppByID(ctx context.Context, id int64) (*dao.App, error) {
	query := `
		SELECT id, name, description, url, logo_url, created_at, updated_at
		FROM apps WHERE id = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, id)
	return r.scanApp(row)
}

// GetAppByName retrieves an app by name
func (r *Repository) GetAppByName(ctx context.Context, name string) (*dao.App, error) {
	query := `
		SELECT id, name, description, url, logo_url, created_at, updated_at
		FROM apps WHERE name = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, name)
	return r.scanApp(row)
}

// UpdateApp updates app fields
func (r *Repository) UpdateApp(ctx context.Context, id int64, updates map[string]interface{}) (*dao.App, error) {
	if len(updates) == 0 {
		return r.GetAppByID(ctx, id)
	}

	setParts := make([]string, 0, len(updates))
	args := make([]interface{}, 0, len(updates)+1)
	argIndex := 1

	for field, value := range updates {
		setParts = append(setParts, fmt.Sprintf("%s = $%d", field, argIndex))
		args = append(args, value)
		argIndex++
	}

	query := fmt.Sprintf(`
		UPDATE apps SET %s WHERE id = $%d
		RETURNING id, name, description, url, logo_url, created_at, updated_at`,
		strings.Join(setParts, ", "), argIndex)

	args = append(args, id)

	row := r.connManager.Primary().QueryRowContext(ctx, query, args...)
	return r.scanApp(row)
}

// DeleteApp deletes an app
func (r *Repository) DeleteApp(ctx context.Context, id int64) error {
	query := `DELETE FROM apps WHERE id = $1`
	_, err := r.connManager.Primary().ExecContext(ctx, query, id)
	return err
}

// ListApps retrieves apps with search, limit, and offset
func (r *Repository) ListApps(ctx context.Context, search *string, limit, offset int32) ([]*dao.App, int64, error) {
	whereConditions := []string{}
	args := []interface{}{}
	argIndex := 1

	if search != nil && *search != "" {
		whereConditions = append(whereConditions, fmt.Sprintf("(name ILIKE $%d OR description ILIKE $%d)", argIndex, argIndex+1))
		pattern := "%" + *search + "%"
		args = append(args, pattern, pattern)
		argIndex += 2
	}

	whereClause := ""
	if len(whereConditions) > 0 {
		whereClause = "WHERE " + strings.Join(whereConditions, " AND ")
	}

	// Get total count
	countQuery := fmt.Sprintf("SELECT COUNT(*) FROM apps %s", whereClause)
	var total int64
	err := r.connManager.Primary().QueryRowContext(ctx, countQuery, args...).Scan(&total)
	if err != nil {
		return nil, 0, err
	}

	// Get paginated results
	query := fmt.Sprintf(`
		SELECT id, name, description, url, logo_url, created_at, updated_at
		FROM apps %s ORDER BY name ASC LIMIT $%d OFFSET $%d`,
		whereClause, argIndex, argIndex+1)

	args = append(args, limit, offset)

	rows, err := r.connManager.Primary().QueryContext(ctx, query, args...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	apps := []*dao.App{}
	for rows.Next() {
		app, err := r.scanAppFromRows(rows)
		if err != nil {
			return nil, 0, err
		}
		apps = append(apps, app)
	}

	return apps, total, rows.Err()
}

// AssignAppsToUser synchronizes app assignments for a user in a transaction
func (r *Repository) AssignAppsToUser(ctx context.Context, userID int64, appIDs []int64, assignedBy int64) error {
	tx, err := r.connManager.Primary().BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// 1. Delete existing user app assignments
	_, err = tx.ExecContext(ctx, "DELETE FROM user_apps WHERE user_id = $1", userID)
	if err != nil {
		return err
	}

	// 2. Insert new assignments
	if len(appIDs) > 0 {
		insertQuery := `INSERT INTO user_apps (user_id, app_id, assigned_by, created_at) VALUES ($1, $2, $3, $4)`
		createdAt := time.Now().UnixMilli()
		for _, appID := range appIDs {
			_, err = tx.ExecContext(ctx, insertQuery, userID, appID, assignedBy, createdAt)
			if err != nil {
				return err
			}
		}
	}

	return tx.Commit()
}

// ListUserApps retrieves apps assigned to a specific user with pagination
func (r *Repository) ListUserApps(ctx context.Context, userID int64, limit, offset int32) ([]*dao.App, int64, error) {
	// Get total count
	countQuery := `SELECT COUNT(*) FROM user_apps WHERE user_id = $1`
	var total int64
	err := r.connManager.Primary().QueryRowContext(ctx, countQuery, userID).Scan(&total)
	if err != nil {
		return nil, 0, err
	}

	// Get paginated results
	query := `
		SELECT a.id, a.name, a.description, a.url, a.logo_url, a.created_at, a.updated_at
		FROM apps a
		JOIN user_apps ua ON a.id = ua.app_id
		WHERE ua.user_id = $1
		ORDER BY a.name ASC
		LIMIT $2 OFFSET $3`

	rows, err := r.connManager.Primary().QueryContext(ctx, query, userID, limit, offset)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	apps := []*dao.App{}
	for rows.Next() {
		app, err := r.scanAppFromRows(rows)
		if err != nil {
			return nil, 0, err
		}
		apps = append(apps, app)
	}

	return apps, total, rows.Err()
}

// Helper scanning methods

func (r *Repository) scanApp(row *sql.Row) (*dao.App, error) {
	var app dao.App
	err := row.Scan(&app.ID, &app.Name, &app.Description, &app.URL, &app.LogoURL, &app.CreatedAt, &app.UpdatedAt)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return &app, nil
}

func (r *Repository) scanAppFromRows(rows *sql.Rows) (*dao.App, error) {
	var app dao.App
	err := rows.Scan(&app.ID, &app.Name, &app.Description, &app.URL, &app.LogoURL, &app.CreatedAt, &app.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &app, nil
}
