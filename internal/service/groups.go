package service

import (
	"context"
	"strings"
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/models/dao"
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

	// Create group DAO
	group := &dao.Group{
		Name:        req.Name,
		DisplayName: req.DisplayName,
		IsSystem:    false, // User-created groups are not system groups
		IsDefault:   req.IsDefault != nil && *req.IsDefault,
		CreatedAt:   time.Now().Unix(),
		UpdatedAt:   time.Now().Unix(),
	}

	if req.Description != nil {
		group.Description = req.Description
	}

	// Create group in repository
	createdGroup, err := s.repo.CreateGroup(ctx, group)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to create group")
	}

	return &openauth_v1.CreateGroupResponse{
		Group:   createdGroup.ToProto(),
		Message: "Group created successfully",
	}, nil
}

// GetGroup retrieves a group by ID, UUID, or name
func (s *Service) GetGroup(ctx context.Context, req *openauth_v1.GetGroupRequest) (*openauth_v1.GetGroupResponse, error) {
	var group *dao.Group
	var err error

	switch identifier := req.Identifier.(type) {
	case *openauth_v1.GetGroupRequest_Id:
		group, err = s.repo.GetGroupByID(ctx, identifier.Id)
	case *openauth_v1.GetGroupRequest_Uuid:
		group, err = s.repo.GetGroupByUUID(ctx, identifier.Uuid)
	case *openauth_v1.GetGroupRequest_Name:
		group, err = s.repo.GetGroupByName(ctx, identifier.Name)
	default:
		return nil, status.Error(codes.InvalidArgument, "group identifier is required")
	}

	if err != nil {
		return nil, status.Error(codes.NotFound, "group not found")
	}

	return &openauth_v1.GetGroupResponse{
		Group: group.ToProto(),
	}, nil
}

// ListGroups retrieves groups with filtering and pagination
func (s *Service) ListGroups(ctx context.Context, req *openauth_v1.ListGroupsRequest) (*openauth_v1.ListGroupsResponse, error) {
	// Set default pagination
	limit := req.Limit
	if limit <= 0 || limit > 100 {
		limit = 10
	}
	offset := req.Offset
	if offset < 0 {
		offset = 0
	}

	// Build filters
	filters := make(map[string]interface{})
	if req.Search != nil && *req.Search != "" {
		filters["search"] = *req.Search
	}
	if req.IsSystem != nil {
		filters["is_system"] = *req.IsSystem
	}
	if req.IsDefault != nil {
		filters["is_default"] = *req.IsDefault
	}

	// Get groups from repository
	groups, totalCount, err := s.repo.ListGroups(ctx, limit, offset, filters)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to list groups")
	}

	// Convert to protobuf
	protoGroups := make([]*openauth_v1.Group, len(groups))
	for i, group := range groups {
		protoGroups[i] = group.ToProto()
	}

	hasMore := offset+limit < totalCount

	return &openauth_v1.ListGroupsResponse{
		Groups:     protoGroups,
		TotalCount: totalCount,
		Limit:      limit,
		Offset:     offset,
		HasMore:    hasMore,
	}, nil
}

