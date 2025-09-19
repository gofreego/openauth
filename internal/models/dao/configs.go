package dao

import (
	"encoding/json"
	"time"

	"github.com/gofreego/openauth/api/openauth_v1"
)

type ValueType string

const (
	ValueTypeString ValueType = "string"
	ValueTypeInt    ValueType = "int"
	ValueTypeFloat  ValueType = "float"
	ValueTypeBool   ValueType = "bool"
	ValueTypeJSON   ValueType = "json"
)

func (vt ValueType) FromProto(protoType openauth_v1.ValueType) ValueType {
	switch protoType {
	case openauth_v1.ValueType_VALUE_TYPE_STRING:
		return ValueTypeString
	case openauth_v1.ValueType_VALUE_TYPE_INT:
		return ValueTypeInt
	case openauth_v1.ValueType_VALUE_TYPE_FLOAT:
		return ValueTypeFloat
	case openauth_v1.ValueType_VALUE_TYPE_BOOL:
		return ValueTypeBool
	case openauth_v1.ValueType_VALUE_TYPE_JSON:
		return ValueTypeJSON
	default:
		return ValueTypeString // default to string if unknown
	}

}

func (vt ValueType) ToProto() openauth_v1.ValueType {
	switch vt {
	case ValueTypeString:
		return openauth_v1.ValueType_VALUE_TYPE_STRING
	case ValueTypeInt:
		return openauth_v1.ValueType_VALUE_TYPE_INT
	case ValueTypeFloat:
		return openauth_v1.ValueType_VALUE_TYPE_FLOAT
	case ValueTypeBool:
		return openauth_v1.ValueType_VALUE_TYPE_BOOL
	case ValueTypeJSON:
		return openauth_v1.ValueType_VALUE_TYPE_JSON
	default:
		return openauth_v1.ValueType_VALUE_TYPE_STRING // default to string if unknown
	}
}

// ConfigEntity represents the config_entities table
type ConfigEntity struct {
	ID            int64  `db:"id" json:"id"`
	Name          string `db:"name" json:"name"`
	DisplayName   string `db:"display_name" json:"displayName,omitempty"`
	Description   string `db:"description" json:"description,omitempty"`
	ReadPerm      int64  `db:"read_perm" json:"readPerm"`
	WritePerm     int64  `db:"write_perm" json:"writePerm"`
	ReadPermName  string `db:"permission.name" json:"readPermName,omitempty"`
	WritePermName string `db:"permission.name" json:"writePermName,omitempty"`
	CreatedBy     int64  `db:"created_by" json:"createdBy"`
	CreatedAt     int64  `db:"created_at" json:"createdAt"`
	UpdatedAt     int64  `db:"updated_at" json:"updatedAt"`
}

// FromCreateConfigEntityRequest creates a ConfigEntity from a protobuf request
func (ce *ConfigEntity) FromCreateConfigEntityRequest(req *openauth_v1.CreateConfigEntityRequest, readPerm, writePerm int64, createdBy int64) *ConfigEntity {
	ce.Name = req.Name
	ce.DisplayName = req.DisplayName
	ce.Description = req.Description
	ce.ReadPerm = readPerm
	ce.WritePerm = writePerm
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
		ReadPerm:  ce.ReadPermName,
		WritePerm: ce.WritePermName,
		CreatedBy: ce.CreatedBy,
		CreatedAt: ce.CreatedAt,
		UpdatedAt: ce.UpdatedAt,
	}

	proto.DisplayName = ce.DisplayName

	proto.Description = ce.Description

	return proto
}

// Config represents the configs table
type Config struct {
	ID          int64     `db:"id" json:"id"`
	EntityID    int64     `db:"entity_id" json:"entityId"`
	Key         string    `db:"key" json:"key"`
	DisplayName string    `db:"display_name" json:"displayName,omitempty"`
	Description string    `db:"description" json:"description,omitempty"`
	Value       string    `db:"value" json:"value,omitempty"`
	Type        ValueType `db:"type" json:"type"`
	Metadata    *string   `db:"metadata" json:"metadata,omitempty"`
	CreatedBy   int64     `db:"created_by" json:"createdBy"`
	UpdatedBy   int64     `db:"updated_by" json:"updatedBy"`
	CreatedAt   int64     `db:"created_at" json:"createdAt"`
	UpdatedAt   int64     `db:"updated_at" json:"updatedAt"`
}

