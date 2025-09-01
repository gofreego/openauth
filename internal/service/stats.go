package service

import (
	"context"

	"github.com/gofreego/openauth/api/openauth_v1"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// Stats returns system statistics
func (s *Service) Stats(ctx context.Context, req *openauth_v1.StatsRequest) (*openauth_v1.StatsResponse, error) {
	// Get stats from repository
	totalUsers, err := s.repo.GetTotalUsers(ctx)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to get total users count")
	}

	totalPermissions, err := s.repo.GetTotalPermissions(ctx)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to get total permissions count")
	}

	totalGroups, err := s.repo.GetTotalGroups(ctx)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to get total groups count")
	}

	activeUsers, err := s.repo.GetActiveUsers(ctx)
	if err != nil {
		return nil, status.Error(codes.Internal, "failed to get active users count")
	}

	return &openauth_v1.StatsResponse{
		TotalUsers:       totalUsers,
		TotalPermissions: totalPermissions,
		TotalGroups:      totalGroups,
		ActiveUsers:      activeUsers,
	}, nil
}
