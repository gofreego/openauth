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

// CreateUser creates a new user in the database
func (r *Repository) CreateUser(ctx context.Context, user *dao.User) (*dao.User, error) {
	query := `
		INSERT INTO users (uuid, username, email, phone, name, avatar_url, password_hash, email_verified, 
			phone_verified, is_active, is_locked, failed_login_attempts, password_changed_at, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
		RETURNING id, uuid, username, email, phone, name, avatar_url, password_hash, email_verified, 
			phone_verified, is_active, is_locked, failed_login_attempts, last_login_at, 
			password_changed_at, created_at, updated_at`

	row := r.connManager.Primary().QueryRowContext(ctx, query,
		user.UUID, user.Username, user.Email, user.Phone, user.Name, user.AvatarURL, user.PasswordHash,
		user.EmailVerified, user.PhoneVerified, user.IsActive, user.IsLocked,
		user.FailedLoginCount, user.PasswordChangedAt, user.CreatedAt, user.UpdatedAt)

	var createdUser dao.User
	err := row.Scan(
		&createdUser.ID, &createdUser.UUID, &createdUser.Username, &createdUser.Email,
		&createdUser.Phone, &createdUser.Name, &createdUser.AvatarURL, &createdUser.PasswordHash, &createdUser.EmailVerified,
		&createdUser.PhoneVerified, &createdUser.IsActive, &createdUser.IsLocked,
		&createdUser.FailedLoginCount, &createdUser.LastLoginAt, &createdUser.PasswordChangedAt,
		&createdUser.CreatedAt, &createdUser.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &createdUser, nil
}

// CreateUserProfile creates a new user profile in the database
func (r *Repository) CreateUserProfile(ctx context.Context, profile *dao.Profile) (*dao.Profile, error) {
	query := `
		INSERT INTO user_profiles (uuid, user_id, first_name, last_name, display_name, bio, 
			avatar_url, date_of_birth, gender, timezone, locale, country, city, address, 
			postal_code, website_url, metadata, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19)
		RETURNING id, uuid, user_id, first_name, last_name, display_name, bio, avatar_url,
			date_of_birth, gender, timezone, locale, country, city, address, postal_code,
			website_url, metadata, created_at, updated_at`

	row := r.connManager.Primary().QueryRowContext(ctx, query,
		profile.UUID, profile.UserID, profile.FirstName, profile.LastName,
		profile.DisplayName, profile.Bio, profile.AvatarURL, profile.DateOfBirth,
		profile.Gender, profile.Timezone, profile.Locale, profile.Country,
		profile.City, profile.Address, profile.PostalCode, profile.WebsiteURL,
		profile.Metadata, profile.CreatedAt, profile.UpdatedAt)

	var createdProfile dao.Profile
	err := row.Scan(
		&createdProfile.ID, &createdProfile.UUID, &createdProfile.UserID,
		&createdProfile.FirstName, &createdProfile.LastName, &createdProfile.DisplayName,
		&createdProfile.Bio, &createdProfile.AvatarURL, &createdProfile.DateOfBirth,
		&createdProfile.Gender, &createdProfile.Timezone, &createdProfile.Locale,
		&createdProfile.Country, &createdProfile.City, &createdProfile.Address,
		&createdProfile.PostalCode, &createdProfile.WebsiteURL, &createdProfile.Metadata,
		&createdProfile.CreatedAt, &createdProfile.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &createdProfile, nil
}

// GetUserByID retrieves a user by ID
func (r *Repository) GetUserByID(ctx context.Context, id int64) (*dao.User, error) {
	query := `
		SELECT id, uuid, username, email, phone, name, avatar_url, password_hash, email_verified,
			phone_verified, is_active, is_locked, failed_login_attempts, last_login_at,
			password_changed_at, created_at, updated_at
		FROM users WHERE id = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, id)
	return r.scanUser(row)
}

// GetUserByUUID retrieves a user by UUID
func (r *Repository) GetUserByUUID(ctx context.Context, userUUID string) (*dao.User, error) {
	query := `
		SELECT id, uuid, username, email, phone, name, avatar_url, password_hash, email_verified,
			phone_verified, is_active, is_locked, failed_login_attempts, last_login_at,
			password_changed_at, created_at, updated_at
		FROM users WHERE uuid = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, userUUID)
	return r.scanUser(row)
}

// GetUserByUsername retrieves a user by username
func (r *Repository) GetUserByUsername(ctx context.Context, username string) (*dao.User, error) {
	query := `
		SELECT id, uuid, username, email, phone, name, avatar_url, password_hash, email_verified,
			phone_verified, is_active, is_locked, failed_login_attempts, last_login_at,
			password_changed_at, created_at, updated_at
		FROM users WHERE username = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, username)
	return r.scanUser(row)
}

// GetUserByEmail retrieves a user by email
func (r *Repository) GetUserByEmail(ctx context.Context, email string) (*dao.User, error) {
	query := `
		SELECT id, uuid, username, email, phone, name, avatar_url, password_hash, email_verified,
			phone_verified, is_active, is_locked, failed_login_attempts, last_login_at,
			password_changed_at, created_at, updated_at
		FROM users WHERE email = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, email)
	return r.scanUser(row)
}

