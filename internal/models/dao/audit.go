package dao

// Audit logs for tracking changes
type AuditLog struct {
	ID         int64   `db:"id" json:"id"`
	UserID     *int64  `db:"user_id" json:"userId,omitempty"`       // who performed the action
	EntityType string  `db:"entity_type" json:"entityType"`         // e.g., users, groups
	EntityID   *int64  `db:"entity_id" json:"entityId,omitempty"`   // entity being modified (integer primary key)
	Action     string  `db:"action" json:"action"`                  // create, update, delete
	OldValues  []byte  `db:"old_values" json:"oldValues,omitempty"` // JSONB
	NewValues  []byte  `db:"new_values" json:"newValues,omitempty"` // JSONB
	Changes    []byte  `db:"changes" json:"changes,omitempty"`      // JSONB
	Reason     *string `db:"reason" json:"reason,omitempty"`
	IPAddress  *string `db:"ip_address" json:"ipAddress,omitempty"`
	UserAgent  *string `db:"user_agent" json:"userAgent,omitempty"`
	SessionID  *int64  `db:"session_id" json:"sessionId,omitempty"`
	Metadata   []byte  `db:"metadata" json:"metadata,omitempty"` // JSONB
	Severity   string  `db:"severity" json:"severity"`           // low, medium, high, critical
	CreatedAt  int64   `db:"created_at" json:"createdAt"`
}

// Security events table
type SecurityEvent struct {
	ID          int64   `db:"id" json:"id"`
	UserID      *int64  `db:"user_id" json:"userId,omitempty"`
	EventType   string  `db:"event_type" json:"eventType"` // e.g., login_success
	Severity    string  `db:"severity" json:"severity"`    // low, medium, high
	Description *string `db:"description" json:"description,omitempty"`
	IPAddress   *string `db:"ip_address" json:"ipAddress,omitempty"`
	UserAgent   *string `db:"user_agent" json:"userAgent,omitempty"`
	Location    *string `db:"location" json:"location,omitempty"`
	DeviceID    *string `db:"device_id" json:"deviceId,omitempty"`
	SessionID   *int64  `db:"session_id" json:"sessionId,omitempty"`
	Metadata    []byte  `db:"metadata" json:"metadata,omitempty"` // JSONB
	Resolved    bool    `db:"resolved" json:"resolved"`
	ResolvedBy  *int64  `db:"resolved_by" json:"resolvedBy,omitempty"`
	ResolvedAt  *int64  `db:"resolved_at" json:"resolvedAt,omitempty"`
	CreatedAt   int64   `db:"created_at" json:"createdAt"`
}

// Login attempts tracking
type LoginAttempt struct {
	ID             int64   `db:"id" json:"id"`
	Identifier     string  `db:"identifier" json:"identifier"`          // username/email/phone
	IdentifierType string  `db:"identifier_type" json:"identifierType"` // username, email, phone
	IPAddress      string  `db:"ip_address" json:"ipAddress"`
	UserAgent      *string `db:"user_agent" json:"userAgent,omitempty"`
	Success        bool    `db:"success" json:"success"`
	FailureReason  *string `db:"failure_reason" json:"failureReason,omitempty"`
	UserID         *int64  `db:"user_id" json:"userId,omitempty"`
	SessionID      *int64  `db:"session_id" json:"sessionId,omitempty"`
	CreatedAt      int64   `db:"created_at" json:"createdAt"`
}
