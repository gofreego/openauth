package dao

import (
	"encoding/json"
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
)

// ConfigEntity represents the config_entities table
type ConfigEntity struct {
	ID          int64   `db:"id" json:"id"`
	Name        string  `db:"name" json:"name"`
	DisplayName *string `db:"display_name" json:"displayName,omitempty"`
	Description *string `db:"description" json:"description,omitempty"`
	ReadPerm    int64   `db:"read_perm" json:"readPerm"`
	WritePerm   int64   `db:"write_perm" json:"writePerm"`
	CreatedBy   int64   `db:"created_by" json:"createdBy"`
	CreatedAt   int64   `db:"created_at" json:"createdAt"`
	UpdatedAt   int64   `db:"updated_at" json:"updatedAt"`
}

// Config represents the configs table
type Config struct {
	ID          int64           `db:"id" json:"id"`
	EntityID    int64           `db:"entity_id" json:"entityId"`
	Key         string          `db:"key" json:"key"`
	DisplayName *string         `db:"display_name" json:"displayName,omitempty"`
	Description *string         `db:"description" json:"description,omitempty"`
	Value       json.RawMessage `db:"value" json:"value,omitempty"`
	Type        string          `db:"type" json:"type"`
	Metadata    json.RawMessage `db:"metadata" json:"metadata,omitempty"`
	CreatedBy   int64           `db:"created_by" json:"createdBy"`
	UpdatedBy   int64           `db:"updated_by" json:"updatedBy"`
	CreatedAt   int64           `db:"created_at" json:"createdAt"`
	UpdatedAt   int64           `db:"updated_at" json:"updatedAt"`
}

// FromCreateConfigEntityRequest creates a ConfigEntity from a protobuf request
func (ce *ConfigEntity) FromCreateConfigEntityRequest(req *openauth_v1.CreateConfigEntityRequest, createdBy int64) *ConfigEntity {
	ce.Name = req.Name
	ce.DisplayName = req.DisplayName
	ce.Description = req.Description
	ce.ReadPerm = req.ReadPerm
	ce.WritePerm = req.WritePerm
	ce.CreatedBy = createdBy
	ce.CreatedAt = time.Now().UnixMilli()
	ce.UpdatedAt = time.Now().UnixMilli()
	return ce
}

// ToProtoConfigEntity converts a ConfigEntity DAO to protobuf ConfigEntity
func (ce *ConfigEntity) ToProtoConfigEntity() *openauth_v1.ConfigEntity {
	proto := &openauth_v1.ConfigEntity{
		Id:        ce.ID,
		Name:      ce.Name,
		ReadPerm:  ce.ReadPerm,
		WritePerm: ce.WritePerm,
		CreatedBy: ce.CreatedBy,
		CreatedAt: ce.CreatedAt,
		UpdatedAt: ce.UpdatedAt,
	}

	if ce.DisplayName != nil {
		proto.DisplayName = ce.DisplayName
	}

	if ce.Description != nil {
		proto.Description = ce.Description
	}

	return proto
}

// FromCreateConfigRequest creates a Config from a protobuf request
func (c *Config) FromCreateConfigRequest(req *openauth_v1.CreateConfigRequest, createdBy int64) *Config {
	c.EntityID = req.EntityId
	c.Key = req.Key
	c.DisplayName = req.DisplayName
	c.Description = req.Description
	c.Type = req.Type
	c.CreatedBy = createdBy
	c.UpdatedBy = createdBy
	c.CreatedAt = time.Now().UnixMilli()
	c.UpdatedAt = time.Now().UnixMilli()

	// Handle value based on type
	if req.Value != nil {
		switch v := req.Value.(type) {
		case *openauth_v1.CreateConfigRequest_StringValue:
			c.SetValue(v.StringValue)
		case *openauth_v1.CreateConfigRequest_IntValue:
			c.SetValue(v.IntValue)
		case *openauth_v1.CreateConfigRequest_FloatValue:
			c.SetValue(v.FloatValue)
		case *openauth_v1.CreateConfigRequest_BoolValue:
			c.SetValue(v.BoolValue)
		case *openauth_v1.CreateConfigRequest_JsonValue:
			var jsonValue interface{}
			if err := json.Unmarshal([]byte(v.JsonValue), &jsonValue); err == nil {
				c.SetValue(jsonValue)
			} else {
				c.SetValue(v.JsonValue) // Store as string if JSON parsing fails
			}
		}
	}

	// Handle metadata
	if req.Metadata != nil {
		c.Metadata = []byte(*req.Metadata)
	}

	return c
}

