package service

import (
	"context"
	"strings"
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// CreateGroup creates a new group in the system
func (s *Service) CreateGroup(ctx context.Context, req *openauth_v1.CreateGroupRequest) (*openauth_v1.CreateGroupResponse, error) {
	// Validate input
	if req.Name == "" {
		return nil, status.Error(codes.InvalidArgument, "group name is required")
	}
	if req.DisplayName == "" {
		return nil, status.Error(codes.InvalidArgument, "group display name is required")
	}

	// Normalize the name
	req.Name = strings.ToLower(strings.TrimSpace(req.Name))

	// Check if group name already exists
	exists, err := s.repo.CheckGroupNameExists(ctx, req.Name)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to check group name availability")
	}
	if exists {
		return nil, status.Error(codes.AlreadyExists, "group name already exists")
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Create group DAO using the FromCreateGroupRequest method
	group := &dao.Group{}
	group.FromCreateGroupRequest(req, claims.UserID)

	// Create group in repository
	createdGroup, err := s.repo.CreateGroup(ctx, group)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to create group")
	}

	return &openauth_v1.CreateGroupResponse{
		Group:   createdGroup.ToProtoGroup(),
		Message: "Group created successfully",
	}, nil
}

// GetGroup retrieves a group by ID, UUID, or name
func (s *Service) GetGroup(ctx context.Context, req *openauth_v1.GetGroupRequest) (*openauth_v1.GetGroupResponse, error) {
	var group *dao.Group
	var err error

	if req.Id <= 0 {
		return nil, status.Error(codes.InvalidArgument, "group ID is required")
	}

	group, err = s.repo.GetGroupByID(ctx, req.Id)

	if err != nil {
		return nil, status.Error(codes.NotFound, "group not found")
	}

	return &openauth_v1.GetGroupResponse{
		Group: group.ToProtoGroup(),
	}, nil
}

// ListGroups retrieves groups with filtering and pagination
func (s *Service) ListGroups(ctx context.Context, req *openauth_v1.ListGroupsRequest) (*openauth_v1.ListGroupsResponse, error) {
	// Build filters from request
	filters := filter.FromListGroupsRequest(req)

	// Get groups from repository
	groups, err := s.repo.ListGroups(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to list groups")
	}

	// Convert to protobuf
	protoGroups := make([]*openauth_v1.Group, len(groups))
	for i, group := range groups {
		protoGroups[i] = group.ToProtoGroup()
	}

	return &openauth_v1.ListGroupsResponse{
		Groups: protoGroups,
	}, nil
}

// UpdateGroup modifies an existing group
func (s *Service) UpdateGroup(ctx context.Context, req *openauth_v1.UpdateGroupRequest) (*openauth_v1.UpdateGroupResponse, error) {
	if req.Id == 0 {
		return nil, status.Error(codes.InvalidArgument, "group id is required")
	}

	// Get group to update
	group, err := s.repo.GetGroupByID(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.NotFound, "group not found")
	}

	// Check if it's a system group
	if group.IsSystem {
		return nil, status.Error(codes.PermissionDenied, "system groups cannot be modified")
	}

	// Build updates map
	updates := make(map[string]interface{})

	if req.NewName != nil && *req.NewName != "" {
		newName := strings.ToLower(strings.TrimSpace(*req.NewName))
		if newName != group.Name {
			// Check if new name already exists
			exists, err := s.repo.CheckGroupNameExists(ctx, newName)
			if err != nil {
				return nil, status.Error(codes.Internal, "failed to check group name availability")
			}
			if exists {
				return nil, status.Error(codes.AlreadyExists, "group name already exists")
			}
			updates["name"] = newName
		}
	}

	if req.DisplayName != nil {
		updates["display_name"] = *req.DisplayName
	}

	if req.Description != nil {
		updates["description"] = *req.Description
	}

	// Note: IsDefault field doesn't exist in UpdateGroupRequest

	if len(updates) == 0 {
		return &openauth_v1.UpdateGroupResponse{
			Group:   group.ToProtoGroup(),
			Message: "No changes to update",
		}, nil
	}

	updates["updated_at"] = time.Now().Unix()

	// Update group in repository
	updatedGroup, err := s.repo.UpdateGroup(ctx, group.ID, updates)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to update group")
	}

	return &openauth_v1.UpdateGroupResponse{
		Group:   updatedGroup.ToProtoGroup(),
		Message: "Group updated successfully",
	}, nil
}

