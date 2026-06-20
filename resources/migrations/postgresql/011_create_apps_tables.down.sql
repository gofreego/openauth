DROP TABLE IF EXISTS user_apps;
DROP TABLE IF EXISTS apps;
DELETE FROM permissions WHERE name IN ('apps.create', 'apps.read', 'apps.update', 'apps.delete', 'apps.assign', 'apps.list');
