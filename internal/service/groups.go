package service

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// CreateGroup creates a new group in the system
func (s *Service) CreateGroup(ctx context.Context, req *openauth_v1.CreateGroupRequest) (*openauth_v1.CreateGroupResponse, error) {
	logger.Info(ctx, "Create group request initiated for name: %s", req.Name)
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "Create group failed: failed to get user from context for group: %s", req.Name)
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionGroupsCreate) {
		logger.Warn(ctx, "Create group failed: userID=%d does not have permission to create groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to create groups")
	}
	// Validate input
	if req.Name == "" {
		logger.Warn(ctx, "Create group failed: missing group name")
		return nil, status.Error(codes.InvalidArgument, "group name is required")
	}
	if req.DisplayName == "" {
		logger.Warn(ctx, "Create group failed: missing display name for group: %s", req.Name)
		return nil, status.Error(codes.InvalidArgument, "group display name is required")
	}

	// Normalize the name
	originalName := req.Name
	req.Name = strings.ToLower(strings.TrimSpace(req.Name))
	logger.Debug(ctx, "Normalized group name from '%s' to '%s'", originalName, req.Name)

	// Check if group name already exists
	exists, err := s.repo.CheckGroupNameExists(ctx, req.Name)
	if err != nil {
		logger.Error(ctx, "Failed to check group name availability for %s: %v", req.Name, err)
		return nil, status.Error(codes.Internal, "failed to check group name availability")
	}
	if exists {
		logger.Warn(ctx, "Create group failed: group name already exists: %s", req.Name)
		return nil, status.Error(codes.AlreadyExists, "group name already exists")
	}

	logger.Debug(ctx, "Group creation authorized by userID=%d for group: %s", claims.UserID, req.Name)

	// Create group DAO using the FromCreateGroupRequest method
	group := &dao.Group{}
	group.FromCreateGroupRequest(req, claims.UserID)

	// Create group in repository
	createdGroup, err := s.repo.CreateGroup(ctx, group)
	if err != nil {
		logger.Error(ctx, "Failed to create group %s by userID=%d: %v", req.Name, claims.UserID, err)
		return nil, status.Error(codes.Internal, "failed to create group")
	}

	logger.Info(ctx, "Group created successfully: ID=%d, name=%s, by userID=%d",
		createdGroup.ID, createdGroup.Name, claims.UserID)

	return &openauth_v1.CreateGroupResponse{
		Group:   createdGroup.ToProtoGroup(),
		Message: "Group created successfully",
	}, nil
}

// GetGroup retrieves a group by ID, UUID, or name
func (s *Service) GetGroup(ctx context.Context, req *openauth_v1.GetGroupRequest) (*openauth_v1.GetGroupResponse, error) {
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionGroupsRead) {
		logger.Warn(ctx, "userID=%d does not have permission to read groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read groups")
	}

	var group *dao.Group

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
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionGroupsRead) {
		logger.Warn(ctx, "userID=%d does not have permission to read groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read groups")
	}

	// Build filters from request
	filters := filter.FromListGroupsRequest(req)

	// Get groups from repository
	groups, err := s.repo.ListGroups(ctx, filters)
	if err != nil {
		logger.Error(ctx, "Failed to list groups: %v", err)
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
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionGroupsUpdate) {
		logger.Warn(ctx, "userID=%d does not have permission to update groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to update groups")
	}

	if req.Id == 0 {
		return nil, status.Error(codes.InvalidArgument, "group id is required")
	}

	// Get group to update
	group, err := s.repo.GetGroupByID(ctx, req.Id)
	if err != nil {
		logger.Error(ctx, "Failed to get group by ID=%d: %v", req.Id, err)
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
				logger.Error(ctx, "Failed to check group name availability: %v", err)
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
		logger.Error(ctx, "Failed to update group: %v", err)
		return nil, status.Error(codes.Internal, "failed to update group")
	}

	return &openauth_v1.UpdateGroupResponse{
		Group:   updatedGroup.ToProtoGroup(),
		Message: "Group updated successfully",
	}, nil
}

// DeleteGroup removes a group from the system
func (s *Service) DeleteGroup(ctx context.Context, req *openauth_v1.DeleteGroupRequest) (*openauth_v1.DeleteGroupResponse, error) {
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionGroupsDelete) {
		logger.Warn(ctx, "userID=%d does not have permission to delete groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to delete groups")
	}

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
		logger.Error(ctx, "Failed to delete group: %v", err)
		return nil, status.Error(codes.Internal, "failed to delete group")
	}

	return &openauth_v1.DeleteGroupResponse{
		Success: true,
		Message: "Group deleted successfully",
	}, nil
}