// FromUpdateConfigRequest updates a Config from a protobuf request
func (c *Config) FromUpdateConfigRequest(req *openauth_v1.UpdateConfigRequest, updatedBy int64) *Config {
	if req.DisplayName != nil {
		c.DisplayName = req.DisplayName
	}

	if req.Description != nil {
		c.Description = req.Description
	}

	// Handle value updates
	if req.Value != nil {
		switch v := req.Value.(type) {
		case *openauth_v1.UpdateConfigRequest_StringValue:
			c.SetValue(v.StringValue)
		case *openauth_v1.UpdateConfigRequest_IntValue:
			c.SetValue(v.IntValue)
		case *openauth_v1.UpdateConfigRequest_FloatValue:
			c.SetValue(v.FloatValue)
		case *openauth_v1.UpdateConfigRequest_BoolValue:
			c.SetValue(v.BoolValue)
		case *openauth_v1.UpdateConfigRequest_JsonValue:
			var jsonValue interface{}
			if err := json.Unmarshal([]byte(v.JsonValue), &jsonValue); err == nil {
				c.SetValue(jsonValue)
			} else {
				c.SetValue(v.JsonValue) // Store as string if JSON parsing fails
			}
		}
	}

	// Handle metadata updates
	if req.Metadata != nil {
		c.Metadata = []byte(*req.Metadata)
	}

	c.UpdatedBy = updatedBy
	c.UpdatedAt = time.Now().UnixMilli()

	return c
}

// ToProtoConfig converts a Config DAO to protobuf Config
func (c *Config) ToProtoConfig() *openauth_v1.Config {
	proto := &openauth_v1.Config{
		Id:        c.ID,
		EntityId:  c.EntityID,
		Key:       c.Key,
		Type:      c.Type,
		CreatedBy: c.CreatedBy,
		UpdatedBy: c.UpdatedBy,
		CreatedAt: c.CreatedAt,
		UpdatedAt: c.UpdatedAt,
	}

	if c.DisplayName != nil {
		proto.DisplayName = c.DisplayName
	}

	if c.Description != nil {
		proto.Description = c.Description
	}

	// Handle value conversion based on type
	if len(c.Value) > 0 {
		switch c.Type {
		case "string":
			var stringValue string
			if err := json.Unmarshal(c.Value, &stringValue); err == nil {
				proto.Value = &openauth_v1.Config_StringValue{StringValue: stringValue}
			}
		case "int":
			var intValue int64
			if err := json.Unmarshal(c.Value, &intValue); err == nil {
				proto.Value = &openauth_v1.Config_IntValue{IntValue: intValue}
			}
		case "float":
			var floatValue float64
			if err := json.Unmarshal(c.Value, &floatValue); err == nil {
				proto.Value = &openauth_v1.Config_FloatValue{FloatValue: floatValue}
			}
		case "bool":
			var boolValue bool
			if err := json.Unmarshal(c.Value, &boolValue); err == nil {
				proto.Value = &openauth_v1.Config_BoolValue{BoolValue: boolValue}
			}
		case "json", "choice":
			proto.Value = &openauth_v1.Config_JsonValue{JsonValue: string(c.Value)}
		}
	}

	// Handle metadata conversion
	if len(c.Metadata) > 0 {
		proto.Metadata = string(c.Metadata)
	}

	return proto
}

// SetValue sets the config value from any type
func (c *Config) SetValue(value interface{}) error {
	valueBytes, err := json.Marshal(value)
	if err != nil {
		return err
	}
	c.Value = valueBytes
	return nil
}