// GetUserByPhone implements service.Repository.
func (r *Repository) GetUserByPhone(ctx context.Context, identifier string) (*dao.User, error) {
	query := `
		SELECT id, uuid, username, email, phone, name, avatar_url, password_hash, email_verified,
			phone_verified, is_active, is_locked, failed_login_attempts, last_login_at,
			password_changed_at, created_at, updated_at
		FROM users WHERE phone = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, identifier)
	return r.scanUser(row)
}

// GetUserProfile retrieves a user profile by user ID
func (r *Repository) GetUserProfile(ctx context.Context, userID int64) (*dao.Profile, error) {
	query := `
		SELECT id, uuid, user_id, first_name, last_name, display_name, bio, avatar_url,
			date_of_birth, gender, timezone, locale, country, city, address, postal_code,
			website_url, metadata, created_at, updated_at
		FROM user_profiles WHERE user_id = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, userID)
	return r.scanProfile(row)
}

// UpdateUser updates user fields
func (r *Repository) UpdateUser(ctx context.Context, id int64, updates map[string]interface{}) (*dao.User, error) {
	if len(updates) == 0 {
		return r.GetUserByID(ctx, id)
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
		UPDATE users SET %s WHERE id = $%d
		RETURNING id, uuid, username, email, phone, name, avatar_url, password_hash, email_verified,
			phone_verified, is_active, is_locked, failed_login_attempts, last_login_at,
			password_changed_at, created_at, updated_at`,
		strings.Join(setParts, ", "), argIndex)

	args = append(args, id)

	row := r.connManager.Primary().QueryRowContext(ctx, query, args...)
	return r.scanUser(row)
}

// UpdateUserProfile updates user profile fields
func (r *Repository) UpdateUserProfile(ctx context.Context, userID int64, updates map[string]interface{}) (*dao.Profile, error) {
	if len(updates) == 0 {
		return r.GetUserProfile(ctx, userID)
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
		UPDATE user_profiles SET %s WHERE user_id = $%d
		RETURNING id, uuid, user_id, first_name, last_name, display_name, bio, avatar_url,
			date_of_birth, gender, timezone, locale, country, city, address, postal_code,
			website_url, metadata, created_at, updated_at`,
		strings.Join(setParts, ", "), argIndex)

	args = append(args, userID)

	row := r.connManager.Primary().QueryRowContext(ctx, query, args...)
	return r.scanProfile(row)
}

// DeleteUser deletes or deactivates a user
func (r *Repository) DeleteUser(ctx context.Context, id int64, softDelete bool) error {
	if softDelete {
		updates := map[string]interface{}{
			"is_active":  false,
			"updated_at": time.Now().Unix(),
		}
		_, err := r.UpdateUser(ctx, id, updates)
		return err
	}

	// Hard delete - delete from both tables
	tx, err := r.connManager.Primary().BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	// Delete profile first due to foreign key constraint
	_, err = tx.ExecContext(ctx, "DELETE FROM user_profiles WHERE user_id = $1", id)
	if err != nil {
		return err
	}

	// Delete user
	_, err = tx.ExecContext(ctx, "DELETE FROM users WHERE id = $1", id)
	if err != nil {
		return err
	}

	return tx.Commit()
}

