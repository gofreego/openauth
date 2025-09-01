package service

import (
	"context"
	"testing"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// MockRepository is a mock implementation of the Repository interface for testing
type MockRepository struct {
	mock.Mock
}

func (m *MockRepository) GetTotalUsers(ctx context.Context) (int64, error) {
	args := m.Called(ctx)
	return args.Get(0).(int64), args.Error(1)
}

func (m *MockRepository) GetTotalPermissions(ctx context.Context) (int64, error) {
	args := m.Called(ctx)
	return args.Get(0).(int64), args.Error(1)
}

func (m *MockRepository) GetTotalGroups(ctx context.Context) (int64, error) {
	args := m.Called(ctx)
	return args.Get(0).(int64), args.Error(1)
}

func (m *MockRepository) GetActiveUsers(ctx context.Context) (int64, error) {
	args := m.Called(ctx)
	return args.Get(0).(int64), args.Error(1)
}

// Add all other required Repository methods as stubs
func (m *MockRepository) Ping(ctx context.Context) error { return nil }
func (m *MockRepository) CreatePermission(ctx context.Context, permission interface{}) (interface{}, error) {
	return nil, nil
}

// ... (add all other repository methods as stubs)

func TestService_Stats(t *testing.T) {
	ctx := context.Background()
	mockRepo := new(MockRepository)

	// Mock the expected calls
	mockRepo.On("GetTotalUsers", mock.Anything).Return(int64(150), nil)
	mockRepo.On("GetTotalPermissions", mock.Anything).Return(int64(25), nil)
	mockRepo.On("GetTotalGroups", mock.Anything).Return(int64(8), nil)
	mockRepo.On("GetActiveUsers", mock.Anything).Return(int64(75), nil)

	// Create service with mock repository
	service := &Service{
		repo: mockRepo,
		cfg:  &Config{},
	}

	// Test the Stats method
	req := &openauth_v1.StatsRequest{}
	response, err := service.Stats(ctx, req)

	// Assertions
	assert.NoError(t, err)
	assert.NotNil(t, response)
	assert.Equal(t, int64(150), response.TotalUsers)
	assert.Equal(t, int64(25), response.TotalPermissions)
	assert.Equal(t, int64(8), response.TotalGroups)
	assert.Equal(t, int64(75), response.ActiveUsers)

	// Verify that all expectations were met
	mockRepo.AssertExpectations(t)
}
