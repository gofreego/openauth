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
	"github.com/gofreego/openauth/pkg/jwtutils"
)

// AssignPermissionsToGroup assigns multiple permissions to a group
func (s *Service) AssignPermissionsToGroup(ctx context.Context, req *openauth_v1.AssignPermissionsToGroupRequest) (*openauth_v1.AssignPermissionsToGroupResponse, error) {
	logger.Info(ctx, "Permission assignment to group requested: groupID=%d, permissionIDs=%v", req.GroupId, req.PermissionsIds)
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsAssign) {
		logger.Warn(ctx, "userID=%d does not have permission to assign permissions", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to assign permissions")
	}

	logger.Debug(ctx, "Permission assignment initiated by userID=%d for groupID=%d, permissionIDs=%v", claims.UserID, req.GroupId, req.PermissionsIds)

	// Validate input
	if req.GroupId <= 0 {
		logger.Warn(ctx, "Permission assignment failed: invalid group_id=%d", req.GroupId)
		return nil, status.Error(codes.InvalidArgument, "group_id must be greater than 0")
	}
	if len(req.PermissionsIds) == 0 {
		logger.Warn(ctx, "Permission assignment failed: no permission IDs provided")
		return nil, status.Error(codes.InvalidArgument, "permission_ids are required")
	}

	// Assign permissions to group using bulk operation
	err = s.repo.AssignPermissionsToGroup(ctx, req.GroupId, req.PermissionsIds, claims.UserID)
	if err != nil {
		logger.Error(ctx, "Failed to assign permissions to group: groupID=%d, permissionIDs=%v, grantedBy=%d: %v",
			req.GroupId, req.PermissionsIds, claims.UserID, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to assign permissions to group: %v", err))
	}

	logger.Info(ctx, "Permissions successfully assigned to group: groupID=%d, permissionIDs=%v, grantedBy=%d",
		req.GroupId, req.PermissionsIds, claims.UserID)

	return &openauth_v1.AssignPermissionsToGroupResponse{
		Message: fmt.Sprintf("Successfully assigned %d permissions to group", len(req.PermissionsIds)),
	}, nil
}

// RemovePermissionsFromGroup removes multiple permissions from a group
func (s *Service) RemovePermissionsFromGroup(ctx context.Context, req *openauth_v1.RemovePermissionsFromGroupRequest) (*openauth_v1.RemovePermissionsFromGroupResponse, error) {
	logger.Info(ctx, "Permission removal from group requested: groupID=%d, permissionIDs=%v", req.GroupId, req.PermissionsIds)

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsRevoke) {
		logger.Warn(ctx, "userID=%d does not have permission to revoke permissions", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to revoke permissions")
	}

	logger.Debug(ctx, "Permission removal initiated by userID=%d for groupID=%d, permissionIDs=%v", claims.UserID, req.GroupId, req.PermissionsIds)

	// Validate input
	if req.GroupId <= 0 {
		logger.Warn(ctx, "Permission removal failed: invalid group_id=%d", req.GroupId)
		return nil, status.Error(codes.InvalidArgument, "group_id must be greater than 0")
	}
	if len(req.PermissionsIds) == 0 {
		logger.Warn(ctx, "Permission removal failed: no permission IDs provided")
		return nil, status.Error(codes.InvalidArgument, "permission_ids are required")
	}

	// Remove permissions from group using bulk operation
	err = s.repo.RemovePermissionsFromGroup(ctx, req.GroupId, req.PermissionsIds)
	if err != nil {
		logger.Error(ctx, "Failed to remove permissions from group: groupID=%d, permissionIDs=%v: %v",
			req.GroupId, req.PermissionsIds, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to remove permissions from group: %v", err))
	}

	logger.Info(ctx, "Permissions successfully removed from group: groupID=%d, permissionIDs=%v",
		req.GroupId, req.PermissionsIds)

	return &openauth_v1.RemovePermissionsFromGroupResponse{
		Success: true,
		Message: fmt.Sprintf("Successfully removed %d permissions from group", len(req.PermissionsIds)),
	}, nil
}

// ListGroupPermissions retrieves permissions assigned to a group
func (s *Service) ListGroupPermissions(ctx context.Context, req *openauth_v1.ListGroupPermissionsRequest) (*openauth_v1.ListGroupPermissionsResponse, error) {
	logger.Debug(ctx, "List group permissions requested: groupID=%d", req.GroupId)
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

	logger.Debug(ctx, "List group permissions initiated by userID=%d for groupID=%d", claims.UserID, req.GroupId)

	// Validate input
	if req.GroupId <= 0 {
		logger.Warn(ctx, "List group permissions failed: invalid group_id=%d", req.GroupId)
		return nil, status.Error(codes.InvalidArgument, "group_id must be greater than 0")
	}

	// Get group permissions from repository
	groupPermissions, err := s.repo.ListGroupPermissions(ctx, req.GroupId)
	if err != nil {
		logger.Error(ctx, "Failed to list group permissions: groupID=%d: %v", req.GroupId, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list group permissions: %v", err))
	}

	logger.Debug(ctx, "Retrieved %d permissions for groupID=%d", len(groupPermissions), req.GroupId)

	// Convert to proto response
	protoGroupPermissions := make([]*openauth_v1.EffectivePermission, len(groupPermissions))
	for i, gp := range groupPermissions {
		protoGroupPermissions[i] = gp.ToProtoUserEffectivePermission()
	}

	return &openauth_v1.ListGroupPermissionsResponse{
		Permissions: protoGroupPermissions,
	}, nil
}

// AssignPermissionsToUser assigns multiple permissions directly to a user
func (s *Service) AssignPermissionsToUser(ctx context.Context, req *openauth_v1.AssignPermissionsToUserRequest) (*openauth_v1.AssignPermissionsToUserResponse, error) {
	logger.Info(ctx, "Permission assignment to user requested: userID=%d, permissionIDs=%v", req.UserId, req.PermissionsIds)
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsAssign) {
		logger.Warn(ctx, "userID=%d does not have permission to assign permissions", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to assign permissions")
	}

	logger.Debug(ctx, "Permission assignment initiated by userID=%d for targetUserID=%d, permissionIDs=%v", claims.UserID, req.UserId, req.PermissionsIds)

	// Validate input
	if req.UserId <= 0 {
		logger.Warn(ctx, "Permission assignment failed: invalid user_id=%d", req.UserId)
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}
	if len(req.PermissionsIds) == 0 {
		logger.Warn(ctx, "Permission assignment failed: no permission IDs provided")
		return nil, status.Error(codes.InvalidArgument, "permission_ids are required")
	}

	// Validate expiration time if provided
	if req.ExpiresAt != nil && *req.ExpiresAt <= time.Now().Unix() {
		logger.Warn(ctx, "Permission assignment failed: expires_at is in the past: userID=%d, permissionIDs=%v, expires_at=%d",
			req.UserId, req.PermissionsIds, *req.ExpiresAt)
		return nil, status.Error(codes.InvalidArgument, "expires_at must be in the future")
	}

	// Assign permissions to user using bulk operation
	err = s.repo.AssignPermissionsToUser(ctx, req.UserId, req.PermissionsIds, claims.UserID, req.ExpiresAt)
	if err != nil {
		logger.Error(ctx, "Failed to assign permissions to user: userID=%d, permissionIDs=%v, grantedBy=%d: %v",
			req.UserId, req.PermissionsIds, claims.UserID, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to assign permissions to user: %v", err))
	}

	logger.Info(ctx, "Permissions successfully assigned to user: userID=%d, permissionIDs=%v, grantedBy=%d",
		req.UserId, req.PermissionsIds, claims.UserID)

	return &openauth_v1.AssignPermissionsToUserResponse{
		Message: fmt.Sprintf("Successfully assigned %d permissions to user", len(req.PermissionsIds)),
	}, nil
}

// RemovePermissionsFromUser removes multiple permissions directly assigned to a user
func (s *Service) RemovePermissionsFromUser(ctx context.Context, req *openauth_v1.RemovePermissionsFromUserRequest) (*openauth_v1.RemovePermissionsFromUserResponse, error) {
	logger.Info(ctx, "Permission removal from user requested: userID=%d, permissionIDs=%v", req.UserId, req.PermissionsIds)
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsRevoke) {
		logger.Warn(ctx, "userID=%d does not have permission to revoke permissions", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to revoke permissions")
	}

	logger.Debug(ctx, "Permission removal initiated by userID=%d for targetUserID=%d, permissionIDs=%v", claims.UserID, req.UserId, req.PermissionsIds)

	// Validate input
	if req.UserId <= 0 {
		logger.Warn(ctx, "Permission removal failed: invalid user_id=%d", req.UserId)
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}
	if len(req.PermissionsIds) == 0 {
		logger.Warn(ctx, "Permission removal failed: no permission IDs provided")
		return nil, status.Error(codes.InvalidArgument, "permission_ids are required")
	}

	// Remove permissions from user using bulk operation
	err = s.repo.RemovePermissionsFromUser(ctx, req.UserId, req.PermissionsIds)
	if err != nil {
		logger.Error(ctx, "Failed to remove permissions from user: userID=%d, permissionIDs=%v: %v",
			req.UserId, req.PermissionsIds, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to remove permissions from user: %v", err))
	}

	logger.Info(ctx, "Permissions successfully removed from user: userID=%d, permissionIDs=%v",
		req.UserId, req.PermissionsIds)

	return &openauth_v1.RemovePermissionsFromUserResponse{
		Success: true,
		Message: fmt.Sprintf("Successfully removed %d permissions from user", len(req.PermissionsIds)),
	}, nil
}

// ListUserPermissions retrieves permissions directly assigned to a user
func (s *Service) ListUserPermissions(ctx context.Context, req *openauth_v1.ListUserPermissionsRequest) (*openauth_v1.ListUserPermissionsResponse, error) {
	logger.Debug(ctx, "List user permissions requested: userID=%d", req.UserId)
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsRead) {
		logger.Warn(ctx, "userID=%d does not have permission to read groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read groups")
	}

	logger.Debug(ctx, "List user permissions initiated by userID=%d for targetUserID=%d", claims.UserID, req.UserId)

	// Validate input
	if req.UserId <= 0 {
		logger.Warn(ctx, "List user permissions failed: invalid user_id=%d", req.UserId)
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}
	// Get user permissions from repository
	userPermissions, err := s.repo.ListUserPermissions(ctx, req.UserId)
	if err != nil {
		logger.Error(ctx, "Failed to list user permissions: userID=%d: %v", req.UserId, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list user permissions: %v", err))
	}

	logger.Debug(ctx, "Retrieved %d permissions for userID=%d", len(userPermissions), req.UserId)

	// Convert to proto response
	protoUserPermissions := make([]*openauth_v1.EffectivePermission, len(userPermissions))
	for i, up := range userPermissions {
		protoUserPermissions[i] = up.ToProtoUserEffectivePermission()
	}

	return &openauth_v1.ListUserPermissionsResponse{
		Permissions: protoUserPermissions,
	}, nil
}

// GetUserEffectivePermissions retrieves all effective permissions for a user
func (s *Service) GetUserEffectivePermissions(ctx context.Context, req *openauth_v1.GetUserEffectivePermissionsRequest) (*openauth_v1.GetUserEffectivePermissionsResponse, error) {
	logger.Debug(ctx, "Get user effective permissions requested: userID=%d", req.UserId)
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionPermissionsRead) {
		logger.Warn(ctx, "userID=%d does not have permission to read groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read groups")
	}

	logger.Debug(ctx, "Get user effective permissions initiated by userID=%d for targetUserID=%d", claims.UserID, req.UserId)

	// Validate input
	if req.UserId <= 0 {
		logger.Warn(ctx, "Get user effective permissions failed: invalid user_id=%d", req.UserId)
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}

	// Get effective permissions from repository
	permissions, err := s.repo.GetUserEffectivePermissions(ctx, req.UserId)
	if err != nil {
		logger.Error(ctx, "Failed to get user effective permissions: userID=%d: %v", req.UserId, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to get user effective permissions: %v", err))
	}

	logger.Debug(ctx, "Retrieved %d effective permissions for userID=%d", len(permissions), req.UserId)

	// Convert to proto response
	protoEffectivePermissions := make([]*openauth_v1.EffectivePermission, len(permissions))
	for i, p := range permissions {
		protoEffectivePermissions[i] = p.ToProtoUserEffectivePermission()
	}

	return &openauth_v1.GetUserEffectivePermissionsResponse{
		Permissions: protoEffectivePermissions,
	}, nil
}
