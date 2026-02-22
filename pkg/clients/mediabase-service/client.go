package mediabaseservice

import (
	"context"
	"fmt"

	"github.com/gofreego/mediabase/api/mediabase_v1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type Client interface {
	PresignUpload(ctx context.Context, req *mediabase_v1.PresignUploadRequest) (*mediabase_v1.PresignUploadResponse, error)
}

type clientImpl struct {
	client mediabase_v1.MediabaseServiceClient
	conn   *grpc.ClientConn
}

func NewClient(endpoint string) (Client, error) {
	conn, err := grpc.NewClient(endpoint, grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		return nil, fmt.Errorf("failed to connect to mediabase service: %w", err)
	}

	return &clientImpl{
		client: mediabase_v1.NewMediabaseServiceClient(conn),
		conn:   conn,
	}, nil
}

func (c *clientImpl) PresignUpload(ctx context.Context, req *mediabase_v1.PresignUploadRequest) (*mediabase_v1.PresignUploadResponse, error) {
	return c.client.PresignUpload(ctx, req)
}
