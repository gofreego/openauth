package openauth

import (
	"context"
	"crypto/tls"
	"fmt"
	"sync"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"

	"github.com/gofreego/openauth/api/openauth_v1"
)

type ClientConfig struct {
	Endpoint string
	Username string
	Password string
	TLS      bool
	Timeout  time.Duration
}

func NewOpenAuthClientV1(ctx context.Context, config *ClientConfig) (openauth_v1.OpenAuthClient, *grpc.ClientConn, error) {
	if config == nil {
		return nil, nil, fmt.Errorf("config cannot be nil")
	}

	if config.Endpoint == "" {
		return nil, nil, fmt.Errorf("endpoint is required")
	}

	if config.Timeout == 0 {
		config.Timeout = 30 * time.Second
	}

	// Set up connection options
	opts := []grpc.DialOption{
		grpc.WithDefaultCallOptions(grpc.WaitForReady(true)),
	}

	// Configure TLS
	if config.TLS {
		creds := credentials.NewTLS(&tls.Config{})
		opts = append(opts, grpc.WithTransportCredentials(creds))
	} else {
		opts = append(opts, grpc.WithTransportCredentials(insecure.NewCredentials()))
	}

	// Establish connection
	conn, err := grpc.NewClient(config.Endpoint, opts...)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to connect to OpenAuth server: %w", err)
	}
	return openauth_v1.NewOpenAuthClient(conn), conn, nil
}

type OpenauthConfigFetcher struct {
	client       openauth_v1.OpenAuthClient
	conn         *grpc.ClientConn
	config       *ClientConfig
	token        string // current access token
	refreshToken string // current refresh token
	tokenMutex   sync.RWMutex
}

func NewOpenauthConfigFetcher(ctx context.Context, config *ClientConfig) (*OpenauthConfigFetcher, error) {
	client, conn, err := NewOpenAuthClientV1(ctx, config)
	if err != nil {
		return nil, err
	}
	fetcher := &OpenauthConfigFetcher{
		client: client,
		conn:   conn,
		config: config,
	}

	// Auto-login if credentials are provided
	if config.Username != "" && config.Password != "" {
		if err := fetcher.login(ctx); err != nil {
			conn.Close()
			return nil, fmt.Errorf("failed to login: %w", err)
		}
	}

	return fetcher, nil
}

// Close closes the gRPC connection
func (c *OpenauthConfigFetcher) Close() error {
	if c.conn != nil {
		return c.conn.Close()
	}
	return nil
}

// login performs authentication and stores the access token
func (c *OpenauthConfigFetcher) login(ctx context.Context) error {
	password := c.config.Password
	includePermissions := true
	req := &openauth_v1.SignInRequest{
		Username:           c.config.Username,
		Password:           &password,
		IncludePermissions: &includePermissions,
	}

	ctx, cancel := context.WithTimeout(ctx, c.config.Timeout)
	defer cancel()

	resp, err := c.client.SignIn(ctx, req)
	if err != nil {
		return fmt.Errorf("authentication failed: %w", err)
	}

	c.tokenMutex.Lock()
	c.token = resp.AccessToken
	c.refreshToken = resp.RefreshToken
	c.tokenMutex.Unlock()
	return nil
}

// getAuthContext returns a context with authorization token
func (c *OpenauthConfigFetcher) getAuthContext(ctx context.Context) context.Context {
	c.tokenMutex.RLock()
	token := c.token
	c.tokenMutex.RUnlock()

	if token != "" {
		return metadata.AppendToOutgoingContext(ctx, "authorization", "Bearer "+token)
	}
	return ctx
}

// isUnauthenticatedError checks if the error is due to authentication failure
func (c *OpenauthConfigFetcher) isUnauthenticatedError(err error) bool {
	if err == nil {
		return false
	}
	st, ok := status.FromError(err)
	return ok && st.Code() == codes.Unauthenticated
}

// refreshAccessToken attempts to refresh the access token using the refresh token
func (c *OpenauthConfigFetcher) refreshAccessToken(ctx context.Context) error {
	c.tokenMutex.RLock()
	refreshToken := c.refreshToken
	c.tokenMutex.RUnlock()

	if refreshToken == "" {
		return fmt.Errorf("no refresh token available")
	}

	req := &openauth_v1.RefreshTokenRequest{
		RefreshToken: refreshToken,
	}

	ctx, cancel := context.WithTimeout(ctx, c.config.Timeout)
	defer cancel()

	resp, err := c.client.RefreshToken(ctx, req)
	if err != nil {
		return fmt.Errorf("failed to refresh token: %w", err)
	}

	c.tokenMutex.Lock()
	c.token = resp.AccessToken
	c.refreshToken = resp.RefreshToken
	c.tokenMutex.Unlock()

	return nil
}

