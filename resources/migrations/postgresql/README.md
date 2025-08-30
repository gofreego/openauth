# OpenAuth Database Schema

This document describes the comprehensive SQL schema for the user authentication system supporting multiple authentication methods, session management, role-based access control, and comprehensive audit logging.

## Features Supported

✅ **Multiple Registration Methods**
- Username/Email + Password
- Email/SMS OTP verification
- OAuth providers (Google, Facebook, GitHub, Microsoft, Apple, LinkedIn)

✅ **Session Management**
- JWT-like session tokens
- Refresh tokens
- Device tracking
- Session activity logging
- Multi-device support

✅ **Role-Based Access Control (RBAC)**
- Groups/Roles
- Granular permissions
- Permission inheritance
- Temporary permissions with expiration

✅ **User Profiles**
- Extended user information
- Social profiles from OAuth providers

✅ **Comprehensive Audit Logging**
- All critical operations logged
- Security event tracking
- Failed login attempt monitoring
- Automatic triggers for sensitive operations

## Database Tables

### Core User Management

#### `users`
Core user account information including authentication credentials and account status.

Key fields:
- `id` - UUID primary key
- `username` - Unique username
- `email` - Email address (unique)
- `phone` - Phone number
- `password_hash` - bcrypt hash
- `email_verified`, `phone_verified` - Verification status
- `is_active`, `is_locked` - Account status
- `failed_login_attempts` - Security tracking

#### `user_profiles`
Extended user profile information linked to users table.

Key fields:
- `user_id` - Reference to users table
- `first_name`, `last_name`, `display_name`
- `bio`, `avatar_url`
- `date_of_birth`, `gender`
- `timezone`, `locale`, `country`
- Address and contact information

### Authentication Providers

#### `auth_providers`
Configuration for OAuth and external authentication providers.

Key fields:
- `name` - Provider identifier (google, facebook, etc.)
- `client_id`, `client_secret` - OAuth credentials
- `auth_url`, `token_url`, `user_info_url` - OAuth endpoints
- `scope` - OAuth scope requirements
- `is_enabled` - Enable/disable provider

#### `user_external_accounts`
Links users to their external provider accounts.

Key fields:
- `user_id` - Reference to users table
- `provider_id` - Reference to auth_providers table
- `external_user_id` - ID from external provider
- `access_token`, `refresh_token` - OAuth tokens
- `external_data` - JSONB for additional provider data

### Verification & Security

#### `otp_verifications`
One-time passwords for email/phone verification and password reset.

Key fields:
- `user_id` - Reference to users table (optional for pre-registration)
- `email`, `phone` - Contact methods
- `otp_code` - The verification code
- `otp_type` - Purpose (email_verification, phone_verification, password_reset, login)
- `expires_at` - Expiration timestamp
- `attempts`, `max_attempts` - Rate limiting

#### `password_reset_tokens`
Secure tokens for password reset functionality.

#### `email_verification_tokens`
Tokens for email address verification.

### Session Management

#### `user_sessions`
Active user sessions with device and location tracking.

Key fields:
- `user_id` - Reference to users table
- `session_token` - Primary session identifier
- `refresh_token` - For token refresh
- `device_id`, `device_name`, `device_type` - Device information
- `user_agent`, `ip_address`, `location` - Request context
- `expires_at`, `refresh_expires_at` - Token lifetimes
- `last_activity_at` - Activity tracking

#### `session_activities`
Detailed log of session-related activities.

### Role-Based Access Control

#### `permissions`
Granular system permissions with resource-action pattern.

Key fields:
- `name` - Permission identifier (e.g., 'users.create')
- `resource` - Resource type (users, groups, etc.)
- `action` - Action type (create, read, update, delete)
- `is_system` - System permissions cannot be deleted

#### `groups`
User groups/roles for organizing permissions.

Key fields:
- `name` - Group identifier
- `display_name` - Human-readable name
- `is_system` - System groups cannot be deleted
- `is_default` - Automatically assigned to new users

#### `group_permissions`
Many-to-many relationship between groups and permissions.

#### `user_groups`
Assignment of users to groups with optional expiration.

Key fields:
- `user_id`, `group_id` - The assignment
- `assigned_by` - Who made the assignment
- `expires_at` - Optional expiration date

#### `user_permissions`
Direct permission assignments to users (bypassing groups).

### Audit & Security

#### `audit_logs`
Comprehensive audit trail for all critical operations.

