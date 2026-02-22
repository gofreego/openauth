package service

import (
	"context"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
)

func (s *Service) Ping(ctx context.Context, req *openauth_v1.OOPingRequest) (*openauth_v1.OOPingResponse, error) {
	logger.Debug(ctx, "Ping request received, %v", req.Message)
	err := s.repo.Ping(ctx)
	if err != nil {
		return nil, err
	}
	return &openauth_v1.OOPingResponse{
		Message: "Its fine here...!",
	}, nil
}
