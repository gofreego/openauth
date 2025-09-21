# OpenAuth

OpenAuth is a comprehensive authentication and authorization service built with Go, providing secure user management, role-based access control, and session management capabilities. It offers both gRPC and HTTP APIs for seamless integration with various applications.

## 🚀 Features

- **User Management**: Complete user lifecycle management with email verification
- **Role-Based Access Control (RBAC)**: Granular permissions and group-based authorization
- **Session Management**: Secure JWT-based session handling
- **Multi-Protocol Support**: Both gRPC and HTTP/REST APIs
- **Statistics & Monitoring**: Built-in stats collection and health checks
- **Database Migrations**: Automated database schema management
- **Security**: Password hashing, JWT tokens, and secure authentication flows

## 📋 Prerequisites

- **Go**: 1.23.3 or higher
- **PostgreSQL**: Database for persistent storage
- **Protocol Buffers**: For gRPC API definitions
- **Docker**: Optional, for containerized deployment

## 🛠️ Installation

### 1. Clone the Repository

```bash
git clone https://github.com/gofreego/openauth.git
cd openauth
```

### 2. Install Dependencies

```bash
make install
```

This will:
- Download Go modules
- Install Protocol Buffer compilers
- Install gRPC gateway tools
- Install the SQL migrator tool

### 3. Configuration

Copy and configure the environment file:

```bash
cp dev.yaml.example dev.yaml
# Edit dev.yaml with your database and service configurations
```

## 🔧 Configuration

The service uses YAML configuration files. Key configuration sections:

### Database Configuration
```yaml
Database:
  Driver: postgres
  Host: localhost
  Port: 5432
  Name: openauth
  User: your_user
  Password: your_password
```

### Server Configuration
```yaml
Server:
  HTTP:
    Port: 8085
    AuthenticationEnabled: true
  GRPC:
    Port: 8086
```

### JWT Configuration
```yaml
JWT:
  Secret: your_jwt_secret
  ExpirationTime: 24h
```

## 🚀 Quick Start

### 1. Run Database Migrations

```bash
make migrate
```

### 2. Start the Service

#### Development Mode
```bash
make run
# or
go run main.go -env=dev -path=.
```

#### Production Build
```bash
make build
./bin/application -env=prod -path=.
```

#### Docker Deployment
```bash
make docker-run
```

### 3. Health Check

Verify the service is running:

```bash
# HTTP endpoint
curl http://localhost:8085/health

# gRPC endpoint (using grpcurl)
grpcurl -plaintext localhost:8086 openauth.v1.OpenAuthService/Ping
```

## 📚 API Documentation

### Core Services

#### 🔐 Authentication & Authorization
- **Sign Up**: User registration with email verification
- **Sign In**: Secure authentication with JWT tokens
- **Profile Management**: User profile operations
- **Session Management**: Token validation and refresh

#### 👥 User Management
- **Create/Read/Update/Delete Users**
- **List Users**: Paginated user listings with filtering
- **User Status Management**: Enable/disable user accounts

#### 🏷️ Group Management
- **Create/Manage Groups**: Organizational units for users
- **Assign Users to Groups**: Bulk user-group assignments
- **Group Permissions**: Associate permissions with groups

#### 🔑 Permission System
- **Create Permissions**: Define granular access controls
- **Assign Permissions**: To users or groups
- **Effective Permissions**: Calculate user's total permissions
- **Permission Validation**: Check user access rights

#### 📊 Statistics & Monitoring
- **Service Stats**: User counts, active sessions
- **Health Monitoring**: Service status and diagnostics

### API Endpoints

#### HTTP/REST API
Base URL: `http://localhost:8085`

```bash
# Authentication
POST   /api/v1/auth/signup
POST   /api/v1/auth/signin
GET    /api/v1/auth/profile
POST   /api/v1/auth/refresh

# Users
GET    /api/v1/users
POST   /api/v1/users
GET    /api/v1/users/{id}
PUT    /api/v1/users/{id}
DELETE /api/v1/users/{id}

# Groups
GET    /api/v1/groups
POST   /api/v1/groups
GET    /api/v1/groups/{id}
PUT    /api/v1/groups/{id}
DELETE /api/v1/groups/{id}

# Permissions
GET    /api/v1/permissions
POST   /api/v1/permissions
POST   /api/v1/permissions/assign
DELETE /api/v1/permissions/revoke
```

