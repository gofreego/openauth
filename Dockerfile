# Build stage
FROM golang:1.24-alpine AS builder

# Add git for downloading dependencies
RUN apk add --no-cache git

WORKDIR /app

# Copy go.mod and go.sum
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o application .

# Final stage
FROM alpine:latest

# Install tzdata for timezone support and ca-certificates for HTTPS
RUN apk --no-cache add tzdata ca-certificates

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/application .
# Copy other necessary files
COPY dev.yaml .
COPY api/docs /app/api/docs
COPY admin/builds/web/ /app/admin/builds/web/

RUN chmod +x application

# Expose the ports the application uses
EXPOSE 8085 8086

# Define the command to run your application
CMD [ "/app/application" ]