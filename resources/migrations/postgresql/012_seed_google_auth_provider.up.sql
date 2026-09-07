INSERT INTO auth_providers (name, display_name, is_enabled)
VALUES ('google', 'Google', true)
ON CONFLICT (name) DO NOTHING;
