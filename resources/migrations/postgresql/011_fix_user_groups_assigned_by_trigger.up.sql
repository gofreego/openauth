-- Fix the add_user_to_default_group function to include assigned_by field
-- This migration fixes the trigger that was causing null constraint violations

CREATE OR REPLACE FUNCTION add_user_to_default_group()
RETURNS TRIGGER AS $$
BEGIN
    -- Add user to default group if one exists
    -- Use the newly created user as the assigned_by (self-assignment during registration)
    INSERT INTO user_groups (user_id, group_id, assigned_by)
    SELECT NEW.id, g.id, NEW.id
    FROM groups g
    WHERE g.is_default = true
    AND NOT EXISTS (
        SELECT 1 FROM user_groups ug 
        WHERE ug.user_id = NEW.id AND ug.group_id = g.id
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
