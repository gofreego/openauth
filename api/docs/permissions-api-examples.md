# Permission API Examples

This document provides comprehensive examples for using the Permission Management APIs.

## Overview

The Permission system uses Resource-Based Access Control (RBAC) where permissions are defined by combining:
- **Resource**: What entity/domain object (e.g., "users", "groups", "posts")  
- **Action**: What operation (e.g., "create", "read", "update", "delete")

## Common Permission Patterns

### User Management
```json
{
  "name": "users.create",
  "display_name": "Create Users",
  "description": "Allows creating new user accounts",
  "resource": "users",
  "action": "create"
}
```

### Content Management
```json
{
  "name": "posts.publish",
  "display_name": "Publish Posts", 
  "description": "Allows publishing posts to make them publicly visible",
  "resource": "posts",
  "action": "publish"
}
```

### Administrative Operations
```json
{
  "name": "reports.export",
  "display_name": "Export Reports",
  "description": "Allows exporting system reports in various formats",
  "resource": "reports", 
  "action": "export"
}
```

## API Examples

### Create Permission

**Request:**
```http
POST /openauth/v1/permissions
Content-Type: application/json

{
  "name": "users.create",
  "display_name": "Create Users",
  "description": "Allows creating new user accounts in the system",
  "resource": "users",
  "action": "create"
}
```

**Response:**
```json
{
  "id": 123,
  "name": "users.create",
  "display_name": "Create Users", 
  "description": "Allows creating new user accounts in the system",
  "resource": "users",
  "action": "create",
  "is_system": false,
  "created_at": 1693526400,
  "updated_at": 1693526400
}
```

### List Permissions with Filtering

**Get all user-related permissions:**
```http
GET /openauth/v1/permissions?resource=users&limit=20
```

**Search permissions by keyword:**
```http  
GET /openauth/v1/permissions?search=create&limit=10&offset=0
```

**Get only system permissions:**
```http
GET /openauth/v1/permissions?is_system=true
```

**Response:**
```json
{
  "permissions": [
    {
      "id": 123,
      "name": "users.create",
      "display_name": "Create Users",
      "resource": "users", 
      "action": "create",
      "is_system": false,
      "created_at": 1693526400,
      "updated_at": 1693526400
    }
  ],
  "total_count": 45,
  "limit": 10,
  "offset": 0,
  "has_more": true
}
```

### Update Permission

**Request:**
```http
PUT /openauth/v1/permissions/123
Content-Type: application/json

{
  "display_name": "Create User Accounts",
  "description": "Updated description for creating user accounts with additional validation"
}
```

### Error Responses

**Validation Error:**
```json
{
  "error": {
    "code": 3,
    "message": "name is required",
    "details": []
  }
}
```

**Permission Already Exists:**
```json
{
  "error": {
    "code": 6, 
    "message": "permission with this name already exists",
    "details": []
  }
}
```

**System Permission Protection:**
```json
{
  "error": {
    "code": 7,
    "message": "system permissions cannot be modified", 
    "details": []
  }
}
```

## Best Practices

### Naming Conventions
- Use lowercase resource and action names
- Follow format: `resource.action`
- Be descriptive but concise
- Examples: `users.create`, `orders.approve`, `reports.export`

### Resource Organization
- Group related functionality under common resources
- Use plural nouns for resources (`users` not `user`)
- Keep resource names short but meaningful

### Action Standardization
- Use standard CRUD operations: `create`, `read`, `update`, `delete`, `list`
- Add domain-specific actions as needed: `publish`, `approve`, `archive`
- Keep action names as verbs

### Permission Granularity
- Start with coarse-grained permissions and refine as needed
- Balance between security and usability
- Consider workflow requirements when defining actions

## Common Resources and Actions

| Resource | Actions | Description |
|----------|---------|-------------|
| users | create, read, update, delete, list | User account management |
| groups | create, read, update, delete, list | Group/role management |
| permissions | create, read, update, delete, list | Permission management |
| sessions | create, read, delete, list | Session management |
| posts | create, read, update, delete, list, publish, archive | Content management |
| orders | create, read, update, delete, list, approve, fulfill | Order processing |
| reports | read, list, export, generate | Reporting and analytics |
| settings | read, update | System configuration |
