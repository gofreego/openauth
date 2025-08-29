package service

import (
	"context"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/goutils/logger"
)

func (s *Service) Ping(ctx context.Context, req *openauth_v1.PingRequest) (*openauth_v1.PingResponse, error) {
	logger.Debug(ctx, "Ping request received, %v", req.Message)
	err := s.repo.Ping(ctx)
	if err != nil {
		return nil, err
	}
	return &openauth_v1.PingResponse{
		Message: "Its fine here...!",
	}, nil
}
