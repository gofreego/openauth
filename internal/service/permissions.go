package service

import (
	"context"
	"fmt"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
)

// CreatePermission creates a new permission
func (s *Service) CreatePermission(ctx context.Context, req *openauth_v1.CreatePermissionRequest) (*openauth_v1.Permission, error) {
	// Validate required fields
	if req.Name == "" {
		return nil, status.Error(codes.InvalidArgument, "name is required")
	}
	if req.DisplayName == "" {
		return nil, status.Error(codes.InvalidArgument, "display_name is required")
	}
	if req.Resource == "" {
		return nil, status.Error(codes.InvalidArgument, "resource is required")
	}
	if req.Action == "" {
		return nil, status.Error(codes.InvalidArgument, "action is required")
	}

	// Check if permission with same name already exists
	existing, err := s.repo.GetPermissionByName(ctx, req.Name)
	if err == nil && existing != nil {
		return nil, status.Error(codes.AlreadyExists, "permission with this name already exists")
	}

	// Create permission object
	now := time.Now().Unix()
	permission := &dao.Permission{
		Name:        req.Name,
		DisplayName: req.DisplayName,
		Resource:    req.Resource,
		Action:      req.Action,
		IsSystem:    false, // User-created permissions are not system permissions
		CreatedAt:   now,
		UpdatedAt:   now,
	}

	if req.Description != nil {
		permission.Description = req.Description
	}

	// Save to repository
	createdPermission, err := s.repo.CreatePermission(ctx, permission)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to create permission: %v", err))
	}

	// Convert to proto response
	return createdPermission.ToProto(), nil
}

// GetPermission retrieves a permission by ID
func (s *Service) GetPermission(ctx context.Context, req *openauth_v1.GetPermissionRequest) (*openauth_v1.Permission, error) {
	if req.Id <= 0 {
		return nil, status.Error(codes.InvalidArgument, "id must be greater than 0")
	}

	permission, err := s.repo.GetPermissionByID(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to get permission: %v", err))
	}
	if permission == nil {
		return nil, status.Error(codes.NotFound, "permission not found")
	}

	return permission.ToProto(), nil
}

// ListPermissions retrieves permissions with filtering and pagination
func (s *Service) ListPermissions(ctx context.Context, req *openauth_v1.ListPermissionsRequest) (*openauth_v1.ListPermissionsResponse, error) {
	// Set default values
	limit := int32(constants.DefaultPageSize)
	offset := int32(0)

	if req.Limit != nil {
		if *req.Limit <= 0 {
			return nil, status.Error(codes.InvalidArgument, "limit must be greater than 0")
		}
		if *req.Limit > constants.MaxPageSize {
			return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("limit cannot exceed %d", constants.MaxPageSize))
		}
		limit = *req.Limit
	}

	if req.Offset != nil {
		if *req.Offset < 0 {
			return nil, status.Error(codes.InvalidArgument, "offset cannot be negative")
		}
		offset = *req.Offset
	}

	// Build filters
	filters := make(map[string]interface{})
	if req.Search != nil && *req.Search != "" {
		filters["search"] = *req.Search
	}
	if req.Resource != nil && *req.Resource != "" {
		filters["resource"] = *req.Resource
	}
	if req.Action != nil && *req.Action != "" {
		filters["action"] = *req.Action
	}
	if req.IsSystem != nil {
		filters["is_system"] = *req.IsSystem
	}

	// Get permissions from repository
	permissions, totalCount, err := s.repo.ListPermissions(ctx, limit, offset, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list permissions: %v", err))
	}

	// Convert to proto response
	protoPermissions := make([]*openauth_v1.Permission, len(permissions))
	for i, p := range permissions {
		protoPermissions[i] = p.ToProto()
	}

	hasMore := offset+int32(len(permissions)) < totalCount

	return &openauth_v1.ListPermissionsResponse{
		Permissions: protoPermissions,
		TotalCount:  totalCount,
		Limit:       limit,
		Offset:      offset,
		HasMore:     hasMore,
	}, nil
}

// UpdatePermission updates an existing permission
func (s *Service) UpdatePermission(ctx context.Context, req *openauth_v1.UpdatePermissionRequest) (*openauth_v1.Permission, error) {
	if req.Id <= 0 {
		return nil, status.Error(codes.InvalidArgument, "id must be greater than 0")
	}

	// Check if permission exists
	existing, err := s.repo.GetPermissionByID(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to get permission: %v", err))
	}
	if existing == nil {
		return nil, status.Error(codes.NotFound, "permission not found")
	}

	// Check if it's a system permission
	if existing.IsSystem {
		return nil, status.Error(codes.PermissionDenied, "system permissions cannot be modified")
	}

	// Build updates map
	updates := make(map[string]interface{})
	updates["updated_at"] = time.Now().Unix()

	if req.Name != nil {
		if *req.Name == "" {
			return nil, status.Error(codes.InvalidArgument, "name cannot be empty")
		}
		// Check if another permission with this name exists
		if *req.Name != existing.Name {
			existingByName, err := s.repo.GetPermissionByName(ctx, *req.Name)
			if err == nil && existingByName != nil {
				return nil, status.Error(codes.AlreadyExists, "permission with this name already exists")
			}
		}
		updates["name"] = *req.Name
	}

	if req.DisplayName != nil {
		if *req.DisplayName == "" {
			return nil, status.Error(codes.InvalidArgument, "display_name cannot be empty")
		}
		updates["display_name"] = *req.DisplayName
	}

	if req.Description != nil {
		updates["description"] = req.Description
	}

	if req.Resource != nil {
		if *req.Resource == "" {
			return nil, status.Error(codes.InvalidArgument, "resource cannot be empty")
		}
		updates["resource"] = *req.Resource
	}

	if req.Action != nil {
		if *req.Action == "" {
			return nil, status.Error(codes.InvalidArgument, "action cannot be empty")
		}
		updates["action"] = *req.Action
	}

	// Update permission
	updatedPermission, err := s.repo.UpdatePermission(ctx, req.Id, updates)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to update permission: %v", err))
	}

	return updatedPermission.ToProto(), nil
}

// DeletePermission deletes a permission
func (s *Service) DeletePermission(ctx context.Context, req *openauth_v1.DeletePermissionRequest) (*openauth_v1.DeletePermissionResponse, error) {
	if req.Id <= 0 {
		return nil, status.Error(codes.InvalidArgument, "id must be greater than 0")
	}

	// Check if permission exists
	existing, err := s.repo.GetPermissionByID(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to get permission: %v", err))
	}
	if existing == nil {
		return nil, status.Error(codes.NotFound, "permission not found")
	}

	// Check if it's a system permission
	if existing.IsSystem {
		return nil, status.Error(codes.PermissionDenied, "system permissions cannot be deleted")
	}

	// Delete permission
	err = s.repo.DeletePermission(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to delete permission: %v", err))
	}

	return &openauth_v1.DeletePermissionResponse{
		Success: true,
		Message: "Permission deleted successfully",
	}, nil
}
