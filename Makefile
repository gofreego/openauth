build: clean
	go build -o bin/application .
build-linux: clean
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o bin/application .
run:
	go run main.go
test:
	go test -v ./...
clean:
	rm -f bin/application

docker: build-linux
	docker build -t openauth .
	rm -f bin/application

docker-run: docker
	@echo "Tagging image as latest"
	docker tag gobaserservice openauth:latest
	@echo "removing existing container named openauth if any"
	docker rm -f openauth || true
	@echo "Running image with name openauth, mapping ports 8085:8085 and 8086:8086"
	docker run -d --name gobaserservice -p 8085:8085 -p 8086:8086 gobaserservice:latest

install: 
	go mod tidy
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2
	go install google.golang.org/protobuf/cmd/protoc-gen-go
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.5.1
	go install github.com/gofreego/goutils/cmd/sql-migrator@v1.3.8

setup:
	sh ./api/protoc.sh
	go mod tidy

migrate:
	sql-migrator resources/configs/migrator.yaml