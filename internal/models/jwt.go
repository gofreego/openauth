package models

import "github.com/golang-jwt/jwt/v5"

// Token claims structure
type JWTClaims struct {
	UserID      string `json:"user_id"`
	UserUUID    string `json:"user_uuid"`
	SessionUUID string `json:"session_uuid"`
	DeviceID    string `json:"device_id,omitempty"`
	jwt.RegisteredClaims
}
