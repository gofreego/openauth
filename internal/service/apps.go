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
	"github.com/gofreego/openauth/pkg/jwtutils"
)

// CreateApp creates a new app definition
func (s *Service) CreateApp(ctx context.Context, req *openauth_v1.CreateAppRequest) (*openauth_v1.App, error) {
	logger.Info(ctx, "Create app request initiated for name: %s", req.Name)

	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Create app failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context ,err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	if !claims.HasPermission(constants.PermissionAppsCreate) {
		logger.Warn(ctx, "userID=%d does not have permission to create apps", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to create apps")
	}

	// Check if app with same name already exists
	existing, err := s.repo.GetAppByName(ctx, req.Name)
	if err == nil && existing != nil {
		logger.Warn(ctx, "Create app failed: app already exists with name: %s", req.Name)
		return nil, status.Error(codes.AlreadyExists, "app with this name already exists")
	}

	app := new(dao.App).FromCreateAppRequest(req)
	createdApp, err := s.repo.CreateApp(ctx, app)
	if err != nil {
		logger.Error(ctx, "Failed to create app %s: %v", req.Name, err)
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to create app: %v", err))
	}

	return createdApp.ToProtoApp(), nil
}

// UpdateApp updates an existing app definition
func (s *Service) UpdateApp(ctx context.Context, req *openauth_v1.UpdateAppRequest) (*openauth_v1.App, error) {
	logger.Info(ctx, "Update app request initiated for ID: %d", req.Id)

	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Update app failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	if !claims.HasPermission(constants.PermissionAppsUpdate) {
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to update apps")
	}

	existing, err := s.repo.GetAppByID(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to retrieve app: %v", err))
	}
	if existing == nil {
		return nil, status.Error(codes.NotFound, "app not found")
	}

	updates := make(map[string]interface{})
	updates["updated_at"] = time.Now().UnixMilli()

	if req.Name != nil {
		if *req.Name != existing.Name {
			// Check uniqueness of new name
			byName, err := s.repo.GetAppByName(ctx, *req.Name)
			if err == nil && byName != nil {
				return nil, status.Error(codes.AlreadyExists, "app with this name already exists")
			}
		}
		updates["name"] = *req.Name
	}

	if req.Description != nil {
		updates["description"] = *req.Description
	}

	if req.Url != nil {
		updates["url"] = *req.Url
	}

	if req.LogoUrl != nil {
		updates["logo_url"] = *req.LogoUrl
	}

	updatedApp, err := s.repo.UpdateApp(ctx, req.Id, updates)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to update app: %v", err))
	}

	return updatedApp.ToProtoApp(), nil
}

// DeleteApp deletes an app definition
func (s *Service) DeleteApp(ctx context.Context, req *openauth_v1.DeleteAppRequest) (*openauth_v1.DeleteAppResponse, error) {
	logger.Info(ctx, "Delete app request initiated for ID: %d", req.Id)

	if err := req.Validate(); err != nil {
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	if !claims.HasPermission(constants.PermissionAppsDelete) {
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to delete apps")
	}

	existing, err := s.repo.GetAppByID(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to retrieve app: %v", err))
	}
	if existing == nil {
		return nil, status.Error(codes.NotFound, "app not found")
	}

	err = s.repo.DeleteApp(ctx, req.Id)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to delete app: %v", err))
	}

	return &openauth_v1.DeleteAppResponse{
		Success: true,
		Message: "App deleted successfully",
	}, nil
}

// AssignApp assigns a list of apps to a user
func (s *Service) AssignApp(ctx context.Context, req *openauth_v1.AssignAppRequest) (*openauth_v1.AssignAppResponse, error) {
	logger.Info(ctx, "Assign app request initiated for UserID: %d", req.UserId)

	if err := req.Validate(); err != nil {
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	if !claims.HasPermission(constants.PermissionAppsAssign) {
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to assign apps")
	}

	// Verify target user exists
	targetUser, err := s.repo.GetUserByID(ctx, req.UserId)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to verify target user: %v", err))
	}
	if targetUser == nil {
		return nil, status.Error(codes.NotFound, "target user not found")
	}

	// Verify all assigned app IDs exist
	for _, appID := range req.AppIds {
		app, err := s.repo.GetAppByID(ctx, appID)
		if err != nil {
			return nil, status.Error(codes.Internal, fmt.Sprintf("failed to verify app ID %d: %v", appID, err))
		}
		if app == nil {
			return nil, status.Error(codes.NotFound, fmt.Sprintf("app ID %d not found", appID))
		}
	}

	err = s.repo.AssignAppsToUser(ctx, req.UserId, req.AppIds, claims.UserID)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to assign apps: %v", err))
	}

	return &openauth_v1.AssignAppResponse{
		Success: true,
		Message: "Apps assigned to user successfully",
	}, nil
}

// ListApps lists all app definitions in the system with pagination and search
func (s *Service) ListApps(ctx context.Context, req *openauth_v1.ListAppsRequest) (*openauth_v1.ListAppsResponse, error) {
	if err := req.Validate(); err != nil {
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	if !claims.HasPermission(constants.PermissionAppsList) {
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to list apps")
	}

	limit := req.Limit
	if limit <= 0 {
		limit = 10
	}
	offset := req.Offset
	if offset < 0 {
		offset = 0
	}

	var searchPtr *string
	if req.Search != nil && *req.Search != "" {
		sStr := *req.Search
		searchPtr = &sStr
	}

	apps, total, err := s.repo.ListApps(ctx, searchPtr, limit, offset)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list apps: %v", err))
	}

	protoApps := make([]*openauth_v1.App, len(apps))
	for i, a := range apps {
		protoApps[i] = a.ToProtoApp()
	}

	return &openauth_v1.ListAppsResponse{
		Apps:  protoApps,
		Total: total,
	}, nil
}

// ListUserApps lists all apps assigned to a specific user with pagination
func (s *Service) ListUserApps(ctx context.Context, req *openauth_v1.ListUserAppsRequest) (*openauth_v1.ListUserAppsResponse, error) {
	if err := req.Validate(); err != nil {
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Users can list their own assigned apps, or an admin with apps.list/apps.read permissions can list others'
	if claims.UserID != req.UserId {
		if !claims.HasPermission(constants.PermissionAppsList) && !claims.HasPermission(constants.PermissionAppsRead) {
			return nil, status.Error(codes.PermissionDenied, "user does not have permission to list other users' apps")
		}
	}

	limit := req.Limit
	if limit <= 0 {
		limit = 10
	}
	offset := req.Offset
	if offset < 0 {
		offset = 0
	}

	apps, total, err := s.repo.ListUserApps(ctx, req.UserId, limit, offset)
	if err != nil {
		return nil, status.Error(codes.Internal, fmt.Sprintf("failed to list user apps: %v", err))
	}

	protoApps := make([]*openauth_v1.App, len(apps))
	for i, a := range apps {
		protoApps[i] = a.ToProtoApp()
	}

	return &openauth_v1.ListUserAppsResponse{
		Apps:  protoApps,
		Total: total,
	}, nil
}
