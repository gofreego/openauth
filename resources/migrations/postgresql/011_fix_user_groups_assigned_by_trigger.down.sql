-- Revert the add_user_to_default_group function to the original version
-- This will restore the function but may cause constraint violations

CREATE OR REPLACE FUNCTION add_user_to_default_group()
RETURNS TRIGGER AS $$
BEGIN
    -- Add user to default group if one exists
    INSERT INTO user_groups (user_id, group_id)
    SELECT NEW.id, g.id
    FROM groups g
    WHERE g.is_default = true
    AND NOT EXISTS (
        SELECT 1 FROM user_groups ug 
        WHERE ug.user_id = NEW.id AND ug.group_id = g.id
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