// executeWithTokenRefresh executes a function with automatic token refresh on unauthenticated errors
func (c *OpenauthConfigFetcher) executeWithTokenRefresh(ctx context.Context, fn func(context.Context) error) error {
	// First attempt with current token
	authCtx := c.getAuthContext(ctx)
	err := fn(authCtx)

	// If not an authentication error, return the result
	if !c.isUnauthenticatedError(err) {
		return err
	}

	// Attempt to refresh the token
	if refreshErr := c.refreshAccessToken(ctx); refreshErr != nil {
		return fmt.Errorf("token refresh failed: %w, original error: %v", refreshErr, err)
	}

	// Retry with the new token
	authCtx = c.getAuthContext(ctx)
	return fn(authCtx)
}

// Authentication Methods

func (c *OpenauthConfigFetcher) SignIn(ctx context.Context, req *openauth_v1.SignInRequest) (*openauth_v1.SignInResponse, error) {
	ctx, cancel := context.WithTimeout(ctx, c.config.Timeout)
	defer cancel()

	resp, err := c.client.SignIn(ctx, req)
	if err != nil {
		return nil, err
	}

	// Update tokens if successful
	c.tokenMutex.Lock()
	c.token = resp.AccessToken
	c.refreshToken = resp.RefreshToken
	c.tokenMutex.Unlock()

	return resp, nil
}

func (c *OpenauthConfigFetcher) RefreshToken(ctx context.Context, req *openauth_v1.RefreshTokenRequest) (*openauth_v1.RefreshTokenResponse, error) {
	ctx, cancel := context.WithTimeout(ctx, c.config.Timeout)
	defer cancel()

	resp, err := c.client.RefreshToken(c.getAuthContext(ctx), req)
	if err != nil {
		return nil, err
	}

	// Update token if successful
	c.tokenMutex.Lock()
	c.token = resp.AccessToken
	c.refreshToken = resp.RefreshToken
	c.tokenMutex.Unlock()
	return resp, nil
}

func (c *OpenauthConfigFetcher) Logout(ctx context.Context, req *openauth_v1.LogoutRequest) (*openauth_v1.LogoutResponse, error) {
	ctx, cancel := context.WithTimeout(ctx, c.config.Timeout)
	defer cancel()

	resp, err := c.client.Logout(c.getAuthContext(ctx), req)
	if err != nil {
		return nil, err
	}

	// Clear tokens after logout
	c.tokenMutex.Lock()
	c.token = ""
	c.refreshToken = ""
	c.tokenMutex.Unlock()
	return resp, nil
}

func (c *OpenauthConfigFetcher) GetConfigsByKeys(ctx context.Context, in *openauth_v1.GetConfigsByKeysRequest) (*openauth_v1.GetConfigsByKeysResponse, error) {
	ctx, cancel := context.WithTimeout(ctx, c.config.Timeout)
	defer cancel()

	var resp *openauth_v1.GetConfigsByKeysResponse
	err := c.executeWithTokenRefresh(ctx, func(authCtx context.Context) error {
		var callErr error
		resp, callErr = c.client.GetConfigsByKeys(authCtx, in)
		return callErr
	})

	return resp, err
}

func (c *OpenauthConfigFetcher) GetConfigsByEntityName(ctx context.Context, entityName string) (*openauth_v1.ListConfigsResponse, error) {
	ctx, cancel := context.WithTimeout(ctx, c.config.Timeout)
	defer cancel()
	req := &openauth_v1.ListConfigsRequest{
		Entity: &openauth_v1.ListConfigsRequest_EntityName{
			EntityName: entityName,
		},
		All: true,
	}
	var resp *openauth_v1.ListConfigsResponse
	err := c.executeWithTokenRefresh(ctx, func(authCtx context.Context) error {
		var callErr error
		resp, callErr = c.client.ListConfigs(authCtx, req)
		return callErr
	})
	return resp, err
}