#### gRPC API
Port: `8086`

Service: `openauth.v1.OpenAuthService`

See `/api/proto/openauth/v1/` for complete Protocol Buffer definitions.

## 🗄️ Database Management

### Create a New Migration

```bash
migrate create -ext sql -dir resources/migrations/postgresql -seq create_users_table
```

This creates two files:
- `000001_create_users_table.up.sql` - Forward migration
- `000001_create_users_table.down.sql` - Rollback migration

### Run Migrations

```bash
make migrate
```

### Migration Configuration

Update `dev.yaml` with migration settings:

```yaml
Migration:
  Action: up          # up/down/force
  ForceVersion: 1     # Only for force action
  Driver: postgres
  SourceURL: file://resources/migrations/postgresql
```

## 🐛 Troubleshooting

### Dirty Database State

If you encounter: `Dirty database version X. Fix and force version.`

1. **Investigate the failed migration:**
   Note the failed migration number and examine the migration files.

2. **Manually inspect your database:**
   - Connect to your database
   - Check what changes were partially applied
   - Look for incomplete tables, indexes, or constraints

3. **Clean up manually:**
   - Remove any partially created objects
   - Ensure database consistency

4. **Force set the version:**
   ```yaml
   # In dev.yaml
   Migration:
     Action: force
     ForceVersion: <previous_version>
   ```
   ```bash
   make migrate
   ```

5. **Fix and retry:**
   ```bash
   # Edit the problematic migration
   vim resources/migrations/postgresql/000010_problematic_migration.up.sql
   
   # Update configuration
   # dev.yaml: Action: up
   make migrate
   ```

## 🏗️ Project Structure

```
openauth/
├── api/                    # API definitions and generated code
│   ├── openauth_v1/       # Generated Go code from protobuf
│   └── proto/             # Protocol Buffer definitions
├── cmd/                   # Application entry points
│   ├── grpc_server/       # gRPC server implementation
│   └── http_server/       # HTTP server implementation
├── internal/              # Internal application code
│   ├── configs/           # Configuration management
│   ├── constants/         # Application constants
│   ├── models/            # Data models and DAOs
│   ├── repository/        # Data access layer
│   └── service/           # Business logic layer
├── pkg/                   # Reusable packages
│   ├── clients/           # External service clients
│   ├── jwtutils/          # JWT utilities
│   └── utils/             # Common utilities
├── resources/             # Static resources
│   ├── configs/           # Configuration files
│   └── migrations/        # Database migrations
├── dev.yaml               # Development configuration
├── Dockerfile             # Container definition
├── Makefile               # Build and development commands
└── main.go                # Application entry point
```

## 🧪 Testing

```bash
# Run all tests
make test

# Run tests with coverage
go test -v -cover ./...

# Run specific package tests
go test -v ./internal/service/...
```

## 🚀 Deployment

### Docker Deployment

```bash
# Build and run with Docker
make docker-run
```

### Manual Deployment

```bash
# Build for Linux
make build-linux

# Copy binary and configuration files to target server
# Configure environment-specific YAML files
# Run database migrations
# Start the service
```

### Environment Variables

Key environment variables for deployment:

```bash
OPENAUTH_ENV=production
OPENAUTH_CONFIG_PATH=/etc/openauth/
OPENAUTH_LOG_LEVEL=info
```

## 🔧 Development

### Available Make Commands

```bash
make build         # Build the application
make build-linux   # Build for Linux deployment
make run           # Run in development mode
make test          # Run tests
make clean         # Clean build artifacts
make docker        # Build Docker image
make docker-run    # Build and run Docker container
make install       # Install dependencies and tools
make migrate       # Run database migrations
```

### Protocol Buffer Development

After modifying `.proto` files:

```bash
# Regenerate Go code
cd api
make generate
```

## 📈 Monitoring and Observability

The service includes built-in monitoring capabilities:

- **Health Checks**: `/health` endpoint for service status
- **Metrics**: Service statistics via `/api/v1/stats`
- **Logging**: Structured logging with configurable levels
- **Request Tracing**: Built-in request/response logging

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:

- **Documentation**: Check the `/api/docs/` directory for detailed API documentation
- **Issues**: Open an issue on the GitHub repository
- **Email**: Contact the development team

## 🔄 Version History

See [CHANGELOG.md](CHANGELOG.md) for version history and release notes.
