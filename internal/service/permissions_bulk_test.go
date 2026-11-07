package service

import (
	"context"
	"testing"

	"github.com/gofreego/openauth/api/openauth_v1"
	"github.com/gofreego/openauth/internal/models/dao"
	"github.com/gofreego/openauth/pkg/jwtutils"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// permissionsRepo keeps permissions by name; anything else panics.
type permissionsRepo struct {
	Repository
	byName map[string]*dao.Permission
}

func (r *permissionsRepo) GetPermissionByName(_ context.Context, name string) (*dao.Permission, error) {
	if p, ok := r.byName[name]; ok {
		return p, nil
	}
	return nil, nil
}

func (r *permissionsRepo) CreatePermission(_ context.Context, p *dao.Permission) (*dao.Permission, error) {
	p.ID = int64(len(r.byName) + 1)
	r.byName[p.Name] = p
	return p, nil
}

func asUser(perms ...string) context.Context {
	return context.WithValue(context.Background(), jwtutils.JWT_CLAIM_KEY_USER, &jwtutils.JWTClaims{UserID: 9, Permissions: perms})
}

func TestBulkCreatePermissions(t *testing.T) {
	repo := &permissionsRepo{byName: map[string]*dao.Permission{"openpay:products:read": {ID: 1, Name: "openpay:products:read"}}}
	s := &Service{repo: repo}
	req := &openauth_v1.BulkCreatePermissionsRequest{Permissions: []*openauth_v1.CreatePermissionRequest{
		{Name: "openpay:products:read", DisplayName: "Read products"},   // exists: skipped
		{Name: "openpay:products:write", DisplayName: "Write products"}, // created
		{Name: "openpay:products:write", DisplayName: "Write products"}, // repeated: skipped
		{Name: "x", DisplayName: "Too short"},                           // invalid: failed
	}}

	if _, err := s.BulkCreatePermissions(asUser("users.read"), req); status.Code(err) != codes.PermissionDenied {
		t.Fatalf("without permissions.create: %v", err)
	}

	resp, err := s.BulkCreatePermissions(asUser("permissions.create"), req)
	if err != nil {
		t.Fatal(err)
	}
	if len(resp.Created) != 1 || resp.Created[0].Name != "openpay:products:write" {
		t.Errorf("created %v", resp.Created)
	}
	if len(resp.Skipped) != 2 {
		t.Errorf("skipped %v", resp.Skipped)
	}
	if len(resp.Failed) != 1 || resp.Failed[0].Name != "x" {
		t.Errorf("failed %v", resp.Failed)
	}
}
