-- Revert phone uniqueness enforcement back to a plain non-unique index.
DROP INDEX IF EXISTS idx_users_phone;
CREATE INDEX idx_users_phone ON users(phone);
