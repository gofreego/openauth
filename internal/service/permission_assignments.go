package service

import (
	"context"
	"fmt"
	"time"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"github.com/gofreego/goutils/logger"
)

// AssignPermissionToGroup assigns a permission to a group
func (s *Service) AssignPermissionToGroup(ctx context.Context, req *openauth_v1.AssignPermissionToGroupRequest) (*openauth_v1.AssignPermissionToGroupResponse, error) {
	logger.Info(ctx, "Permission assignment to group requested: groupID=%d, permissionID=%d", req.GroupId, req.PermissionId)
	
	// Extract user claims from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "Permission assignment failed: invalid or missing token for groupID=%d, permissionID=%d", req.GroupId, req.PermissionId)
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	logger.Debug(ctx, "Permission assignment initiated by userID=%d for groupID=%d, permissionID=%d", claims.UserID, req.GroupId, req.PermissionId)

	// Validate input
	if req.GroupId <= 0 {
		logger.Warn(ctx, "Permission assignment failed: invalid group_id=%d", req.GroupId)
		return nil, status.Error(codes.InvalidArgument, "group_id must be greater than 0")
	}
	if req.PermissionId <= 0 {
		logger.Warn(ctx, "Permission assignment failed: invalid permission_id=%d", req.PermissionId)
		return nil, status.Error(codes.InvalidArgument, "permission_id must be greater than 0")
	}

	// Assign permission to group
	groupPermission, err := s.repo.AssignPermissionToGroup(ctx, req.GroupId, req.PermissionId, claims.UserID)
	if err != nil {
		logger.Error(ctx, "Failed to assign permission to group: groupID=%d, permissionID=%d, grantedBy=%d: %v", 
			req.GroupId, req.PermissionId, claims.UserID, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to assign permission to group: %v", err))
	}

	logger.Info(ctx, "Permission successfully assigned to group: groupID=%d, permissionID=%d, grantedBy=%d", 
		req.GroupId, req.PermissionId, claims.UserID)

	return &openauth_v1.AssignPermissionToGroupResponse{
		GroupPermission: groupPermission.ToProtoGroupPermission(),
		Message:         "Permission successfully assigned to group",
	}, nil
}

// RemovePermissionFromGroup removes a permission from a group
func (s *Service) RemovePermissionFromGroup(ctx context.Context, req *openauth_v1.RemovePermissionFromGroupRequest) (*openauth_v1.RemovePermissionFromGroupResponse, error) {
	logger.Info(ctx, "Permission removal from group requested: groupID=%d, permissionID=%d", req.GroupId, req.PermissionId)
	
	// Extract user claims from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "Permission removal failed: invalid or missing token for groupID=%d, permissionID=%d", req.GroupId, req.PermissionId)
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	logger.Debug(ctx, "Permission removal initiated by userID=%d for groupID=%d, permissionID=%d", claims.UserID, req.GroupId, req.PermissionId)

	// Validate input
	if req.GroupId <= 0 {
		logger.Warn(ctx, "Permission removal failed: invalid group_id=%d", req.GroupId)
		return nil, status.Error(codes.InvalidArgument, "group_id must be greater than 0")
	}
	if req.PermissionId <= 0 {
		logger.Warn(ctx, "Permission removal failed: invalid permission_id=%d", req.PermissionId)
		return nil, status.Error(codes.InvalidArgument, "permission_id must be greater than 0")
	}

	// Remove permission from group
	err = s.repo.RemovePermissionFromGroup(ctx, req.GroupId, req.PermissionId)
	if err != nil {
		logger.Error(ctx, "Failed to remove permission from group: groupID=%d, permissionID=%d: %v", 
			req.GroupId, req.PermissionId, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to remove permission from group: %v", err))
	}

	logger.Info(ctx, "Permission successfully removed from group: groupID=%d, permissionID=%d", 
		req.GroupId, req.PermissionId)

	return &openauth_v1.RemovePermissionFromGroupResponse{
		Success: true,
		Message: "Permission successfully removed from group",
	}, nil
}

// ListGroupPermissions retrieves permissions assigned to a group
func (s *Service) ListGroupPermissions(ctx context.Context, req *openauth_v1.ListGroupPermissionsRequest) (*openauth_v1.ListGroupPermissionsResponse, error) {
	logger.Debug(ctx, "List group permissions requested: groupID=%d", req.GroupId)
	
	// Extract user claims from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "List group permissions failed: invalid or missing token for groupID=%d", req.GroupId)
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	logger.Debug(ctx, "List group permissions initiated by userID=%d for groupID=%d", claims.UserID, req.GroupId)

	// Validate input
	if req.GroupId <= 0 {
		logger.Warn(ctx, "List group permissions failed: invalid group_id=%d", req.GroupId)
		return nil, status.Error(codes.InvalidArgument, "group_id must be greater than 0")
	}

	// Build filters from request
	filters := filter.FromListGroupPermissionsRequest(req)

	// Get group permissions from repository
	groupPermissions, err := s.repo.ListGroupPermissions(ctx, filters)
	if err != nil {
		logger.Error(ctx, "Failed to list group permissions: groupID=%d: %v", req.GroupId, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list group permissions: %v", err))
	}

	logger.Debug(ctx, "Retrieved %d permissions for groupID=%d", len(groupPermissions), req.GroupId)

	// Convert to proto response
	protoGroupPermissions := make([]*openauth_v1.GroupPermission, len(groupPermissions))
	for i, gp := range groupPermissions {
		protoGroupPermissions[i] = gp.ToProtoGroupPermission()
	}

	return &openauth_v1.ListGroupPermissionsResponse{
		Permissions: protoGroupPermissions,
	}, nil
}

// AssignPermissionToUser assigns a permission directly to a user
func (s *Service) AssignPermissionToUser(ctx context.Context, req *openauth_v1.AssignPermissionToUserRequest) (*openauth_v1.AssignPermissionToUserResponse, error) {
	logger.Info(ctx, "Permission assignment to user requested: userID=%d, permissionID=%d", req.UserId, req.PermissionId)
	
	// Extract user claims from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "Permission assignment failed: invalid or missing token for userID=%d, permissionID=%d", req.UserId, req.PermissionId)
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	logger.Debug(ctx, "Permission assignment initiated by userID=%d for targetUserID=%d, permissionID=%d", claims.UserID, req.UserId, req.PermissionId)

	// Validate input
	if req.UserId <= 0 {
		logger.Warn(ctx, "Permission assignment failed: invalid user_id=%d", req.UserId)
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}
	if req.PermissionId <= 0 {
		logger.Warn(ctx, "Permission assignment failed: invalid permission_id=%d", req.PermissionId)
		return nil, status.Error(codes.InvalidArgument, "permission_id must be greater than 0")
	}

	// Validate expiration time if provided
	if req.ExpiresAt != nil && *req.ExpiresAt <= time.Now().Unix() {
		logger.Warn(ctx, "Permission assignment failed: expires_at is in the past: userID=%d, permissionID=%d, expires_at=%d", 
			req.UserId, req.PermissionId, *req.ExpiresAt)
		return nil, status.Error(codes.InvalidArgument, "expires_at must be in the future")
	}

	// Assign permission to user
	userPermission, err := s.repo.AssignPermissionToUser(ctx, req.UserId, req.PermissionId, claims.UserID, req.ExpiresAt)
	if err != nil {
		logger.Error(ctx, "Failed to assign permission to user: userID=%d, permissionID=%d, grantedBy=%d: %v", 
			req.UserId, req.PermissionId, claims.UserID, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to assign permission to user: %v", err))
	}

	logger.Info(ctx, "Permission successfully assigned to user: userID=%d, permissionID=%d, grantedBy=%d", 
		req.UserId, req.PermissionId, claims.UserID)

	return &openauth_v1.AssignPermissionToUserResponse{
		UserPermission: userPermission.ToProtoUserPermission(),
		Message:        "Permission successfully assigned to user",
	}, nil
}

// RemovePermissionFromUser removes a permission directly assigned to a user
func (s *Service) RemovePermissionFromUser(ctx context.Context, req *openauth_v1.RemovePermissionFromUserRequest) (*openauth_v1.RemovePermissionFromUserResponse, error) {
	logger.Info(ctx, "Permission removal from user requested: userID=%d, permissionID=%d", req.UserId, req.PermissionId)
	
	// Extract user claims from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "Permission removal failed: invalid or missing token for userID=%d, permissionID=%d", req.UserId, req.PermissionId)
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	logger.Debug(ctx, "Permission removal initiated by userID=%d for targetUserID=%d, permissionID=%d", claims.UserID, req.UserId, req.PermissionId)

	// Validate input
	if req.UserId <= 0 {
		logger.Warn(ctx, "Permission removal failed: invalid user_id=%d", req.UserId)
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}
	if req.PermissionId <= 0 {
		logger.Warn(ctx, "Permission removal failed: invalid permission_id=%d", req.PermissionId)
		return nil, status.Error(codes.InvalidArgument, "permission_id must be greater than 0")
	}

	// Remove permission from user
	err = s.repo.RemovePermissionFromUser(ctx, req.UserId, req.PermissionId)
	if err != nil {
		logger.Error(ctx, "Failed to remove permission from user: userID=%d, permissionID=%d: %v", 
			req.UserId, req.PermissionId, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to remove permission from user: %v", err))
	}

	logger.Info(ctx, "Permission successfully removed from user: userID=%d, permissionID=%d", 
		req.UserId, req.PermissionId)

	return &openauth_v1.RemovePermissionFromUserResponse{
		Success: true,
		Message: "Permission successfully removed from user",
	}, nil
}

// ListUserPermissions retrieves permissions directly assigned to a user
func (s *Service) ListUserPermissions(ctx context.Context, req *openauth_v1.ListUserPermissionsRequest) (*openauth_v1.ListUserPermissionsResponse, error) {
	logger.Debug(ctx, "List user permissions requested: userID=%d", req.UserId)
	
	// Extract user claims from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "List user permissions failed: invalid or missing token for userID=%d", req.UserId)
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	logger.Debug(ctx, "List user permissions initiated by userID=%d for targetUserID=%d", claims.UserID, req.UserId)

	// Validate input
	if req.UserId <= 0 {
		logger.Warn(ctx, "List user permissions failed: invalid user_id=%d", req.UserId)
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}

	// Build filters from request
	filters := filter.FromListUserPermissionsRequest(req)

	// Get user permissions from repository
	userPermissions, err := s.repo.ListUserPermissions(ctx, filters)
	if err != nil {
		logger.Error(ctx, "Failed to list user permissions: userID=%d: %v", req.UserId, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list user permissions: %v", err))
	}

	logger.Debug(ctx, "Retrieved %d permissions for userID=%d", len(userPermissions), req.UserId)

	// Convert to proto response
	protoUserPermissions := make([]*openauth_v1.UserPermission, len(userPermissions))
	for i, up := range userPermissions {
		protoUserPermissions[i] = up.ToProtoUserPermission()
	}

	return &openauth_v1.ListUserPermissionsResponse{
		Permissions: protoUserPermissions,
	}, nil
}

// GetUserEffectivePermissions retrieves all effective permissions for a user
func (s *Service) GetUserEffectivePermissions(ctx context.Context, req *openauth_v1.GetUserEffectivePermissionsRequest) (*openauth_v1.GetUserEffectivePermissionsResponse, error) {
	logger.Debug(ctx, "Get user effective permissions requested: userID=%d", req.UserId)
	
	// Extract user claims from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "Get user effective permissions failed: invalid or missing token for userID=%d", req.UserId)
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	logger.Debug(ctx, "Get user effective permissions initiated by userID=%d for targetUserID=%d", claims.UserID, req.UserId)

	// Validate input
	if req.UserId <= 0 {
		logger.Warn(ctx, "Get user effective permissions failed: invalid user_id=%d", req.UserId)
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}

	// Build filters from request
	filters := filter.FromGetUserEffectivePermissionsRequest(req)

	// Get effective permissions from repository
	permissions, err := s.repo.GetUserEffectivePermissions(ctx, filters)
	if err != nil {
		logger.Error(ctx, "Failed to get user effective permissions: userID=%d: %v", req.UserId, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to get user effective permissions: %v", err))
	}

	logger.Debug(ctx, "Retrieved %d effective permissions for userID=%d", len(permissions), req.UserId)

	// Convert to proto response
	protoEffectivePermissions := make([]*openauth_v1.EffectivePermission, len(permissions))
	for i, p := range permissions {
		// For now, we'll mark all as "direct" or "group" based on simple logic
		// In a more complete implementation, you'd need to query the source
		protoEffectivePermissions[i] = &openauth_v1.EffectivePermission{
			PermissionId:          p.ID,
			PermissionName:        p.Name,
			PermissionDisplayName: p.DisplayName,
			PermissionDescription: p.Description,
			Source:                "effective", // Simplified for now
			GrantedAt:             p.CreatedAt,
			GrantedBy:             p.CreatedBy,
		}
	}

	return &openauth_v1.GetUserEffectivePermissionsResponse{
		Permissions: protoEffectivePermissions,
	}, nil
}