// UpdateGroup modifies an existing group
func (s *Service) UpdateGroup(ctx context.Context, req *openauth_v1.UpdateGroupRequest) (*openauth_v1.UpdateGroupResponse, error) {
	// Get group to update
	var group *dao.Group
	var err error

	switch identifier := req.Identifier.(type) {
	case *openauth_v1.UpdateGroupRequest_Id:
		group, err = s.repo.GetGroupByID(ctx, identifier.Id)
	case *openauth_v1.UpdateGroupRequest_Uuid:
		group, err = s.repo.GetGroupByUUID(ctx, identifier.Uuid)
	case *openauth_v1.UpdateGroupRequest_Name:
		group, err = s.repo.GetGroupByName(ctx, identifier.Name)
	default:
		return nil, status.Error(codes.InvalidArgument, "group identifier is required")
	}

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

	if req.IsDefault != nil {
		updates["is_default"] = *req.IsDefault
	}

	if len(updates) == 0 {
		return &openauth_v1.UpdateGroupResponse{
			Group:   group.ToProto(),
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
		Group:   updatedGroup.ToProto(),
		Message: "Group updated successfully",
	}, nil
}

// DeleteGroup removes a group from the system
func (s *Service) DeleteGroup(ctx context.Context, req *openauth_v1.DeleteGroupRequest) (*openauth_v1.DeleteGroupResponse, error) {
	// Get group to delete
	var group *dao.Group
	var err error

	switch identifier := req.Identifier.(type) {
	case *openauth_v1.DeleteGroupRequest_Id:
		group, err = s.repo.GetGroupByID(ctx, identifier.Id)
	case *openauth_v1.DeleteGroupRequest_Uuid:
		group, err = s.repo.GetGroupByUUID(ctx, identifier.Uuid)
	case *openauth_v1.DeleteGroupRequest_Name:
		group, err = s.repo.GetGroupByName(ctx, identifier.Name)
	default:
		return nil, status.Error(codes.InvalidArgument, "group identifier is required")
	}

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
	// Get user ID
	var userID int64
	var err error

	switch userIdentifier := req.UserIdentifier.(type) {
	case *openauth_v1.AssignUserToGroupRequest_UserId:
		userID = userIdentifier.UserId
	case *openauth_v1.AssignUserToGroupRequest_UserUuid:
		user, err := s.repo.GetUserByUUID(ctx, userIdentifier.UserUuid)
		if err != nil {
			return nil, status.Error(codes.NotFound, "user not found")
		}
		userID = user.ID
	default:
		return nil, status.Error(codes.InvalidArgument, "user identifier is required")
	}

	// Get group ID
	var groupID int64
	switch groupIdentifier := req.GroupIdentifier.(type) {
	case *openauth_v1.AssignUserToGroupRequest_GroupId:
		groupID = groupIdentifier.GroupId
	case *openauth_v1.AssignUserToGroupRequest_GroupUuid:
		group, err := s.repo.GetGroupByUUID(ctx, groupIdentifier.GroupUuid)
		if err != nil {
			return nil, status.Error(codes.NotFound, "group not found")
		}
		groupID = group.ID
	case *openauth_v1.AssignUserToGroupRequest_GroupName:
		group, err := s.repo.GetGroupByName(ctx, groupIdentifier.GroupName)
		if err != nil {
			return nil, status.Error(codes.NotFound, "group not found")
		}
		groupID = group.ID
	default:
		return nil, status.Error(codes.InvalidArgument, "group identifier is required")
	}

	// Check if user is already in the group
	isInGroup, err := s.repo.IsUserInGroup(ctx, userID, groupID)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to check group membership")
	}
	if isInGroup {
		return nil, status.Error(codes.AlreadyExists, "user is already in the group")
	}

	// Assign user to group
	err = s.repo.AssignUserToGroup(ctx, userID, groupID, nil, req.ExpiresAt)
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
	// Get user ID
	var userID int64
	var err error

	switch userIdentifier := req.UserIdentifier.(type) {
	case *openauth_v1.RemoveUserFromGroupRequest_UserId:
		userID = userIdentifier.UserId
	case *openauth_v1.RemoveUserFromGroupRequest_UserUuid:
		user, err := s.repo.GetUserByUUID(ctx, userIdentifier.UserUuid)
		if err != nil {
			return nil, status.Error(codes.NotFound, "user not found")
		}
		userID = user.ID
	default:
		return nil, status.Error(codes.InvalidArgument, "user identifier is required")
	}

	// Get group ID
	var groupID int64
	switch groupIdentifier := req.GroupIdentifier.(type) {
	case *openauth_v1.RemoveUserFromGroupRequest_GroupId:
		groupID = groupIdentifier.GroupId
	case *openauth_v1.RemoveUserFromGroupRequest_GroupUuid:
		group, err := s.repo.GetGroupByUUID(ctx, groupIdentifier.GroupUuid)
		if err != nil {
			return nil, status.Error(codes.NotFound, "group not found")
		}
		groupID = group.ID
	case *openauth_v1.RemoveUserFromGroupRequest_GroupName:
		group, err := s.repo.GetGroupByName(ctx, groupIdentifier.GroupName)
		if err != nil {
			return nil, status.Error(codes.NotFound, "group not found")
		}
		groupID = group.ID
	default:
		return nil, status.Error(codes.InvalidArgument, "group identifier is required")
	}

	// Check if user is in the group
	isInGroup, err := s.repo.IsUserInGroup(ctx, userID, groupID)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to check group membership")
	}
	if !isInGroup {
		return nil, status.Error(codes.NotFound, "user is not in the group")
	}

	// Remove user from group
	err = s.repo.RemoveUserFromGroup(ctx, userID, groupID)
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
	// Get group ID
	var groupID int64
	var err error

	switch groupIdentifier := req.GroupIdentifier.(type) {
	case *openauth_v1.ListGroupUsersRequest_GroupId:
		groupID = groupIdentifier.GroupId
	case *openauth_v1.ListGroupUsersRequest_GroupUuid:
		group, err := s.repo.GetGroupByUUID(ctx, groupIdentifier.GroupUuid)
		if err != nil {
			return nil, status.Error(codes.NotFound, "group not found")
		}
		groupID = group.ID
	case *openauth_v1.ListGroupUsersRequest_GroupName:
		group, err := s.repo.GetGroupByName(ctx, groupIdentifier.GroupName)
		if err != nil {
			return nil, status.Error(codes.NotFound, "group not found")
		}
		groupID = group.ID
	default:
		return nil, status.Error(codes.InvalidArgument, "group identifier is required")
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
	users, totalCount, err := s.repo.ListGroupUsers(ctx, groupID, limit, offset)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to list group users")
	}

	// Convert to protobuf - for now, we'll return basic user info
	// In a more complete implementation, we'd have a specific query for group users with membership details
	protoUsers := make([]*openauth_v1.GroupUser, len(users))
	for i, user := range users {
		protoUsers[i] = &openauth_v1.GroupUser{
			UserId:     user.ID,
			UserUuid:   user.UUID.String(),
			Username:   user.Username,
			Email:      user.Email,
			Name:       user.Name,
			AssignedAt: user.CreatedAt, // This would be the actual assignment timestamp in a full implementation
		}
	}

	hasMore := offset+limit < totalCount

	return &openauth_v1.ListGroupUsersResponse{
		Users:      protoUsers,
		TotalCount: totalCount,
		Limit:      limit,
		Offset:     offset,
		HasMore:    hasMore,
	}, nil
}

