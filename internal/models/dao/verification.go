package dao

type OTPVerification struct {
	ID          int64   `db:"id" json:"id"`
	UserID      *int64  `db:"user_id" json:"userId,omitempty"`
	Email       *string `db:"email" json:"email,omitempty"`
	Phone       *string `db:"phone" json:"phone,omitempty"`
	OTPCode     string  `db:"otp_code" json:"otpCode"`
	OTPType     string  `db:"otp_type" json:"otpType"` // emailVerification, phoneVerification, passwordReset, login
	IsUsed      bool    `db:"is_used" json:"isUsed"`
	ExpiresAt   int64   `db:"expires_at" json:"expiresAt"`
	Attempts    int     `db:"attempts" json:"attempts"`
	MaxAttempts int     `db:"max_attempts" json:"maxAttempts"`
	CreatedAt   int64   `db:"created_at" json:"createdAt"`
}

type PasswordResetToken struct {
	ID        int64  `db:"id" json:"id"`
	UserID    int64  `db:"user_id" json:"userId"`
	Token     string `db:"token" json:"token"`
	ExpiresAt int64  `db:"expires_at" json:"expiresAt"`
	IsUsed    bool   `db:"is_used" json:"isUsed"`
	CreatedAt int64  `db:"created_at" json:"createdAt"`
}

type EmailVerificationToken struct {
	ID        int64  `db:"id" json:"id"`
	UserID    int64  `db:"user_id" json:"userId"`
	Email     string `db:"email" json:"email"`
	Token     string `db:"token" json:"token"`
	ExpiresAt int64  `db:"expires_at" json:"expiresAt"`
	IsUsed    bool   `db:"is_used" json:"isUsed"`
	CreatedAt int64  `db:"created_at" json:"createdAt"`
}
