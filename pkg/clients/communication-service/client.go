package communicationservice

import (
	"context"
	"net/http"

	"github.com/gofreego/goutils/logger"
)

type SendSMSRequest struct {
	Mobile  string
	Message string
}

type SendEmailRequest struct {
	Email   string
	Subject string
	Body    string
}

type Client interface {
	SendSMS(ctx context.Context, req *SendSMSRequest) error
	SendEmail(ctx context.Context, req *SendEmailRequest) error
}

func NewClient(endpoint string) Client {
	return &clientImpl{
		httpClient: http.DefaultClient,
		endpoint:   endpoint,
	}
}

type clientImpl struct {
	httpClient *http.Client
	endpoint   string
}

func (c *clientImpl) SendEmail(ctx context.Context, req *SendEmailRequest) error {
	logger.Debug(ctx, "Sending Email to %s with subject %s, \n body: %s", req.Email, req.Subject, req.Body)
	return nil
}

func (c *clientImpl) SendSMS(ctx context.Context, req *SendSMSRequest) error {
	logger.Debug(ctx, "Sending SMS to %s: %s", req.Mobile, req.Message)
	return nil
}
