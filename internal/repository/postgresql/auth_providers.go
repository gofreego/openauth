package postgresql

import (
	"context"
	"database/sql"

	"github.com/gofreego/openauth/internal/models/dao"
)

// GetAuthProviderByName retrieves an auth provider (e.g. "google") by its unique name.
func (r *Repository) GetAuthProviderByName(ctx context.Context, name string) (*dao.AuthProvider, error) {
	query := `
		SELECT id, uuid, name, display_name, client_id, client_secret, auth_url, token_url,
			user_info_url, scope, is_enabled, created_at, updated_at
		FROM auth_providers
		WHERE name = $1`

	row := r.connManager.Primary().QueryRowContext(ctx, query, name)

	var provider dao.AuthProvider
	err := row.Scan(
		&provider.ID, &provider.UUID, &provider.Name, &provider.DisplayName,
		&provider.ClientID, &provider.ClientSecret, &provider.AuthURL, &provider.TokenURL,
		&provider.UserInfoURL, &provider.Scope, &provider.IsEnabled, &provider.CreatedAt, &provider.UpdatedAt)
	if err != nil {
		return nil, err
	}

	return &provider, nil
}

// GetUserExternalAccount retrieves a linked external account by provider + external user id.
func (r *Repository) GetUserExternalAccount(ctx context.Context, providerID int64, externalUserID string) (*dao.UserExternalAccount, error) {
	query := `
		SELECT id, uuid, user_id, provider_id, external_user_id, external_username, external_email,
			access_token, refresh_token, token_expires_at, external_data, created_at, updated_at
		FROM user_external_accounts
		WHERE provider_id = $1 AND external_user_id = $2`

	row := r.connManager.Primary().QueryRowContext(ctx, query, providerID, externalUserID)

	var account dao.UserExternalAccount
	err := row.Scan(
		&account.ID, &account.UUID, &account.UserID, &account.ProviderID, &account.ExternalUserID,
		&account.ExternalUsername, &account.ExternalEmail, &account.AccessToken, &account.RefreshToken,
		&account.TokenExpiresAt, &account.ExternalData, &account.CreatedAt, &account.UpdatedAt)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, sql.ErrNoRows
		}
		return nil, err
	}

	return &account, nil
}

// CreateUserExternalAccount links an external (OAuth) account to a user.
func (r *Repository) CreateUserExternalAccount(ctx context.Context, account *dao.UserExternalAccount) (*dao.UserExternalAccount, error) {
	query := `
		INSERT INTO user_external_accounts (user_id, provider_id, external_user_id, external_username,
			external_email, access_token, refresh_token, token_expires_at, external_data, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
		RETURNING id, uuid, user_id, provider_id, external_user_id, external_username, external_email,
			access_token, refresh_token, token_expires_at, external_data, created_at, updated_at`

	row := r.connManager.Primary().QueryRowContext(ctx, query,
		account.UserID, account.ProviderID, account.ExternalUserID, account.ExternalUsername,
		account.ExternalEmail, account.AccessToken, account.RefreshToken, account.TokenExpiresAt,
		account.ExternalData, account.CreatedAt, account.UpdatedAt)

	var created dao.UserExternalAccount
	err := row.Scan(
		&created.ID, &created.UUID, &created.UserID, &created.ProviderID, &created.ExternalUserID,
		&created.ExternalUsername, &created.ExternalEmail, &created.AccessToken, &created.RefreshToken,
		&created.TokenExpiresAt, &created.ExternalData, &created.CreatedAt, &created.UpdatedAt)
	if err != nil {
		return nil, err
	}

	return &created, nil
}