// DeleteGroup removes a group from the system
func (s *Service) DeleteGroup(ctx context.Context, req *openauth_v1.DeleteGroupRequest) (*openauth_v1.DeleteGroupResponse, error) {
	if req.Id == 0 {
		return nil, status.Error(codes.InvalidArgument, "group id is required")
	}

	// Get group to delete
	group, err := s.repo.GetGroupByID(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.NotFound, "group not found")
	}

	// Check if it's a system group
	if group.IsSystem {
		return nil, status.Error(codes.PermissionDenied, "system groups cannot be deleted")
	}

	// Delete group from repository
	err = s.repo.DeleteGroup(ctx, group.ID)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to delete group")
	}

	return &openauth_v1.DeleteGroupResponse{
		Success: true,
		Message: "Group deleted successfully",
	}, nil
}

// AssignUserToGroup adds a user to a group
func (s *Service) AssignUserToGroup(ctx context.Context, req *openauth_v1.AssignUserToGroupRequest) (*openauth_v1.AssignUserToGroupResponse, error) {
	if req.UserId == 0 {
		return nil, status.Error(codes.InvalidArgument, "user id is required")
	}
	if req.GroupId == 0 {
		return nil, status.Error(codes.InvalidArgument, "group id is required")
	}

	// Check if user is already in the group
	isInGroup, err := s.repo.IsUserInGroup(ctx, req.UserId, req.GroupId)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to check group membership")
	}
	if isInGroup {
		return nil, status.Error(codes.AlreadyExists, "user is already in the group")
	}

	// Assign user to group
	err = s.repo.AssignUserToGroup(ctx, req.UserId, req.GroupId, nil, req.ExpiresAt)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to assign user to group")
	}

	return &openauth_v1.AssignUserToGroupResponse{
		Success: true,
		Message: "User assigned to group successfully",
	}, nil
}

// RemoveUserFromGroup removes a user from a group
func (s *Service) RemoveUserFromGroup(ctx context.Context, req *openauth_v1.RemoveUserFromGroupRequest) (*openauth_v1.RemoveUserFromGroupResponse, error) {
	if req.UserId == 0 {
		return nil, status.Error(codes.InvalidArgument, "user id is required")
	}
	if req.GroupId == 0 {
		return nil, status.Error(codes.InvalidArgument, "group id is required")
	}

	// Check if user is in the group
	isInGroup, err := s.repo.IsUserInGroup(ctx, req.UserId, req.GroupId)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to check group membership")
	}
	if !isInGroup {
		return nil, status.Error(codes.NotFound, "user is not in the group")
	}

	// Remove user from group
	err = s.repo.RemoveUserFromGroup(ctx, req.UserId, req.GroupId)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to remove user from group")
	}

	return &openauth_v1.RemoveUserFromGroupResponse{
		Success: true,
		Message: "User removed from group successfully",
	}, nil
}

// ListGroupUsers retrieves all users in a specific group
func (s *Service) ListGroupUsers(ctx context.Context, req *openauth_v1.ListGroupUsersRequest) (*openauth_v1.ListGroupUsersResponse, error) {
	if req.GroupId == 0 {
		return nil, status.Error(codes.InvalidArgument, "group id is required")
	}

	// Set default pagination
	limit := req.Limit
	if limit <= 0 || limit > 100 {
		limit = 10
	}
	offset := req.Offset
	if offset < 0 {
		offset = 0
	}

	// Get users from repository
	filters := filter.NewGroupUsersFilter(req.GroupId, limit, offset)
	users, err := s.repo.ListGroupUsers(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to list group users")
	}

	// Convert to protobuf - for now, we'll return basic user info
	// In a more complete implementation, we'd have a specific query for group users with membership details
	protoUsers := make([]*openauth_v1.GroupUser, len(users))
	for i, user := range users {
		protoUsers[i] = user.ToProtoGroupUser(user.CreatedAt) // This would be the actual assignment timestamp in a full implementation
	}

	return &openauth_v1.ListGroupUsersResponse{
		Users: protoUsers,
	}, nil
}

// ListUserGroups retrieves all groups for a specific user
func (s *Service) ListUserGroups(ctx context.Context, req *openauth_v1.ListUserGroupsRequest) (*openauth_v1.ListUserGroupsResponse, error) {
	if req.UserId == 0 {
		return nil, status.Error(codes.InvalidArgument, "user id is required")
	}

	// Set default pagination
	limit := req.Limit
	if limit <= 0 || limit > 100 {
		limit = 10
	}
	offset := req.Offset
	if offset < 0 {
		offset = 0
	}

	// Get groups from repository
	filters := filter.NewUserGroupsFilter(req.UserId, limit, offset)
	groups, err := s.repo.ListUserGroups(ctx, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to list user groups")
	}

	// Convert to protobuf - for now, we'll return basic group info
	// In a more complete implementation, we'd have a specific query for user groups with membership details
	protoGroups := make([]*openauth_v1.UserGroup, len(groups))
	for i, group := range groups {
		protoGroups[i] = group.ToProtoUserGroup(group.CreatedAt) // This would be the actual assignment timestamp in a full implementation
	}

	return &openauth_v1.ListUserGroupsResponse{
		Groups: protoGroups,
	}, nil
}
