package constants

import "time"

// JWT Configuration Defaults
const (
	// DefaultJWTSecretKey is the fallback JWT secret key (not recommended for production)
	DefaultJWTSecretKey = "EB6264924E93BC2EE4E74BED72CF1"

	// DefaultAccessTokenTTL is the default access token expiration time
	DefaultAccessTokenTTL = 15 * time.Minute

	// DefaultRefreshTokenTTL is the default refresh token expiration time
	DefaultRefreshTokenTTL = 7 * 24 * time.Hour // 7 Days
)

// Security Configuration Defaults
const (
	// DefaultBcryptCost is the default bcrypt hashing cost
	DefaultBcryptCost = 12

	// DefaultMaxLoginAttempts is the default maximum failed login attempts before lockout
	DefaultMaxLoginAttempts = 5

	// DefaultLockoutDuration is the default account lockout duration
	DefaultLockoutDuration = 30 * time.Minute
)

// Email and SMS Configuration Defaults
const (
	// DefaultEmailVerificationSubject is the default subject for email verification
	DefaultEmailVerificationSubject = "Please verify your email"
	// DefaultEmailVerificationBody is the default body for email verification
	DefaultEmailVerificationBody = "Your verification code is: %s"
	// DefaultSMSVerificationMessage is the default message for SMS verification
	DefaultSMSVerificationMessage = "Your verification code is: %s"
)