// ListUserGroups retrieves all groups for a specific user
func (s *Service) ListUserGroups(ctx context.Context, req *openauth_v1.ListUserGroupsRequest) (*openauth_v1.ListUserGroupsResponse, error) {
	// Get user ID
	var userID int64
	var err error

	switch userIdentifier := req.UserIdentifier.(type) {
	case *openauth_v1.ListUserGroupsRequest_UserId:
		userID = userIdentifier.UserId
	case *openauth_v1.ListUserGroupsRequest_UserUuid:
		user, err := s.repo.GetUserByUUID(ctx, userIdentifier.UserUuid)
		if err != nil {
			return nil, status.Error(codes.NotFound, "user not found")
		}
		userID = user.ID
	default:
		return nil, status.Error(codes.InvalidArgument, "user identifier is required")
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
	groups, totalCount, err := s.repo.ListUserGroups(ctx, userID, limit, offset)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to list user groups")
	}

	// Convert to protobuf - for now, we'll return basic group info
	// In a more complete implementation, we'd have a specific query for user groups with membership details
	protoGroups := make([]*openauth_v1.UserGroup, len(groups))
	for i, group := range groups {
		protoGroups[i] = &openauth_v1.UserGroup{
			GroupId:          group.ID,
			GroupName:        group.Name,
			GroupDisplayName: group.DisplayName,
			GroupDescription: group.Description,
			IsSystem:         group.IsSystem,
			IsDefault:        group.IsDefault,
			AssignedAt:       group.CreatedAt, // This would be the actual assignment timestamp in a full implementation
		}
	}

	hasMore := offset+limit < totalCount

	return &openauth_v1.ListUserGroupsResponse{
		Groups:     protoGroups,
		TotalCount: totalCount,
		Limit:      limit,
		Offset:     offset,
		HasMore:    hasMore,
	}, nil
}
