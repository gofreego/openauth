package main

import (
	"context"
	"fmt"
	"time"

	"github.com/gofreego/openauth/pkg/clients/openauth"
)

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

func main() {
	cfg := &MyConfig{}
	reader := openauth.NewOpenAuthConfigReader(&openauth.ClientConfig{
		Host:     "localhost:8086",
		Username: "admin",
		Password: "admin123",
		TLS:      false,
		Timeout:  5 * time.Second,
	}, openauth.ReadOptions{
		Watch:         true,
		DelayDuration: 3 * time.Second, // 3 seconds
		OnChange: func(entity, key string, oldValue, newValue any) {
			fmt.Printf("Config changed - Entity: %s, Key: %s, Old Value: %v, New Value: %v\n", entity, key, oldValue, newValue)
		},
	})

	err := reader.ReadConfig(context.Background(), cfg)

	if err != nil {
		panic(err)
	}

	fmt.Printf("Config: %+v\n", cfg)
	time.Sleep(10 * time.Minute)
}
