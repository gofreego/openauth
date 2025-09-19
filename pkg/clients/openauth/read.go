package openauth

import (
	"context"
	"encoding/json"
	"fmt"
	"reflect"
	"strconv"
	"time"

	"github.com/gofreego/goutils/logger"
	"github.com/gofreego/openauth/api/openauth_v1"
)

type entity struct {
	Entity         string
	Keys           []string
	Fields         map[string]any                 // field key to pointer mapping
	previousValues map[string]*openauth_v1.Config // to store previous values for change detection
}

type config_map struct {
	configs []entity
}

type ConfigFetcher interface {
	GetConfigsByKeys(ctx context.Context, in *openauth_v1.GetConfigsByKeysRequest) (*openauth_v1.GetConfigsByKeysResponse, error)
}

type ReadOptions struct {
	Watch         bool                                             // if true, will watch for config changes and update cfg accordingly
	DelayDuration time.Duration                                    // duration between each watch check, default is 1 minute
	OnChange      func(entity, key string, oldValue, newValue any) // callback function invoked when a config value changes
}

type ConfigReader struct {
	fetcher ConfigFetcher
	options *ReadOptions
}

func NewConfigReader(fetcher ConfigFetcher, options ...ReadOptions) *ConfigReader {
	var opts ReadOptions
	if len(options) > 0 {
		opts = options[0]
	}
	return &ConfigReader{
		fetcher: fetcher,
		options: &opts,
	}
}

func NewOpenAuthConfigReader(cfg *ClientConfig, options ...ReadOptions) *ConfigReader {
	fetcher, err := NewOpenauthClient(context.Background(), cfg)
	if err != nil {
		panic(fmt.Sprintf("failed to create Openauth client: %v", err))
	}
	return NewConfigReader(fetcher, options...)
}

// reads configuration into the provided cfg structure based on its tags
// cfg should be a pointer to a struct with appropriate tags
// Example:
//
//	type MyConfig struct {
//	    Key   string `entity:"openauth" key:"key"`
//	    Value string `entity:"openauth" key:"value"`
//	}
//
// myConfig := &MyConfig{}
// err := configReader.Read(ctx, myConfig)
// This will populate myConfig.Key and myConfig.Value with the corresponding config values
func (r *ConfigReader) ReadConfig(ctx context.Context, cfg any) error {
	cfgMap, err := buildConfigMap(cfg)
	if err != nil {
		return err
	}
	// store the config map for this cfg
	if err := r.read(ctx, cfgMap); err != nil {
		return err
	}
	go r.watch(ctx, cfgMap)

	return nil
}

func (r *ConfigReader) read(ctx context.Context, cfgs *config_map) error {
	for i := range cfgs.configs {
		req := &openauth_v1.GetConfigsByKeysRequest{
			EntityName: cfgs.configs[i].Entity,
			Keys:       cfgs.configs[i].Keys,
		}
		resp, err := r.fetcher.GetConfigsByKeys(ctx, req)
		if err != nil {
			return err
		}

		// Process each config in the response
		for key, config := range resp.GetConfigs() {
			// Find the corresponding field pointer in our config map
			if fieldPtr, exists := cfgs.configs[i].Fields[key]; exists {
				// Check if the value has changed
				prevConfig, hadPrev := cfgs.configs[i].previousValues[key]
				if hadPrev {
					// Compare previous and current config values
					if prevConfig.Type == config.Type {
						same := false
						switch config.Type {
						case openauth_v1.ValueType_VALUE_TYPE_STRING:
							same = prevConfig.GetStringValue() == config.GetStringValue()
						case openauth_v1.ValueType_VALUE_TYPE_INT:
							same = prevConfig.GetIntValue() == config.GetIntValue()
						case openauth_v1.ValueType_VALUE_TYPE_FLOAT:
							same = prevConfig.GetFloatValue() == config.GetFloatValue()
						case openauth_v1.ValueType_VALUE_TYPE_BOOL:
							same = prevConfig.GetBoolValue() == config.GetBoolValue()
						case openauth_v1.ValueType_VALUE_TYPE_JSON:
							same = prevConfig.GetJsonValue() == config.GetJsonValue()
						}
						if same {
							// No change in value, skip updating
							continue
						}
					}
				}
				oldValue := cfgs.configs[i].previousValues[key]
				// Update the previous value
				cfgs.configs[i].previousValues[key] = config

				if err := setFieldValue(fieldPtr, config); err != nil {
					return fmt.Errorf("failed to set field value for key %s: %w", key, err)
				}

				// Invoke OnChange callback if provided
				if r.options != nil && r.options.OnChange != nil {
					var oldV any
					if oldValue != nil {
						oldV = oldValue.Value
					}
					r.options.OnChange(cfgs.configs[i].Entity, key, oldV, config.Value)
				}
			}
		}
	}
	return nil
}

func (r *ConfigReader) watch(ctx context.Context, cfgs *config_map, options ...ReadOptions) {
	var opts ReadOptions
	if len(options) > 0 {
		opts = options[0]
	}
	if !opts.Watch {
		return
	}
	if opts.DelayDuration <= 0 {
		// set default delay duration to 1 minute
		opts.DelayDuration = time.Minute
	}

	ticker := time.NewTicker(opts.DelayDuration)
	defer ticker.Stop()

	for {
		select {
		case <-ctx.Done():
			return
		case <-ticker.C:
			err := r.read(ctx, cfgs)
			if err != nil {
				logger.Error(ctx, "Error reading config during watch: %v", err)
			}
		}
	}
}

