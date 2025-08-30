# OpenAuth

## Migrations Basic Commands

### Create a new migration

```bash
migrate create -ext sql -dir resources/migrations/postgresql -seq create_users_table
```

This creates two files:
- `000001_create_users_table.up.sql` - Forward migration
- `000001_create_users_table.down.sql` - Rollback migration

### Run migrations

### Rollback migrations

### Check migration status


## Troubleshooting

### Dirty Database State

If you encounter the error: `Dirty database version X. Fix and force version.`

This means a migration failed partway through. Here's how to fix it:

1. **Investigate the failed migration:**
    Note down the migration no which is failed and fix the migration files. 

2. **Manually inspect your database:**
   - Connect to your database
   - Check what changes were partially applied
   - Look for incomplete tables, indexes, or constraints

3. **Clean up the database manually:**
   - Remove any partially created objects
   - Ensure the database is in a consistent state

4. **Force set the version:**
   - update .yml file ForceVersion: version_numer
   - update .yml file Action: force
   - run the migration
   ```bash
      make migrate
   ```

5. **Fix the problematic migration and retry:**
   ```bash
   # Edit the migration file
   vim migrations/000010_problematic_migration.up.sql
   
   # Run migrations again
   - update .yml file Action: up
   
    make migrate
    ```