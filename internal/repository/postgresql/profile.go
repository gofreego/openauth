package postgresql

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
	"time"

	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/google/uuid"
)

// CreateUserProfile creates a new user profile in the database
func (r *Repository) CreateUserProfile(ctx context.Context, profile *dao.Profile) (*dao.Profile, error) {
	// Debug: Log the metadata being passed to PostgreSQL
	fmt.Printf("Repository: Creating profile with metadata: %s\n", string(profile.Metadata))

	query := `
		INSERT INTO user_profiles (uuid, user_id, profile_name, first_name, last_name, display_name, bio, 
			avatar_url, date_of_birth, gender, timezone, locale, country, city, address, 
			postal_code, website_url, metadata, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20)
		RETURNING id, uuid, profile_name, user_id, first_name, last_name, display_name, bio, avatar_url,
			date_of_birth, gender, timezone, locale, country, city, address, postal_code,
			website_url, metadata, created_at, updated_at`

	// Handle metadata properly for JSONB column
	var metadataParam interface{}
	if len(profile.Metadata) == 0 {
		metadataParam = nil
	} else {
		metadataParam = string(profile.Metadata)
	}

	row := r.connManager.Primary().QueryRowContext(ctx, query,
		profile.UUID, profile.UserID, profile.ProfileName, profile.FirstName, profile.LastName,
		profile.DisplayName, profile.Bio, profile.AvatarURL, profile.DateOfBirth,
		profile.Gender, profile.Timezone, profile.Locale, profile.Country,
		profile.City, profile.Address, profile.PostalCode, profile.WebsiteURL,
		metadataParam, profile.CreatedAt, profile.UpdatedAt)

	var createdProfile dao.Profile
	var metadataStr sql.NullString
	err := row.Scan(
		&createdProfile.ID, &createdProfile.UUID, &createdProfile.ProfileName, &createdProfile.UserID,
		&createdProfile.FirstName, &createdProfile.LastName, &createdProfile.DisplayName,
		&createdProfile.Bio, &createdProfile.AvatarURL, &createdProfile.DateOfBirth,
		&createdProfile.Gender, &createdProfile.Timezone, &createdProfile.Locale,
		&createdProfile.Country, &createdProfile.City, &createdProfile.Address,
		&createdProfile.PostalCode, &createdProfile.WebsiteURL, &metadataStr,
		&createdProfile.CreatedAt, &createdProfile.UpdatedAt)
	if err != nil {
		return nil, err
	}

	// Convert metadata back to []byte
	if metadataStr.Valid {
		createdProfile.Metadata = []byte(metadataStr.String)
	} else {
		createdProfile.Metadata = nil
	}

	return &createdProfile, nil
}

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

