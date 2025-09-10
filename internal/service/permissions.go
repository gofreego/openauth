package service

import (
	"context"
	"fmt"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/gofreego/openauth/pkg/jwtutils"
)

// CreatePermission creates a new permission
func (s *Service) CreatePermission(ctx context.Context, req *openauth_v1.CreatePermissionRequest) (*openauth_v1.Permission, error) {
	logger.Info(ctx, "Create permission request initiated for name: %s", req.Name)

	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Create permission failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsCreate) {
		logger.Warn(ctx, "userID=%d does not have permission to create permissions", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to create permissions")
	}

	logger.Debug(ctx, "Permission creation authorized by userID=%d for name: %s", claims.UserID, req.Name)

	// Check if permission with same name already exists
	existing, err := s.repo.GetPermissionByName(ctx, req.Name)
	if err == nil && existing != nil {
		logger.Warn(ctx, "Create permission failed: permission already exists with name: %s", req.Name)
		return nil, status.Error(codes.AlreadyExists, "permission with this name already exists")
	}

	permission := new(dao.Permission).FromCreatePermissionRequest(req, claims.UserID)
	// Save to repository
	createdPermission, err := s.repo.CreatePermission(ctx, permission)
	if err != nil {
		logger.Error(ctx, "Failed to create permission %s by userID=%d: %v", req.Name, claims.UserID, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to create permission: %v", err))
	}

	logger.Info(ctx, "Permission created successfully: ID=%d, name=%s, by userID=%d",
		createdPermission.ID, createdPermission.Name, claims.UserID)

	// Convert to proto response
	return createdPermission.ToProtoPermission(), nil
}

// GetPermission retrieves a permission by ID
func (s *Service) GetPermission(ctx context.Context, req *openauth_v1.GetPermissionRequest) (*openauth_v1.Permission, error) {

	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Get permission failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsRead) {
		logger.Warn(ctx, "userID=%d does not have permission to read permissions", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read permissions")
	}

	permission, err := s.repo.GetPermissionByID(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to get permission: %v", err))
	}
	if permission == nil {
		return nil, status.Error(codes.NotFound, "permission not found")
	}

	return permission.ToProtoPermission(), nil
}

// ListPermissions retrieves permissions with filtering and pagination
func (s *Service) ListPermissions(ctx context.Context, req *openauth_v1.ListPermissionsRequest) (*openauth_v1.ListPermissionsResponse, error) {

	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "List permissions failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsRead) {
		logger.Warn(ctx, "userID=%d does not have permission to read permissions", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read permissions")
	}

	// Build filters from request
	filters := filter.FromListPermissionsRequest(req)

	// Get permissions from repository
	permissions, err := s.repo.ListPermissions(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list permissions: %v", err))
	}

	// Convert to proto response
	protoPermissions := make([]*openauth_v1.Permission, len(permissions))
	for i, p := range permissions {
		protoPermissions[i] = p.ToProtoPermission()
	}

	return &openauth_v1.ListPermissionsResponse{
		Permissions: protoPermissions,
	}, nil
}

// UpdatePermission updates an existing permission
func (s *Service) UpdatePermission(ctx context.Context, req *openauth_v1.UpdatePermissionRequest) (*openauth_v1.Permission, error) {

	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Update permission failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsUpdate) {
		logger.Warn(ctx, "userID=%d does not have permission to update permissions", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to update permissions")
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
		updates["display_name"] = *req.DisplayName
	}

	if req.Description != nil {
		updates["description"] = req.Description
	}

	// Note: Resource and Action fields don't exist in UpdatePermissionRequest

	// Update permission
	updatedPermission, err := s.repo.UpdatePermission(ctx, req.Id, updates)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to update permission: %v", err))
	}

	return updatedPermission.ToProtoPermission(), nil
}

// DeletePermission deletes a permission
func (s *Service) DeletePermission(ctx context.Context, req *openauth_v1.DeletePermissionRequest) (*openauth_v1.DeletePermissionResponse, error) {

	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Delete permission failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsDelete) {
		logger.Warn(ctx, "userID=%d does not have permission to delete permissions", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to delete permissions")
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
