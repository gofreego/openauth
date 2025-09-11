-- Drop Config Management Service Schema

DROP TRIGGER IF EXISTS update_configs_updated_at ON configs;
DROP TRIGGER IF EXISTS update_config_entities_updated_at ON config_entities;

-- Drop configs indexes
DROP INDEX IF EXISTS idx_configs_display_name;
DROP INDEX IF EXISTS idx_configs_key;
DROP INDEX IF EXISTS idx_configs_entity_id;

DROP TABLE IF EXISTS configs;

-- Drop config_entities indexes
DROP INDEX IF EXISTS idx_config_entities_display_name;
DROP INDEX IF EXISTS idx_config_entities_name;

DROP TABLE IF EXISTS config_entities;
