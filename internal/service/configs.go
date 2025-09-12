package service

import (
	"context"
	"fmt"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/constants"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/internal/models/filter"
	"github.com/gofreego/openauth/pkg/jwtutils"
)

// CreateConfigEntity creates a new config entity
func (s *Service) CreateConfigEntity(ctx context.Context, req *openauth_v1.CreateConfigEntityRequest) (*openauth_v1.ConfigEntity, error) {
	logger.Info(ctx, "Create config entity request initiated for name: %s", req.Name)

	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Create config entity failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Check for permissions (assuming we have a config management permission)
	if !claims.HasPermission(constants.PermissionConfigsCreate) {
		logger.Warn(ctx, "userID=%d does not have permission to create config entities", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to create config entities")
	}

	logger.Debug(ctx, "Config entity creation authorized by userID=%d for name: %s", claims.UserID, req.Name)

	// Check if entity with same name already exists
	existing, err := s.repo.GetConfigEntityByName(ctx, req.Name)
	if err == nil && existing != nil {
		logger.Warn(ctx, "Create config entity failed: entity already exists with name: %s", req.Name)
		return nil, status.Error(codes.AlreadyExists, "config entity with this name already exists")
	}

	// Validate that the specified permissions exist
	readPerm, err := s.repo.GetPermissionByName(ctx, req.ReadPerm)
	if err != nil || readPerm == nil {
		logger.Warn(ctx, "Read permission name %s not found", req.ReadPerm)
		return nil, status.Error(codes.InvalidArgument, "invalid read permission name")
	}

	writePerm, err := s.repo.GetPermissionByName(ctx, req.WritePerm)
	if err != nil || writePerm == nil {
		logger.Warn(ctx, "Write permission name %s not found", req.WritePerm)
		return nil, status.Error(codes.InvalidArgument, "invalid write permission name")
	}

	entity := new(dao.ConfigEntity).FromCreateConfigEntityRequest(req, readPerm.ID, writePerm.ID, claims.UserID)

	// Create the config entity
	err = s.repo.CreateConfigEntity(ctx, entity)
	if err != nil {
		logger.Error(ctx, "Failed to create config entity: %v", err)
		return nil, status.Error(codes.Internal, "failed to create config entity")
	}

	logger.Info(ctx, "Config entity created successfully with ID=%d, name=%s", entity.ID, entity.Name)
	return entity.ToProtoConfigEntity(), nil
}

// GetConfigEntity retrieves a config entity by ID
func (s *Service) GetConfigEntity(ctx context.Context, req *openauth_v1.GetConfigEntityRequest) (*openauth_v1.ConfigEntity, error) {
	logger.Debug(ctx, "Get config entity request for ID: %d", req.Id)

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Get config entity failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user for permission checking
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	entity, err := s.repo.GetConfigEntityByID(ctx, req.Id)
	if err != nil {
		logger.Error(ctx, "Failed to get config entity: %v", err)
		return nil, status.Error(codes.Internal, "failed to get config entity")
	}
	if entity == nil {
		return nil, status.Error(codes.NotFound, "config entity not found")
	}

	// Check read permission
	readPerm, _ := s.repo.GetPermissionByID(ctx, entity.ReadPerm)
	if readPerm != nil && !claims.HasPermission(readPerm.Name) {
		logger.Warn(ctx, "userID=%d does not have read permission for config entity %d", claims.UserID, req.Id)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read this config entity")
	}

	return entity.ToProtoConfigEntity(), nil
}

// ListConfigEntities lists config entities with filtering and pagination
func (s *Service) ListConfigEntities(ctx context.Context, req *openauth_v1.ListConfigEntitiesRequest) (*openauth_v1.ListConfigEntitiesResponse, error) {
	logger.Debug(ctx, "List config entities request with limit=%d, offset=%d", req.Limit, req.Offset)

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "List config entities failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user for permission checking
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Check for list permission
	if !claims.HasPermission(constants.PermissionConfigsList) {
		logger.Warn(ctx, "userID=%d does not have permission to list config entities", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to list config entities")
	}

	filters := filter.NewConfigEntityFilterFromProtoRequest(req)
	entities, err := s.repo.ListConfigEntities(ctx, filters)
	if err != nil {
		logger.Error(ctx, "Failed to list config entities: %v", err)
		return nil, status.Error(codes.Internal, "failed to list config entities")
	}

	// Convert to protobuf and filter based on read permissions
	var protoEntities []*openauth_v1.ConfigEntity
	for _, entity := range entities {
		// Check if user has read permission for this entity
		readPerm, _ := s.repo.GetPermissionByID(ctx, entity.ReadPerm)
		if readPerm == nil || claims.HasPermission(readPerm.Name) {
			protoEntities = append(protoEntities, entity.ToProtoConfigEntity())
		}
	}

	logger.Debug(ctx, "Successfully retrieved %d config entities", len(protoEntities))
	return &openauth_v1.ListConfigEntitiesResponse{
		Entities: protoEntities,
	}, nil
}

// UpdateConfigEntity updates an existing config entity
func (s *Service) UpdateConfigEntity(ctx context.Context, req *openauth_v1.UpdateConfigEntityRequest) (*openauth_v1.UpdateResponse, error) {
	logger.Info(ctx, "Update config entity request for ID: %d", req.Id)

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Update config entity failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Get existing entity to check permissions
	entity, err := s.repo.GetConfigEntityByID(ctx, req.Id)
	if err != nil {
		logger.Error(ctx, "Failed to get config entity for update: %v", err)
		return nil, status.Error(codes.Internal, "failed to get config entity")
	}
	if entity == nil {
		return nil, status.Error(codes.NotFound, "config entity not found")
	}

	// Check write permission
	writePerm, _ := s.repo.GetPermissionByID(ctx, entity.WritePerm)
	if writePerm != nil && !claims.HasPermission(writePerm.Name) {
		logger.Warn(ctx, "userID=%d does not have write permission for config entity %d", claims.UserID, req.Id)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to update this config entity")
	}

	// Build updates map
	updates := make(map[string]interface{})
	if req.DisplayName != nil {
		updates["display_name"] = req.DisplayName
	}
	if req.Description != nil {
		updates["description"] = req.Description
	}
	if req.ReadPerm != nil {
		// Validate the permission exists
		readPerm, err := s.repo.GetPermissionByName(ctx, *req.ReadPerm)
		if err != nil || readPerm == nil {
			return nil, status.Error(codes.NotFound, "read permission not found")
		}
		updates["read_perm"] = readPerm.ID
	}
	if req.WritePerm != nil {
		// Validate the permission exists
		writePerm, err := s.repo.GetPermissionByName(ctx, *req.WritePerm)
		if err != nil || writePerm == nil {
			return nil, status.Error(codes.NotFound, "write permission not found")
		}
		updates["write_perm"] = writePerm.ID
	}

	err = s.repo.UpdateConfigEntity(ctx, req.Id, updates)
	if err != nil {
		logger.Error(ctx, "Failed to update config entity: %v", err)
		return nil, status.Error(codes.Internal, "failed to update config entity")
	}

	logger.Info(ctx, "Config entity updated successfully with ID=%d", req.Id)
	return &openauth_v1.UpdateResponse{
		Success: true,
		Message: stringPtr("config entity updated successfully"),
	}, nil
}

// DeleteConfigEntity deletes a config entity
func (s *Service) DeleteConfigEntity(ctx context.Context, req *openauth_v1.DeleteConfigEntityRequest) (*openauth_v1.DeleteResponse, error) {
	logger.Info(ctx, "Delete config entity request for ID: %d", req.Id)

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Delete config entity failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Get existing entity to check permissions
	entity, err := s.repo.GetConfigEntityByID(ctx, req.Id)
	if err != nil {
		logger.Error(ctx, "Failed to get config entity for deletion: %v", err)
		return nil, status.Error(codes.Internal, "failed to get config entity")
	}
	if entity == nil {
		return nil, status.Error(codes.NotFound, "config entity not found")
	}

	// Check write permission (delete requires write permission)
	writePerm, _ := s.repo.GetPermissionByID(ctx, entity.WritePerm)
	if writePerm != nil && !claims.HasPermission(writePerm.Name) {
		logger.Warn(ctx, "userID=%d does not have write permission for config entity %d", claims.UserID, req.Id)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to delete this config entity")
	}

	err = s.repo.DeleteConfigEntity(ctx, req.Id)
	if err != nil {
		logger.Error(ctx, "Failed to delete config entity: %v", err)
		return nil, status.Error(codes.Internal, "failed to delete config entity")
	}

	logger.Info(ctx, "Config entity deleted successfully with ID=%d", req.Id)
	return &openauth_v1.DeleteResponse{
		Success: true,
		Message: stringPtr("config entity deleted successfully"),
	}, nil
}

// Helper function to create string pointer
func stringPtr(s string) *string {
	return &s
}

// CreateConfig creates a new configuration
func (s *Service) CreateConfig(ctx context.Context, req *openauth_v1.CreateConfigRequest) (*openauth_v1.Config, error) {
	logger.Info(ctx, "Create config request initiated for entity_id: %d, key: %s", req.EntityId, req.Key)

	// Validate request using generated validation
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Create config failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user ID from context
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Get the config entity to check permissions
	entity, err := s.repo.GetConfigEntityByID(ctx, req.EntityId)
	if err != nil {
		logger.Error(ctx, "Failed to get config entity: %v", err)
		return nil, status.Error(codes.Internal, "failed to get config entity")
	}
	if entity == nil {
		return nil, status.Error(codes.NotFound, "config entity not found")
	}

	// Check write permission for the entity
	writePerm, _ := s.repo.GetPermissionByID(ctx, entity.WritePerm)
	if writePerm != nil && !claims.HasPermission(writePerm.Name) {
		logger.Warn(ctx, "userID=%d does not have write permission for config entity %d", claims.UserID, req.EntityId)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to create configs in this entity")
	}

	logger.Debug(ctx, "Config creation authorized by userID=%d for entity_id=%d, key=%s", claims.UserID, req.EntityId, req.Key)

	// Check if config with same key already exists in this entity
	existing, err := s.repo.GetConfigByEntityAndKey(ctx, req.EntityId, req.Key)
	if err == nil && existing != nil {
		logger.Warn(ctx, "Create config failed: config already exists with key: %s in entity: %d", req.Key, req.EntityId)
		return nil, status.Error(codes.AlreadyExists, "config with this key already exists in the entity")
	}

	config := new(dao.Config).FromCreateConfigRequest(req, claims.UserID)

	// Create the config
	err = s.repo.CreateConfig(ctx, config)
	if err != nil {
		logger.Error(ctx, "Failed to create config: %v", err)
		return nil, status.Error(codes.Internal, "failed to create config")
	}

	logger.Info(ctx, "Config created successfully with ID=%d, key=%s", config.ID, config.Key)
	return config.ToProtoConfig(), nil
}

// GetConfig retrieves a config by ID
func (s *Service) GetConfig(ctx context.Context, req *openauth_v1.GetConfigRequest) (*openauth_v1.Config, error) {
	logger.Debug(ctx, "Get config request for ID: %d", req.Id)

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Get config failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user for permission checking
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	config, err := s.repo.GetConfigByID(ctx, req.Id)
	if err != nil {
		logger.Error(ctx, "Failed to get config: %v", err)
		return nil, status.Error(codes.Internal, "failed to get config")
	}
	if config == nil {
		return nil, status.Error(codes.NotFound, "config not found")
	}

	// Get the entity to check read permissions
	entity, err := s.repo.GetConfigEntityByID(ctx, config.EntityID)
	if err != nil || entity == nil {
		logger.Error(ctx, "Failed to get config entity for permission check: %v", err)
		return nil, status.Error(codes.Internal, "failed to verify permissions")
	}

	// Check read permission
	readPerm, _ := s.repo.GetPermissionByID(ctx, entity.ReadPerm)
	if readPerm != nil && !claims.HasPermission(readPerm.Name) {
		logger.Warn(ctx, "userID=%d does not have read permission for config %d", claims.UserID, req.Id)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read this config")
	}

	return config.ToProtoConfig(), nil
}

// GetConfigByKey retrieves a config by entity and key
func (s *Service) GetConfigByKey(ctx context.Context, req *openauth_v1.GetConfigByKeyRequest) (*openauth_v1.Config, error) {
	logger.Debug(ctx, "Get config by key request for key: %s", req.Key)

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Get config by key failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user for permission checking
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	var config *dao.Config
	var entity *dao.ConfigEntity

	// Handle entity identifier (ID or name)
	switch identifier := req.EntityIdentifier.(type) {
	case *openauth_v1.GetConfigByKeyRequest_EntityId:
		config, err = s.repo.GetConfigByEntityAndKey(ctx, identifier.EntityId, req.Key)
		if err != nil {
			logger.Error(ctx, "Failed to get config by entity ID and key: %v", err)
			return nil, status.Error(codes.Internal, "failed to get config")
		}
		if config == nil {
			return nil, status.Error(codes.NotFound, "config not found")
		}
		entity, err = s.repo.GetConfigEntityByID(ctx, identifier.EntityId)
	case *openauth_v1.GetConfigByKeyRequest_EntityName:
		config, err = s.repo.GetConfigByEntityNameAndKey(ctx, identifier.EntityName, req.Key)
		if err != nil {
			logger.Error(ctx, "Failed to get config by entity name and key: %v", err)
			return nil, status.Error(codes.Internal, "failed to get config")
		}
		if config == nil {
			return nil, status.Error(codes.NotFound, "config not found")
		}
		entity, err = s.repo.GetConfigEntityByName(ctx, identifier.EntityName)
	default:
		return nil, status.Error(codes.InvalidArgument, "entity identifier is required")
	}

	if err != nil || entity == nil {
		logger.Error(ctx, "Failed to get config entity for permission check: %v", err)
		return nil, status.Error(codes.Internal, "failed to verify permissions")
	}

	// Check read permission
	readPerm, _ := s.repo.GetPermissionByID(ctx, entity.ReadPerm)
	if readPerm != nil && !claims.HasPermission(readPerm.Name) {
		logger.Warn(ctx, "userID=%d does not have read permission for config %s", claims.UserID, req.Key)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read this config")
	}

	return config.ToProtoConfig(), nil
}

// GetConfigsByKeys retrieves multiple configs by keys within an entity
func (s *Service) GetConfigsByKeys(ctx context.Context, req *openauth_v1.GetConfigsByKeysRequest) (*openauth_v1.GetConfigsByKeysResponse, error) {
	logger.Debug(ctx, "Get configs by keys request for %d keys", len(req.Keys))

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Get configs by keys failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user for permission checking
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	var configs map[string]*dao.Config
	var entity *dao.ConfigEntity

	// Handle entity identifier (ID or name)
	switch identifier := req.EntityIdentifier.(type) {
	case *openauth_v1.GetConfigsByKeysRequest_EntityId:
		configs, err = s.repo.GetConfigsByEntityAndKeys(ctx, identifier.EntityId, req.Keys)
		if err != nil {
			logger.Error(ctx, "Failed to get configs by entity ID and keys: %v", err)
			return nil, status.Error(codes.Internal, "failed to get configs")
		}
		entity, err = s.repo.GetConfigEntityByID(ctx, identifier.EntityId)
	case *openauth_v1.GetConfigsByKeysRequest_EntityName:
		configs, err = s.repo.GetConfigsByEntityNameAndKeys(ctx, identifier.EntityName, req.Keys)
		if err != nil {
			logger.Error(ctx, "Failed to get configs by entity name and keys: %v", err)
			return nil, status.Error(codes.Internal, "failed to get configs")
		}
		entity, err = s.repo.GetConfigEntityByName(ctx, identifier.EntityName)
	default:
		return nil, status.Error(codes.InvalidArgument, "entity identifier is required")
	}

	if err != nil || entity == nil {
		logger.Error(ctx, "Failed to get config entity for permission check: %v", err)
		return nil, status.Error(codes.Internal, "failed to verify permissions")
	}

	// Check read permission
	readPerm, _ := s.repo.GetPermissionByID(ctx, entity.ReadPerm)
	if readPerm != nil && !claims.HasPermission(readPerm.Name) {
		logger.Warn(ctx, "userID=%d does not have read permission for entity", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to read configs from this entity")
	}

	// Convert to protobuf
	protoConfigs := make(map[string]*openauth_v1.Config)
	for key, config := range configs {
		protoConfigs[key] = config.ToProtoConfig()
	}

	return &openauth_v1.GetConfigsByKeysResponse{
		Configs: protoConfigs,
	}, nil
}

// ListConfigs lists configs with filtering and pagination
func (s *Service) ListConfigs(ctx context.Context, req *openauth_v1.ListConfigsRequest) (*openauth_v1.ListConfigsResponse, error) {
	logger.Debug(ctx, "List configs request with limit=%d, offset=%d", req.Limit, req.Offset)

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "List configs failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user for permission checking
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Check for general list permission
	if !claims.HasPermission(constants.PermissionConfigsList) {
		logger.Warn(ctx, "userID=%d does not have permission to list configs", claims.UserID)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to list configs")
	}

	filters := filter.NewConfigFilterFromProtoRequest(req)
	configs, total, err := s.repo.ListConfigs(ctx, filters)
	if err != nil {
		logger.Error(ctx, "Failed to list configs: %v", err)
		return nil, status.Error(codes.Internal, "failed to list configs")
	}

	// If filtering by specific entity, check read permission for that entity
	if filters.EntityID != nil {
		entity, err := s.repo.GetConfigEntityByID(ctx, *filters.EntityID)
		if err != nil || entity == nil {
			logger.Error(ctx, "Failed to get config entity for permission check: %v", err)
			return nil, status.Error(codes.Internal, "failed to verify permissions")
		}

		readPerm, _ := s.repo.GetPermissionByID(ctx, entity.ReadPerm)
		if readPerm != nil && !claims.HasPermission(readPerm.Name) {
			logger.Warn(ctx, "userID=%d does not have read permission for entity %d", claims.UserID, *filters.EntityID)
			return nil, status.Error(codes.PermissionDenied, "user does not have permission to read configs from this entity")
		}
	}

	// Convert to protobuf and filter based on entity read permissions
	var protoConfigs []*openauth_v1.Config
	entityPermCache := make(map[int64]bool) // Cache for entity permissions

	for _, config := range configs {
		// Check if we've already verified permissions for this entity
		hasPermission, cached := entityPermCache[config.EntityID]
		if !cached {
			entity, err := s.repo.GetConfigEntityByID(ctx, config.EntityID)
			if err != nil || entity == nil {
				hasPermission = false
			} else {
				readPerm, _ := s.repo.GetPermissionByID(ctx, entity.ReadPerm)
				hasPermission = readPerm == nil || claims.HasPermission(readPerm.Name)
			}
			entityPermCache[config.EntityID] = hasPermission
		}

		if hasPermission {
			protoConfigs = append(protoConfigs, config.ToProtoConfig())
		}
	}

	logger.Debug(ctx, "Successfully retrieved %d configs out of %d total", len(protoConfigs), total)
	return &openauth_v1.ListConfigsResponse{
		Configs: protoConfigs,
		Total:   total,
	}, nil
}

// UpdateConfig updates an existing config
func (s *Service) UpdateConfig(ctx context.Context, req *openauth_v1.UpdateConfigRequest) (*openauth_v1.UpdateResponse, error) {
	logger.Info(ctx, "Update config request for ID: %d", req.Id)

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Update config failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Get existing config to check permissions
	config, err := s.repo.GetConfigByID(ctx, req.Id)
	if err != nil {
		logger.Error(ctx, "Failed to get config for update: %v", err)
		return nil, status.Error(codes.Internal, "failed to get config")
	}
	if config == nil {
		return nil, status.Error(codes.NotFound, "config not found")
	}

	// Get the entity to check write permissions
	entity, err := s.repo.GetConfigEntityByID(ctx, config.EntityID)
	if err != nil || entity == nil {
		logger.Error(ctx, "Failed to get config entity for permission check: %v", err)
		return nil, status.Error(codes.Internal, "failed to verify permissions")
	}

	// Check write permission
	writePerm, _ := s.repo.GetPermissionByID(ctx, entity.WritePerm)
	if writePerm != nil && !claims.HasPermission(writePerm.Name) {
		logger.Warn(ctx, "userID=%d does not have write permission for config %d", claims.UserID, req.Id)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to update this config")
	}

	// Apply updates using the DAO method
	config.FromUpdateConfigRequest(req, claims.UserID)

	// Build updates map for repository
	updates := make(map[string]interface{})
	updates["updated_by"] = claims.UserID
	updates["updated_at"] = config.UpdatedAt

	if req.DisplayName != nil {
		updates["display_name"] = req.DisplayName
	}
	if req.Description != nil {
		updates["description"] = req.Description
	}
	if req.Value != nil {
		updates["value"] = config.Value
	}
	if req.Metadata != nil {
		updates["metadata"] = config.Metadata
	}

	err = s.repo.UpdateConfig(ctx, req.Id, updates)
	if err != nil {
		logger.Error(ctx, "Failed to update config: %v", err)
		return nil, status.Error(codes.Internal, "failed to update config")
	}

	logger.Info(ctx, "Config updated successfully with ID=%d", req.Id)
	return &openauth_v1.UpdateResponse{
		Success: true,
		Message: stringPtr("config updated successfully"),
	}, nil
}

// DeleteConfig deletes a config
func (s *Service) DeleteConfig(ctx context.Context, req *openauth_v1.DeleteConfigRequest) (*openauth_v1.DeleteResponse, error) {
	logger.Info(ctx, "Delete config request for ID: %d", req.Id)

	// Validate request
	if err := req.Validate(); err != nil {
		logger.Warn(ctx, "Delete config failed validation: %v", err)
		return nil, status.Error(codes.InvalidArgument, fmt.Sprintf("validation failed: %v", err))
	}

	// Get current user
	claims, err := jwtutils.GetUserFromContext(ctx)
	if err != nil {
		logger.Warn(ctx, "failed to get user from context, err: %s", err.Error())
		return nil, status.Error(codes.Unauthenticated, "failed to get user from context")
	}

	// Get existing config to check permissions
	config, err := s.repo.GetConfigByID(ctx, req.Id)
	if err != nil {
		logger.Error(ctx, "Failed to get config for deletion: %v", err)
		return nil, status.Error(codes.Internal, "failed to get config")
	}
	if config == nil {
		return nil, status.Error(codes.NotFound, "config not found")
	}

	// Get the entity to check write permissions
	entity, err := s.repo.GetConfigEntityByID(ctx, config.EntityID)
	if err != nil || entity == nil {
		logger.Error(ctx, "Failed to get config entity for permission check: %v", err)
		return nil, status.Error(codes.Internal, "failed to verify permissions")
	}

	// Check write permission (delete requires write permission)
	writePerm, _ := s.repo.GetPermissionByID(ctx, entity.WritePerm)
	if writePerm != nil && !claims.HasPermission(writePerm.Name) {
		logger.Warn(ctx, "userID=%d does not have write permission for config %d", claims.UserID, req.Id)
		return nil, status.Error(codes.PermissionDenied, "user does not have permission to delete this config")
	}

	err = s.repo.DeleteConfig(ctx, req.Id)
	if err != nil {
		logger.Error(ctx, "Failed to delete config: %v", err)
		return nil, status.Error(codes.Internal, "failed to delete config")
	}

	logger.Info(ctx, "Config deleted successfully with ID=%d", req.Id)
	return &openauth_v1.DeleteResponse{
		Success: true,
		Message: stringPtr("config deleted successfully"),
	}, nil
}
