-- Drop auth providers tables and related objects
DROP TRIGGER IF EXISTS update_user_external_accounts_updated_at ON user_external_accounts;
DROP TRIGGER IF EXISTS update_auth_providers_updated_at ON auth_providers;
DROP INDEX IF EXISTS idx_user_external_accounts_external_user_id;
DROP INDEX IF EXISTS idx_user_external_accounts_provider_id;
DROP INDEX IF EXISTS idx_user_external_accounts_user_id;
DROP INDEX IF EXISTS idx_auth_providers_enabled;
DROP INDEX IF EXISTS idx_auth_providers_name;
DROP TABLE IF EXISTS user_external_accounts;
DROP TABLE IF EXISTS auth_providers;