// ListUsers retrieves users with filtering and pagination
func (r *Repository) ListUsers(ctx context.Context, filters *filter.UserFilter) ([]*dao.User, error) {
	whereConditions := []string{}
	args := []interface{}{}
	argIndex := 1

	// Build WHERE conditions
	if filters.HasSearch() {
		whereConditions = append(whereConditions, fmt.Sprintf("(username ILIKE $%d OR email ILIKE $%d OR phone ILIKE $%d OR name ILIKE $%d)", argIndex, argIndex+1, argIndex+2, argIndex+3))
		searchPattern := "%" + *filters.Search + "%"
		args = append(args, searchPattern, searchPattern, searchPattern, searchPattern)
		argIndex += 4
	}

	if filters.HasEmail() {
		whereConditions = append(whereConditions, fmt.Sprintf("email ILIKE $%d", argIndex))
		args = append(args, "%"+*filters.Email+"%")
		argIndex++
	}

	if filters.HasUsername() {
		whereConditions = append(whereConditions, fmt.Sprintf("username ILIKE $%d", argIndex))
		args = append(args, "%"+*filters.Username+"%")
		argIndex++
	}

	if filters.HasPhone() {
		whereConditions = append(whereConditions, fmt.Sprintf("phone ILIKE $%d", argIndex))
		args = append(args, "%"+*filters.Phone+"%")
		argIndex++
	}

	if filters.HasIsActive() {
		whereConditions = append(whereConditions, fmt.Sprintf("is_active = $%d", argIndex))
		args = append(args, *filters.IsActive)
		argIndex++
	}

	if filters.HasIsLocked() {
		whereConditions = append(whereConditions, fmt.Sprintf("is_locked = $%d", argIndex))
		args = append(args, *filters.IsLocked)
		argIndex++
	}

	if filters.HasEmailVerified() {
		whereConditions = append(whereConditions, fmt.Sprintf("email_verified = $%d", argIndex))
		args = append(args, *filters.EmailVerified)
		argIndex++
	}

	if filters.HasPhoneVerified() {
		whereConditions = append(whereConditions, fmt.Sprintf("phone_verified = $%d", argIndex))
		args = append(args, *filters.PhoneVerified)
		argIndex++
	}

	whereClause := ""
	if len(whereConditions) > 0 {
		whereClause = "WHERE " + strings.Join(whereConditions, " AND ")
	}

	// Build ORDER BY clause - simplified to default ordering for now
	orderBy := "ORDER BY created_at DESC"

	// Get paginated results
	query := fmt.Sprintf(`
		SELECT id, uuid, username, email, phone, name, avatar_url, password_hash, email_verified,
			phone_verified, is_active, is_locked, failed_login_attempts, last_login_at,
			password_changed_at, created_at, updated_at
		FROM users %s %s LIMIT $%d OFFSET $%d`,
		whereClause, orderBy, argIndex, argIndex+1)

	args = append(args, filters.Limit, filters.Offset)

	rows, err := r.connManager.Primary().QueryContext(ctx, query, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	users := []*dao.User{}
	for rows.Next() {
		user, err := r.scanUserFromRows(rows)
		if err != nil {
			return nil, err
		}
		users = append(users, user)
	}

	return users, rows.Err()
}

// CheckUsernameExists checks if a username already exists
func (r *Repository) CheckUsernameExists(ctx context.Context, username string) (bool, error) {
	query := "SELECT EXISTS(SELECT 1 FROM users WHERE username = $1)"
	var exists bool
	err := r.connManager.Primary().QueryRowContext(ctx, query, username).Scan(&exists)
	return exists, err
}

// CheckEmailExists checks if an email already exists
func (r *Repository) CheckEmailExists(ctx context.Context, email string) (bool, error) {
	query := "SELECT EXISTS(SELECT 1 FROM users WHERE email = $1)"
	var exists bool
	err := r.connManager.Primary().QueryRowContext(ctx, query, email).Scan(&exists)
	return exists, err
}

// Verification methods

// CreateOTPVerification creates a new OTP verification record
func (r *Repository) CreateOTPVerification(ctx context.Context, otp *dao.OTPVerification) error {
	query := `
		INSERT INTO otp_verifications (user_id, identifier, otp_code, otp_type, is_used, 
			expires_at, attempts, max_attempts, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`

	_, err := r.connManager.Primary().ExecContext(ctx, query,
		otp.UserID, otp.Identifier, otp.OTPCode, otp.OTPType,
		otp.IsUsed, otp.ExpiresAt, otp.Attempts, otp.MaxAttempts, otp.CreatedAt)

	return err
}

// GetOTPVerification retrieves an OTP verification record
func (r *Repository) GetOTPVerification(ctx context.Context, identifier, code string) (*dao.OTPVerification, error) {
	query := `
		SELECT id, user_id, identifier, otp_code, otp_type, is_used, expires_at,
			attempts, max_attempts, created_at
		FROM otp_verifications 
		WHERE identifier = $1 AND otp_code = $2 AND is_used = false
		ORDER BY created_at DESC LIMIT 1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, identifier, code)

	var otp dao.OTPVerification
	err := row.Scan(
		&otp.ID, &otp.UserID, &otp.Identifier, &otp.OTPCode,
		&otp.OTPType, &otp.IsUsed, &otp.ExpiresAt, &otp.Attempts,
		&otp.MaxAttempts, &otp.CreatedAt)

	if err != nil {
		return nil, err
	}

	return &otp, nil
}

// UpdateVerificationStatus updates user verification status
func (r *Repository) UpdateVerificationStatus(ctx context.Context, userID int64, field string, verified bool) error {
	query := fmt.Sprintf("UPDATE users SET %s = $1, updated_at = $2 WHERE id = $3", field)
	_, err := r.connManager.Primary().ExecContext(ctx, query, verified, time.Now().Unix(), userID)
	return err
}

// DeleteOTPVerification deletes OTP verification records
func (r *Repository) DeleteOTPVerification(ctx context.Context, identifier, otpType string) error {
	query := `DELETE FROM otp_verifications WHERE (email = $1 OR phone = $1) AND otp_type = $2`
	_, err := r.connManager.Primary().ExecContext(ctx, query, identifier, otpType)
	return err
}

// Helper methods

func (r *Repository) scanUser(row *sql.Row) (*dao.User, error) {
	var user dao.User
	err := row.Scan(
		&user.ID, &user.UUID, &user.Username, &user.Email, &user.Phone,
		&user.Name, &user.AvatarURL, &user.PasswordHash, &user.EmailVerified, &user.PhoneVerified,
		&user.IsActive, &user.IsLocked, &user.FailedLoginCount,
		&user.LastLoginAt, &user.PasswordChangedAt, &user.CreatedAt, &user.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (r *Repository) scanUserFromRows(rows *sql.Rows) (*dao.User, error) {
	var user dao.User
	err := rows.Scan(
		&user.ID, &user.UUID, &user.Username, &user.Email, &user.Phone,
		&user.Name, &user.AvatarURL, &user.PasswordHash, &user.EmailVerified, &user.PhoneVerified,
		&user.IsActive, &user.IsLocked, &user.FailedLoginCount,
		&user.LastLoginAt, &user.PasswordChangedAt, &user.CreatedAt, &user.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (r *Repository) scanProfile(row *sql.Row) (*dao.Profile, error) {
	var profile dao.Profile
	err := row.Scan(
		&profile.ID, &profile.UUID, &profile.UserID, &profile.FirstName,
		&profile.LastName, &profile.DisplayName, &profile.Bio, &profile.AvatarURL,
		&profile.DateOfBirth, &profile.Gender, &profile.Timezone, &profile.Locale,
		&profile.Country, &profile.City, &profile.Address, &profile.PostalCode,
		&profile.WebsiteURL, &profile.Metadata, &profile.CreatedAt, &profile.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &profile, nil
}

// ListUserProfiles retrieves all profiles for a specific user with pagination
func (r *Repository) ListUserProfiles(ctx context.Context, filters *filter.UserProfilesFilter) ([]*dao.Profile, error) {
	// Get the profiles with pagination
	query := `
		SELECT p.id, p.uuid, p.user_id, p.first_name, p.last_name, p.display_name, 
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
		SELECT id, uuid, user_id, first_name, last_name, display_name, bio, avatar_url,
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
		args = append(args, value)
		argIndex++
	}

	// Add updated_at timestamp
	setParts = append(setParts, fmt.Sprintf("updated_at = $%d", argIndex))
	args = append(args, time.Now())
	argIndex++

	// Add UUID as the last parameter
	args = append(args, uuid)

	query := fmt.Sprintf(`
		UPDATE user_profiles 
		SET %s 
		WHERE uuid = $%d
		RETURNING id, uuid, user_id, first_name, last_name, display_name, bio, avatar_url,
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
	err := rows.Scan(
		&profile.ID, &profile.UUID, &profile.UserID, &profile.FirstName,
		&profile.LastName, &profile.DisplayName, &profile.Bio, &profile.AvatarURL,
		&profile.DateOfBirth, &profile.Gender, &profile.Timezone, &profile.Locale,
		&profile.Country, &profile.City, &profile.Address, &profile.PostalCode,
		&profile.WebsiteURL, &profile.Metadata, &profile.CreatedAt, &profile.UpdatedAt)

	if err != nil {
		return nil, err
	}

	return &profile, nil
}