// ListUserProfiles retrieves all profiles for a specific user with pagination
func (r *Repository) ListUserProfiles(ctx context.Context, filters *filter.UserProfilesFilter) ([]*dao.Profile, error) {
	// Get the profiles with pagination
	query := `
		SELECT p.id, p.uuid, p.user_id, p.profile_name, p.first_name, p.last_name, p.display_name, 
			p.bio, p.avatar_url, p.date_of_birth, p.gender, p.timezone, p.locale, 
			p.country, p.city, p.address, p.postal_code, p.website_url, p.metadata, 
			p.created_at, p.updated_at
		FROM user_profiles p 
		JOIN users u ON p.user_id = u.id 
		WHERE u.uuid = $1 
		ORDER BY p.created_at DESC 
		LIMIT $2 OFFSET $3`

	rows, err := r.connManager.Primary().QueryContext(ctx, query, filters.UserUUID, filters.Limit, filters.Offset)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var profiles []*dao.Profile
	for rows.Next() {
		profile, err := r.scanProfileFromRows(rows)
		if err != nil {
			return nil, err
		}
		profiles = append(profiles, profile)
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return profiles, nil
}

// GetProfileByUUID retrieves a profile by its UUID
func (r *Repository) GetProfileByUUID(ctx context.Context, uuid string) (*dao.Profile, error) {
	query := `
		SELECT id, uuid, user_id, profile_name, first_name, last_name, display_name, bio, avatar_url,
			date_of_birth, gender, timezone, locale, country, city, address, postal_code,
			website_url, metadata, created_at, updated_at
		FROM user_profiles 
		WHERE uuid = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, uuid)
	return r.scanProfile(row)
}

// UpdateProfileByUUID updates a profile by its UUID
func (r *Repository) UpdateProfileByUUID(ctx context.Context, uuid string, updates map[string]interface{}) (*dao.Profile, error) {
	if len(updates) == 0 {
		return r.GetProfileByUUID(ctx, uuid)
	}

	setParts := make([]string, 0, len(updates))
	args := make([]interface{}, 0, len(updates)+1)
	argIndex := 1

	for field, value := range updates {
		setParts = append(setParts, fmt.Sprintf("%s = $%d", field, argIndex))

		// Handle metadata field specially for JSONB
		if field == "metadata" {
			if value == nil {
				args = append(args, nil)
			} else if metadataBytes, ok := value.([]byte); ok {
				if len(metadataBytes) == 0 {
					args = append(args, nil)
				} else {
					args = append(args, string(metadataBytes))
				}
			} else {
				args = append(args, value)
			}
		} else {
			args = append(args, value)
		}
		argIndex++
	}

	// Add updated_at timestamp
	setParts = append(setParts, fmt.Sprintf("updated_at = $%d", argIndex))
	args = append(args, time.Now().Unix())
	argIndex++

	// Add UUID as the last parameter
	args = append(args, uuid)

	query := fmt.Sprintf(`
		UPDATE user_profiles 
		SET %s 
		WHERE uuid = $%d
		RETURNING id, uuid, user_id, profile_name, first_name, last_name, display_name, bio, avatar_url,
			date_of_birth, gender, timezone, locale, country, city, address, postal_code,
			website_url, metadata, created_at, updated_at`,
		strings.Join(setParts, ", "), argIndex)

	row := r.connManager.Primary().QueryRowContext(ctx, query, args...)
	return r.scanProfile(row)
}

// CountUserProfiles returns the total number of profiles for a user
func (r *Repository) CountUserProfiles(ctx context.Context, userUUID string) (int32, error) {
	query := `
		SELECT COUNT(*) 
		FROM user_profiles p 
		JOIN users u ON p.user_id = u.id 
		WHERE u.uuid = $1`

	var count int32
	err := r.connManager.Primary().QueryRowContext(ctx, query, userUUID).Scan(&count)
	return count, err
}

// DeleteProfileByUUID deletes a profile by its UUID
func (r *Repository) DeleteProfileByUUID(ctx context.Context, uuid string) error {
	query := `DELETE FROM user_profiles WHERE uuid = $1`
	result, err := r.connManager.Primary().ExecContext(ctx, query, uuid)
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

// scanProfileFromRows scans a profile from sql.Rows
func (r *Repository) scanProfileFromRows(rows *sql.Rows) (*dao.Profile, error) {
	var profile dao.Profile
	var metadataStr sql.NullString
	err := rows.Scan(
		&profile.ID, &profile.UUID, &profile.UserID, &profile.ProfileName, &profile.FirstName,
		&profile.LastName, &profile.DisplayName, &profile.Bio, &profile.AvatarURL,
		&profile.DateOfBirth, &profile.Gender, &profile.Timezone, &profile.Locale,
		&profile.Country, &profile.City, &profile.Address, &profile.PostalCode,
		&profile.WebsiteURL, &metadataStr, &profile.CreatedAt, &profile.UpdatedAt)

	if err != nil {
		return nil, err
	}

	// Convert metadata back to []byte
	if metadataStr.Valid {
		profile.Metadata = []byte(metadataStr.String)
	} else {
		profile.Metadata = nil
	}

	return &profile, nil
}

func (r *Repository) scanProfile(row *sql.Row) (*dao.Profile, error) {
	var profile dao.Profile
	var metadataStr sql.NullString
	err := row.Scan(
		&profile.ID, &profile.UUID, &profile.UserID, &profile.ProfileName, &profile.FirstName,
		&profile.LastName, &profile.DisplayName, &profile.Bio, &profile.AvatarURL,
		&profile.DateOfBirth, &profile.Gender, &profile.Timezone, &profile.Locale,
		&profile.Country, &profile.City, &profile.Address, &profile.PostalCode,
		&profile.WebsiteURL, &metadataStr, &profile.CreatedAt, &profile.UpdatedAt)

	if err != nil {
		return nil, err
	}

	// Convert metadata back to []byte
	if metadataStr.Valid {
		profile.Metadata = []byte(metadataStr.String)
	} else {
		profile.Metadata = nil
	}

	return &profile, nil
}