// AssignUserToGroup adds a user to a group
func (s *Service) AssignUsersToGroup(ctx context.Context, req *openauth_v1.AssignUsersToGroupRequest) (*openauth_v1.AssignUsersToGroupResponse, error) {
	logger.Debug(ctx, "AssignUsersToGroup request: userIDs=%v, groupID=%d", req.UserIds, req.GroupId)

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionGroupsAssign) {
		logger.Warn(ctx, "userID=%d does not have permission to assign users to groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to assign users to groups")
	}

	if len(req.UserIds) == 0 {
		logger.Warn(ctx, "AssignUsersToGroup failed: missing user IDs")
		return nil, status.Error(codes.InvalidArgument, "user ids are required")
	}
	if req.GroupId == 0 {
		logger.Warn(ctx, "AssignUsersToGroup failed: missing group ID")
		return nil, status.Error(codes.InvalidArgument, "group id is required")
	}

	logger.Debug(ctx, "User %s (userID=%d) assigning users %v to group %d",
		claims.UserUUID, claims.UserID, req.UserIds, req.GroupId)

	// Get all users currently in the group using bulk operation
	groupUsersFilter := &filter.GroupUsersFilter{
		GroupID: req.GroupId,
		Limit:   int32(len(req.UserIds) * 2), // Set a reasonable limit
		Offset:  0,
	}

	existingUsers, err := s.repo.ListGroupUsers(ctx, groupUsersFilter)
	if err != nil {
		logger.Error(ctx, "Failed to get existing group users for groupID=%d: %v", req.GroupId, err)
		return nil, status.Error(codes.Internal, "failed to check group membership")
	}

	// Create a map of existing user IDs for efficient lookup
	existingUserMap := make(map[int64]bool)
	for _, user := range existingUsers {
		existingUserMap[user.ID] = true
	}

	// Filter out users who are already in the group
	var usersToAssign []int64
	var alreadyInGroup []int64

	for _, userID := range req.UserIds {
		if existingUserMap[userID] {
			alreadyInGroup = append(alreadyInGroup, userID)
		} else {
			usersToAssign = append(usersToAssign, userID)
		}
	}

	if len(alreadyInGroup) > 0 {
		logger.Warn(ctx, "Some users are already in group %d: %v", req.GroupId, alreadyInGroup)
	}

	if len(usersToAssign) == 0 {
		logger.Info(ctx, "All users are already in group %d", req.GroupId)
		return &openauth_v1.AssignUsersToGroupResponse{
			Success: true,
			Message: "All users are already in the group",
		}, nil
	}

	// Assign users to group using bulk operation
	err = s.repo.AssignUsersToGroup(ctx, usersToAssign, req.GroupId, claims.UserID, req.ExpiresAt)
	if err != nil {
		logger.Error(ctx, "Failed to assign userIDs=%v to groupID=%d, assignedBy=%d: %v",
			usersToAssign, req.GroupId, claims.UserID, err)
		return nil, status.Error(codes.Internal, "failed to assign users to group")
	}

	logger.Info(ctx, "User assignment successful: userIDs=%v assigned to groupID=%d by userID=%d",
		usersToAssign, req.GroupId, claims.UserID)

	message := fmt.Sprintf("Successfully assigned %d users to group", len(usersToAssign))
	if len(alreadyInGroup) > 0 {
		message += fmt.Sprintf(" (%d users were already in the group)", len(alreadyInGroup))
	}

	return &openauth_v1.AssignUsersToGroupResponse{
		Success: true,
		Message: message,
	}, nil
}