// FromCreateConfigRequest creates a Config from a protobuf request
func (c *Config) FromCreateConfigRequest(req *openauth_v1.CreateConfigRequest, createdBy int64) *Config {
	c.EntityID = req.EntityId
	c.Key = req.Key
	c.DisplayName = req.DisplayName
	c.Description = req.Description
	c.Type = c.Type.FromProto(req.Type)
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
	c.Metadata = req.Metadata
	return c
}

// FromUpdateConfigRequest updates a Config from a protobuf request
func (c *Config) FromUpdateConfigRequest(req *openauth_v1.UpdateConfigRequest, updatedBy int64) *Config {
	if req.Name != nil {
		c.Key = *req.Name
	}
	if req.DisplayName != nil {
		c.DisplayName = *req.DisplayName
	}
	if req.Description != nil {
		c.Description = *req.Description
	}
	// Handle value updates
	if req.Value != nil {
		switch v := req.Value.(type) {
		case *openauth_v1.UpdateConfigRequest_StringValue:
			c.SetValue(v.StringValue)
			c.Type = ValueTypeString
		case *openauth_v1.UpdateConfigRequest_IntValue:
			c.SetValue(v.IntValue)
			c.Type = ValueTypeInt
		case *openauth_v1.UpdateConfigRequest_FloatValue:
			c.SetValue(v.FloatValue)
			c.Type = ValueTypeFloat
		case *openauth_v1.UpdateConfigRequest_BoolValue:
			c.SetValue(v.BoolValue)
			c.Type = ValueTypeBool
		case *openauth_v1.UpdateConfigRequest_JsonValue:
			c.Type = ValueTypeJSON
			var jsonValue interface{}
			if err := json.Unmarshal([]byte(v.JsonValue), &jsonValue); err == nil {
				c.SetValue(jsonValue)
			} else {
				c.SetValue(v.JsonValue) // Store as string if JSON parsing fails
			}
		}
	}
	c.Metadata = req.Metadata
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
		Type:      c.Type.ToProto(),
		CreatedBy: c.CreatedBy,
		UpdatedBy: c.UpdatedBy,
		CreatedAt: c.CreatedAt,
		UpdatedAt: c.UpdatedAt,
	}

	proto.DisplayName = c.DisplayName

	proto.Description = c.Description

	// Handle value conversion based on type
	if len(c.Value) > 0 {
		value := []byte(c.Value)
		switch c.Type {
		case "string":
			var stringValue string
			if err := json.Unmarshal(value, &stringValue); err == nil {
				proto.Value = &openauth_v1.Config_StringValue{StringValue: stringValue}
			}
		case "int":
			var intValue int64
			if err := json.Unmarshal(value, &intValue); err == nil {
				proto.Value = &openauth_v1.Config_IntValue{IntValue: intValue}
			}
		case "float":
			var floatValue float64
			if err := json.Unmarshal(value, &floatValue); err == nil {
				proto.Value = &openauth_v1.Config_FloatValue{FloatValue: floatValue}
			}
		case "bool":
			var boolValue bool
			if err := json.Unmarshal(value, &boolValue); err == nil {
				proto.Value = &openauth_v1.Config_BoolValue{BoolValue: boolValue}
			}
		case "json":
			proto.Value = &openauth_v1.Config_JsonValue{JsonValue: c.Value}
		}
	}
	proto.Metadata = c.Metadata
	return proto
}

// SetValue sets the config value from any type
func (c *Config) SetValue(value interface{}) error {
	valueBytes, err := json.Marshal(value)
	if err != nil {
		return err
	}
	c.Value = string(valueBytes)
	return nil
}
