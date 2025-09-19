package openauth

import (
	"context"
	"testing"

	"github.com/gofreego/openauth/api/openauth_v1"
)

type fetcher struct {
}

func (f *fetcher) GetConfigsByKeys(ctx context.Context, in *openauth_v1.GetConfigsByKeysRequest) (*openauth_v1.GetConfigsByKeysResponse, error) {
	if in.EntityName == "openauth2" {
		return &openauth_v1.GetConfigsByKeysResponse{
			Configs: map[string]*openauth_v1.Config{
				"field3": {
					Type: openauth_v1.ValueType_VALUE_TYPE_STRING,
					Value: &openauth_v1.Config_StringValue{
						StringValue: "value3",
					},
				},
			},
		}, nil
	}
	return &openauth_v1.GetConfigsByKeysResponse{
		Configs: map[string]*openauth_v1.Config{
			"int": {
				Type: openauth_v1.ValueType_VALUE_TYPE_INT,
				Value: &openauth_v1.Config_IntValue{
					IntValue: 1,
				},
			},
			"str": {
				Type: openauth_v1.ValueType_VALUE_TYPE_STRING,
				Value: &openauth_v1.Config_StringValue{
					StringValue: "string",
				},
			},
			"bool": {
				Type: openauth_v1.ValueType_VALUE_TYPE_BOOL,
				Value: &openauth_v1.Config_BoolValue{
					BoolValue: true,
				},
			},
			"float": {
				Type: openauth_v1.ValueType_VALUE_TYPE_FLOAT,
				Value: &openauth_v1.Config_FloatValue{
					FloatValue: 1.23,
				},
			},
			"struct": {
				Type: openauth_v1.ValueType_VALUE_TYPE_JSON,
				Value: &openauth_v1.Config_JsonValue{
					JsonValue: `{"Field1":"value1","Field2":2}`,
				},
			},
		},
	}, nil
}

type MyConfig struct {
	Int    int     `entity:"openauth" key:"int"`
	Str    string  `entity:"openauth" key:"str"`
	Bool   bool    `entity:"openauth" key:"bool"`
	Float  float64 `entity:"openauth" key:"float"`
	Struct struct {
		Field1 string
		Field2 int
	} `entity:"openauth" key:"struct"`
	Struct1 struct {
		Field3 string `entity:"openauth2" key:"field3"`
	}
}

func TestReadConfig(t *testing.T) {
	tests := []struct {
		name string // description of this test case
		// Named input parameters for target function.
		reader  *ConfigReader
		cfg     any
		options []ReadOptions
		wantErr bool
	}{
		{
			name:    "basic test",
			reader:  NewConfigReader(&fetcher{}),
			cfg:     &MyConfig{},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			gotErr := tt.reader.ReadConfig(context.Background(), tt.cfg)
			if gotErr != nil {
				if !tt.wantErr {
					t.Errorf("ReadConfig() failed: %v", gotErr)
				}
				return
			}
			if tt.wantErr {
				t.Fatal("ReadConfig() succeeded unexpectedly")
			}
			// Validate the populated cfg
			if cfg, ok := tt.cfg.(*MyConfig); ok {
				if cfg.Int != 1 {
					t.Errorf("expected Int to be 1, got %d", cfg.Int)
				}
				if cfg.Str != "string" {
					t.Errorf("expected Str to be 'string', got %s", cfg.Str)
				}
				if cfg.Bool != true {
					t.Errorf("expected Bool to be true, got %v", cfg.Bool)
				}
				if cfg.Float != 1.23 {
					t.Errorf("expected Float to be 1.23, got %f", cfg.Float)
				}
				if cfg.Struct.Field1 != "value1" || cfg.Struct.Field2 != 2 {
					t.Errorf("expected Struct to be {Field1: 'value1', Field2: 2}, got %+v", cfg.Struct)
				}
				if cfg.Struct1.Field3 != "value3" {
					t.Errorf("expected Struct1.Field3 to be 'value3', got %s", cfg.Struct1.Field3)
				}
			} else {
				t.Errorf("cfg is not of type *MyConfig")
			}
		})
	}
}
