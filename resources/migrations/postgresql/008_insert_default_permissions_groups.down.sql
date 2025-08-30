-- Remove default data
DELETE FROM group_permissions;
DELETE FROM groups WHERE is_system = true;
DELETE FROM permissions WHERE is_system = true;