// RemoveUsersFromGroup removes multiple users from a group
func (s *Service) RemoveUsersFromGroup(ctx context.Context, req *openauth_v1.RemoveUsersFromGroupRequest) (*openauth_v1.RemoveUsersFromGroupResponse, error) {
	logger.Debug(ctx, "RemoveUsersFromGroup request: userIDs=%v, groupID=%d", req.UserIds, req.GroupId)

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionGroupsRevoke) {
		logger.Warn(ctx, "userID=%d does not have permission to revoke users from groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to revoke users from groups")
	}

	if len(req.UserIds) == 0 {
		logger.Warn(ctx, "RemoveUsersFromGroup failed: missing user IDs")
		return nil, status.Error(codes.InvalidArgument, "user ids are required")
	}
	if req.GroupId == 0 {
		logger.Warn(ctx, "RemoveUsersFromGroup failed: missing group ID")
		return nil, status.Error(codes.InvalidArgument, "group id is required")
	}

	logger.Debug(ctx, "User %s (userID=%d) removing users %v from group %d",
		claims.UserUUID, claims.UserID, req.UserIds, req.GroupId)

	// Get all users currently in the group using bulk operation
	groupUsersFilter := &filter.GroupUsersFilter{
		GroupID: req.GroupId,
		Limit:   int32(len(req.UserIds) * 2), // Set a reasonable limit
		Offset:  0,
	}

	existingUsers, err := s.repo.ListGroupUsers(ctx, groupUsersFilter)
	if err != nil {
		logger.Error(ctx, "Failed to get existing group users for groupID=%d: %v", req.GroupId, err)
		return nil, status.Error(codes.Internal, "failed to check group membership")
	}

	// Create a map of existing user IDs for efficient lookup
	existingUserMap := make(map[int64]bool)
	for _, user := range existingUsers {
		existingUserMap[user.ID] = true
	}

	// Filter out users who are not in the group
	var usersToRemove []int64
	var notInGroup []int64

	for _, userID := range req.UserIds {
		if !existingUserMap[userID] {
			notInGroup = append(notInGroup, userID)
		} else {
			usersToRemove = append(usersToRemove, userID)
		}
	}

	if len(notInGroup) > 0 {
		logger.Warn(ctx, "Some users are not in group %d: %v", req.GroupId, notInGroup)
	}

	if len(usersToRemove) == 0 {
		logger.Info(ctx, "No users to remove from group %d", req.GroupId)
		return &openauth_v1.RemoveUsersFromGroupResponse{
			Success: true,
			Message: "No users were in the group to remove",
		}, nil
	}

	// Remove users from group using bulk operation
	err = s.repo.RemoveUsersFromGroup(ctx, usersToRemove, req.GroupId)
	if err != nil {
		logger.Error(ctx, "Failed to remove userIDs=%v from groupID=%d: %v",
			usersToRemove, req.GroupId, err)
		return nil, status.Error(codes.Internal, "failed to remove users from group")
	}

	logger.Info(ctx, "User removal successful: userIDs=%v removed from groupID=%d by userID=%d",
		usersToRemove, req.GroupId, claims.UserID)

	message := fmt.Sprintf("Successfully removed %d users from group", len(usersToRemove))
	if len(notInGroup) > 0 {
		message += fmt.Sprintf(" (%d users were not in the group)", len(notInGroup))
	}

	return &openauth_v1.RemoveUsersFromGroupResponse{
		Success: true,
		Message: message,
	}, nil
}

// ListGroupUsers retrieves all users in a specific group
func (s *Service) ListGroupUsers(ctx context.Context, req *openauth_v1.ListGroupUsersRequest) (*openauth_v1.ListGroupUsersResponse, error) {
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionGroupsRead) {
		logger.Warn(ctx, "userID=%d does not have permission to read groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read groups")
	}

	if req.GroupId == 0 {
		return nil, status.Error(codes.InvalidArgument, "group id is required")
	}

	// Get users from repository
	filters := filter.NewGroupUsersFilter(req)
	users, err := s.repo.ListGroupUsers(ctx, filters)
	if err != nil {
		logger.Error(ctx, "Failed to list group users: %v", err)
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
	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}
	// check for permissions
	if !claims.HasPermission(constants.PermissionGroupsRead) {
		logger.Warn(ctx, "userID=%d does not have permission to read groups", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read groups")
	}

	if req.UserId == 0 {
		return nil, status.Error(codes.InvalidArgument, "user id is required")
	}

	// Set default pagination
	limit := req.Limit
	if limit <= 0 || limit > 100 {
		limit = constants.DefaultPageSize
	}
	offset := req.Offset
	if offset < 0 {
		offset = 0
	}

	// Get groups from repository
	filters := filter.NewUserGroupsFilter(req)
	groups, err := s.repo.ListUserGroups(ctx, filters)
	if err != nil {
		logger.Error(ctx, "Failed to list user groups: %v", err)
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