func buildConfigMap(cfg any) (*config_map, error) {
	v := reflect.ValueOf(cfg)
	if v.Kind() != reflect.Ptr || v.Elem().Kind() != reflect.Struct {
		return nil, fmt.Errorf("cfg must be a pointer to a struct")
	}

	v = v.Elem()
	t := v.Type()

	// Map to group fields by entity
	entityMap := make(map[string]map[string]any)

	if err := processStruct(v, t, entityMap); err != nil {
		return nil, err
	}

	// Convert entity map to config_map structure
	var configs []entity

	for entityName, fields := range entityMap {
		var keys []string
		for key := range fields {
			keys = append(keys, key)
		}

		configs = append(configs, entity{
			Entity:         entityName,
			Keys:           keys,
			Fields:         fields,
			previousValues: make(map[string]*openauth_v1.Config),
		})
	}

	return &config_map{configs: configs}, nil
}

// processStruct recursively processes a struct and its nested structs
func processStruct(v reflect.Value, t reflect.Type, entityMap map[string]map[string]any) error {
	for i := 0; i < v.NumField(); i++ {
		field := v.Field(i)
		fieldType := t.Field(i)

		// Skip unexported fields
		if !field.CanSet() {
			continue
		}

		entity := fieldType.Tag.Get("entity")
		key := fieldType.Tag.Get("key")

		// If field has entity and key tags, add it to the map
		if entity != "" && key != "" {
			// Initialize entity map if not exists
			if entityMap[entity] == nil {
				entityMap[entity] = make(map[string]any)
			}

			// Store pointer to the field
			entityMap[entity][key] = field.Addr().Interface()
		} else if field.Kind() == reflect.Struct {
			// If field is a struct without tags, process it recursively
			if err := processStruct(field, field.Type(), entityMap); err != nil {
				return err
			}
		} else if field.Kind() == reflect.Ptr && field.Type().Elem().Kind() == reflect.Struct {
			// Handle pointer to struct
			if !field.IsNil() {
				// Dereference the pointer and process the struct
				if err := processStruct(field.Elem(), field.Type().Elem(), entityMap); err != nil {
					return err
				}
			}
		}
		// If field doesn't have tags and is not a struct, skip it
	}
	return nil
}

// setFieldValue sets the value of a field pointer based on the config type
func setFieldValue(fieldPtr any, config *openauth_v1.Config) error {
	rv := reflect.ValueOf(fieldPtr)
	if rv.Kind() != reflect.Ptr {
		return fmt.Errorf("fieldPtr must be a pointer")
	}

	elem := rv.Elem()
	if !elem.CanSet() {
		return fmt.Errorf("field cannot be set")
	}

	switch config.Type {
	case openauth_v1.ValueType_VALUE_TYPE_STRING:
		if elem.Kind() != reflect.String {
			return fmt.Errorf("field type mismatch: expected string, got %s", elem.Kind())
		}
		elem.SetString(config.GetStringValue())

	case openauth_v1.ValueType_VALUE_TYPE_INT:
		if elem.Kind() == reflect.Int || elem.Kind() == reflect.Int32 || elem.Kind() == reflect.Int64 {
			elem.SetInt(config.GetIntValue())
		} else {
			return fmt.Errorf("field type mismatch: expected int, got %s", elem.Kind())
		}

	case openauth_v1.ValueType_VALUE_TYPE_FLOAT:
		if elem.Kind() == reflect.Float32 || elem.Kind() == reflect.Float64 {
			elem.SetFloat(config.GetFloatValue())
		} else {
			return fmt.Errorf("field type mismatch: expected float, got %s", elem.Kind())
		}

	case openauth_v1.ValueType_VALUE_TYPE_BOOL:
		if elem.Kind() != reflect.Bool {
			return fmt.Errorf("field type mismatch: expected bool, got %s", elem.Kind())
		}
		elem.SetBool(config.GetBoolValue())

	case openauth_v1.ValueType_VALUE_TYPE_JSON:
		jsonValue := config.GetJsonValue()

		// Handle different target types for JSON
		switch elem.Kind() {
		case reflect.String:
			elem.SetString(jsonValue)
		case reflect.Slice, reflect.Map, reflect.Struct, reflect.Ptr:
			if err := json.Unmarshal([]byte(jsonValue), fieldPtr); err != nil {
				return fmt.Errorf("failed to unmarshal JSON: %w", err)
			}
		default:
			// Try to parse as string if it's a simple type
			switch elem.Kind() {
			case reflect.Int, reflect.Int32, reflect.Int64:
				if val, err := strconv.ParseInt(jsonValue, 10, 64); err == nil {
					elem.SetInt(val)
				} else {
					return fmt.Errorf("failed to parse JSON as int: %w", err)
				}
			case reflect.Float32, reflect.Float64:
				if val, err := strconv.ParseFloat(jsonValue, 64); err == nil {
					elem.SetFloat(val)
				} else {
					return fmt.Errorf("failed to parse JSON as float: %w", err)
				}
			case reflect.Bool:
				if val, err := strconv.ParseBool(jsonValue); err == nil {
					elem.SetBool(val)
				} else {
					return fmt.Errorf("failed to parse JSON as bool: %w", err)
				}
			default:
				// try to unmarshal into the field directly
				// this will work for slices, maps, structs, and pointers
				if err := json.Unmarshal([]byte(jsonValue), fieldPtr); err == nil {
					return nil
				}
				return fmt.Errorf("unsupported field type for JSON value: %s", elem.Kind())
			}
		}

	default:
		return fmt.Errorf("unsupported config type: %v", config.Type)
	}

	return nil
}
