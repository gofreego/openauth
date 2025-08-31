package utils

import (
	"regexp"
	"strings"
)

// IdentifierType represents the type of user identifier
type IdentifierType int

const (
	IdentifierTypeUnknown IdentifierType = iota
	IdentifierTypeUsername
	IdentifierTypeEmail
	IdentifierTypePhone
)

var (
	// Email regex pattern - basic but covers most common cases
	emailRegex = regexp.MustCompile(`^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`)

	// Phone regex pattern - supports various formats including international
	// Examples: +1234567890, +1-234-567-8900, (123) 456-7890, 123-456-7890, 1234567890
	phoneRegex = regexp.MustCompile(`^(\+\d{1,3}[-.\s]?)?(\(?\d{3}\)?[-.\s]?)?\d{3}[-.\s]?\d{4}$`)
)

// DetectIdentifierType determines the type of identifier based on its format
func DetectIdentifierType(identifier string) IdentifierType {
	if identifier == "" {
		return IdentifierTypeUnknown
	}

	// Clean the identifier
	cleaned := strings.TrimSpace(identifier)

	// Check if it's an email
	if emailRegex.MatchString(cleaned) {
		return IdentifierTypeEmail
	}

	// Check if it's a phone number
	if phoneRegex.MatchString(cleaned) {
		return IdentifierTypePhone
	}

	// If it's neither email nor phone, assume it's a username
	return IdentifierTypeUsername
}

// String returns the string representation of the identifier type
func (it IdentifierType) String() string {
	switch it {
	case IdentifierTypeUsername:
		return "username"
	case IdentifierTypeEmail:
		return "email"
	case IdentifierTypePhone:
		return "phone"
	default:
		return "unknown"
	}
}
