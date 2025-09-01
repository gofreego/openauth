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
)

// AssignPermissionToGroup assigns a permission to a group
func (s *Service) AssignPermissionToGroup(ctx context.Context, req *openauth_v1.AssignPermissionToGroupRequest) (*openauth_v1.AssignPermissionToGroupResponse, error) {
	// Extract user claims from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	// Validate input
	if req.GroupId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "group_id must be greater than 0")
	}
	if req.PermissionId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "permission_id must be greater than 0")
	}

	// Assign permission to group
	groupPermission, err := s.repo.AssignPermissionToGroup(ctx, req.GroupId, req.PermissionId, claims.UserID)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to assign permission to group: %v", err))
	}

	return &openauth_v1.AssignPermissionToGroupResponse{
		GroupPermission: groupPermission.ToProtoGroupPermission(),
		Message:         "Permission successfully assigned to group",
	}, nil
}

// RemovePermissionFromGroup removes a permission from a group
func (s *Service) RemovePermissionFromGroup(ctx context.Context, req *openauth_v1.RemovePermissionFromGroupRequest) (*openauth_v1.RemovePermissionFromGroupResponse, error) {
	// Extract user claims from context
	_, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	// Validate input
	if req.GroupId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "group_id must be greater than 0")
	}
	if req.PermissionId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "permission_id must be greater than 0")
	}

	// Remove permission from group
	err = s.repo.RemovePermissionFromGroup(ctx, req.GroupId, req.PermissionId)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to remove permission from group: %v", err))
	}

	return &openauth_v1.RemovePermissionFromGroupResponse{
		Success: true,
		Message: "Permission successfully removed from group",
	}, nil
}

// ListGroupPermissions retrieves permissions assigned to a group
func (s *Service) ListGroupPermissions(ctx context.Context, req *openauth_v1.ListGroupPermissionsRequest) (*openauth_v1.ListGroupPermissionsResponse, error) {
	// Extract user claims from context
	_, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	// Validate input
	if req.GroupId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "group_id must be greater than 0")
	}

	// Build filters from request
	filters := filter.FromListGroupPermissionsRequest(req)

	// Get group permissions from repository
	groupPermissions, err := s.repo.ListGroupPermissions(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list group permissions: %v", err))
	}

	// Convert to proto response
	protoGroupPermissions := make([]*openauth_v1.GroupPermission, len(groupPermissions))
	for i, gp := range groupPermissions {
		protoGroupPermissions[i] = gp.ToProtoGroupPermission()
	}

	return &openauth_v1.ListGroupPermissionsResponse{
		Permissions: protoGroupPermissions,
		Limit:       filters.Limit,
		Offset:      filters.Offset,
		Total:       int32(len(protoGroupPermissions)), // TODO: Implement proper total count
	}, nil
}

// AssignPermissionToUser assigns a permission directly to a user
func (s *Service) AssignPermissionToUser(ctx context.Context, req *openauth_v1.AssignPermissionToUserRequest) (*openauth_v1.AssignPermissionToUserResponse, error) {
	// Extract user claims from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	// Validate input
	if req.UserId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}
	if req.PermissionId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "permission_id must be greater than 0")
	}

	// Validate expiration time if provided
	if req.ExpiresAt != nil && *req.ExpiresAt <= time.Now().Unix() {
		return nil, status.Error(codes.InvalidArgument, "expires_at must be in the future")
	}

	// Assign permission to user
	userPermission, err := s.repo.AssignPermissionToUser(ctx, req.UserId, req.PermissionId, claims.UserID, req.ExpiresAt)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to assign permission to user: %v", err))
	}

	return &openauth_v1.AssignPermissionToUserResponse{
		UserPermission: userPermission.ToProtoUserPermission(),
		Message:        "Permission successfully assigned to user",
	}, nil
}

// RemovePermissionFromUser removes a permission directly assigned to a user
func (s *Service) RemovePermissionFromUser(ctx context.Context, req *openauth_v1.RemovePermissionFromUserRequest) (*openauth_v1.RemovePermissionFromUserResponse, error) {
	// Extract user claims from context
	_, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	// Validate input
	if req.UserId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}
	if req.PermissionId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "permission_id must be greater than 0")
	}

	// Remove permission from user
	err = s.repo.RemovePermissionFromUser(ctx, req.UserId, req.PermissionId)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to remove permission from user: %v", err))
	}

	return &openauth_v1.RemovePermissionFromUserResponse{
		Success: true,
		Message: "Permission successfully removed from user",
	}, nil
}

// ListUserPermissions retrieves permissions directly assigned to a user
func (s *Service) ListUserPermissions(ctx context.Context, req *openauth_v1.ListUserPermissionsRequest) (*openauth_v1.ListUserPermissionsResponse, error) {
	// Extract user claims from context
	_, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	// Validate input
	if req.UserId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}

	// Build filters from request
	filters := filter.FromListUserPermissionsRequest(req)

	// Get user permissions from repository
	userPermissions, err := s.repo.ListUserPermissions(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list user permissions: %v", err))
	}

	// Convert to proto response
	protoUserPermissions := make([]*openauth_v1.UserPermission, len(userPermissions))
	for i, up := range userPermissions {
		protoUserPermissions[i] = up.ToProtoUserPermission()
	}

	return &openauth_v1.ListUserPermissionsResponse{
		Permissions: protoUserPermissions,
		Limit:       filters.Limit,
		Offset:      filters.Offset,
		Total:       int32(len(protoUserPermissions)), // TODO: Implement proper total count
	}, nil
}

// GetUserEffectivePermissions retrieves all effective permissions for a user
func (s *Service) GetUserEffectivePermissions(ctx context.Context, req *openauth_v1.GetUserEffectivePermissionsRequest) (*openauth_v1.GetUserEffectivePermissionsResponse, error) {
	// Extract user claims from context
	_, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "invalid or missing token")
	}

	// Validate input
	if req.UserId <= 0 {
		return nil, status.Error(codes.InvalidArgument, "user_id must be greater than 0")
	}

	// Build filters from request
	filters := filter.FromGetUserEffectivePermissionsRequest(req)

	// Get effective permissions from repository
	permissions, err := s.repo.GetUserEffectivePermissions(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to get user effective permissions: %v", err))
	}

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
		Limit:       filters.Limit,
		Offset:      filters.Offset,
		Total:       int32(len(protoEffectivePermissions)), // TODO: Implement proper total count
	}, nil
}