Key fields:
- `user_id` - Who performed the action
- `entity_type`, `entity_id` - What was modified
- `action` - What action was performed
- `old_values`, `new_values`, `changes` - JSONB change tracking
- `severity` - Importance level
- `ip_address`, `user_agent` - Request context

#### `security_events`
Security-focused event logging.

Key fields:
- `event_type` - Type of security event
- `severity` - Security impact level
- `resolved` - Whether the event has been addressed
- `metadata` - JSONB for additional context

#### `login_attempts`
Detailed tracking of all login attempts (successful and failed).

Key fields:
- `identifier` - Username/email/phone used
- `success` - Whether login succeeded
- `failure_reason` - Why login failed
- `ip_address` - Source IP

## Views

The schema includes several useful views for common queries:

### `user_effective_permissions`
Shows all effective permissions for each user (from groups and direct assignments).

### `user_sessions_detailed`
Enhanced session information with user details and expiration status.

### `recent_security_events`
Security events from the last 30 days with user information.

### `failed_login_summary`
Summary of failed login attempts grouped by IP and identifier.

### `audit_logs_detailed`
Audit logs with human-readable entity names and user information.

## Triggers & Functions

### Automatic Audit Logging
- `log_permission_changes()` - Automatically logs permission and group changes
- Triggers on `group_permissions`, `user_groups`, and `user_permissions` tables

### User Management
- `add_user_to_default_group()` - Automatically adds new users to default group
- `update_updated_at_column()` - Maintains updated_at timestamps

## Default Data

### System Permissions
The schema includes comprehensive default permissions covering:
- User management (create, read, update, delete, list)
- Group management (create, read, update, delete, assign, revoke)
- Permission management (create, read, update, delete, assign, revoke)
- Session management (read, terminate)
- Audit access (read audit logs)
- System administration (admin, config)

### System Groups
- `super_admin` - Full system access
- `admin` - Administrative access (all except system.admin)
- `moderator` - User and content moderation
- `user` - Basic user permissions (default group)
- `guest` - Minimal access

### OAuth Providers
Pre-configured providers for:
- Google, Facebook, GitHub, Microsoft (enabled by default)
- Apple, LinkedIn (disabled by default)

## Security Features

1. **Password Security**: bcrypt hashing, password change tracking
2. **Account Security**: Account locking, failed attempt tracking
3. **Session Security**: Token expiration, device tracking, activity monitoring
4. **Audit Trail**: Comprehensive logging of all critical operations
5. **Rate Limiting**: OTP attempt limits, login attempt tracking
6. **Data Integrity**: Foreign key constraints, proper indexing
7. **Soft Security**: Automatic group assignment, permission inheritance

## Usage Examples

### Check User Permissions
```sql
SELECT permission_name, permission_source 
FROM user_effective_permissions 
WHERE user_id = 'user-uuid' AND resource = 'users';
```

### Get Active Sessions
```sql
SELECT * FROM user_sessions_detailed 
WHERE user_id = 'user-uuid' AND is_active = true AND NOT is_expired;
```

### Monitor Failed Logins
```sql
SELECT * FROM failed_login_summary 
WHERE failed_attempts >= 5;
```

### Audit Permission Changes
```sql
SELECT * FROM audit_logs_detailed 
WHERE entity_type IN ('group_permissions', 'user_groups', 'user_permissions')
AND created_at > CURRENT_TIMESTAMP - INTERVAL '24 hours';
```

## Migration Files

The schema is implemented through 10 migration files:

1. `001_create_users_table` - Core users table
2. `002_create_user_profiles_table` - Extended user profiles
3. `003_create_auth_providers_tables` - OAuth provider support
4. `004_create_verification_tables` - OTP and verification tokens
5. `005_create_session_tables` - Session management
6. `006_create_groups_permissions_tables` - RBAC system
7. `007_create_audit_security_tables` - Audit and security logging
8. `008_insert_default_permissions_groups` - Default permissions and groups
9. `009_insert_default_providers_triggers` - OAuth providers and triggers
10. `010_create_views` - Useful views for common queries

Each migration includes both up and down scripts for proper version control.

## Performance Considerations

- Comprehensive indexing on frequently queried columns
- JSONB columns for flexible data storage
- Partitioning recommendations for large audit tables
- View materialization for complex permission queries
- Proper foreign key relationships for data integrity

## Compliance & Privacy

The schema is designed with privacy and compliance in mind:
- User data separation (core vs. profile)
- Audit trails for compliance requirements
- Soft delete capabilities
- Data retention considerations
- GDPR-friendly design patterns
