-- Enforce phone uniqueness at the DB level, same as username and email.
-- Partial index (excluding NULLs) since phone is optional and multiple
-- users may have no phone number on file.
DROP INDEX IF EXISTS idx_users_phone;
CREATE UNIQUE INDEX idx_users_phone ON users(phone) WHERE phone IS NOT NULL;
