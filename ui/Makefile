# Flutter App Makefile
# Run 'make' to see all available commands
# Device options: chrome (default), web-server

.PHONY: help run debug release profile clean build-web build-android run-web-server debug-web-server release-web-server profile-web-server
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Flutter App Commands:"
	@echo "  Default device: Chrome (can be overridden with device-specific targets)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

run: ## Run the Flutter app on port 8080 (default: Chrome)
	@echo "🚀 Starting Flutter app using run_app.sh..."
	./run_app.sh

debug: ## Run the Flutter app in debug mode (default: Chrome)
	@echo "📱 Starting Flutter app in DEBUG mode using run_app.sh..."
	./run_app.sh debug

release: ## Run the Flutter app in release mode (default: Chrome)
	@echo "🚀 Starting Flutter app in RELEASE mode using run_app.sh..."
	./run_app.sh release

profile: ## Run the Flutter app in profile mode (default: Chrome)
	@echo "� Starting Flutter app in PROFILE mode using run_app.sh..."
	./run_app.sh profile

# Web server targets
run-web-server: ## Run the Flutter app as web server (no browser)
	@echo "🖥️ Starting Flutter app as web server..."
	./run_app.sh default web-server

debug-web-server: ## Run the Flutter app in debug mode as web server
	@echo "🖥️ Starting Flutter app in DEBUG mode as web server..."
	./run_app.sh debug web-server

release-web-server: ## Run the Flutter app in release mode as web server
	@echo "🖥️ Starting Flutter app in RELEASE mode as web server..."
	./run_app.sh release web-server

profile-web-server: ## Run the Flutter app in profile mode as web server
	@echo "🖥️ Starting Flutter app in PROFILE mode as web server..."
	./run_app.sh profile web-server

clean: ## Clean Flutter build files
	@echo "🧹 Cleaning Flutter build files..."
	flutter clean

build-web: ## Build for web with production credentials
	@echo "🏗️ Building Flutter web app with production environment..."
	flutter build web --dart-define=ENVIRONMENT=production
	cp -r build/web/* builds/web/

build-android: ## Build APK for Android with production credentials
	@echo "🤖 Building Flutter Android APK with production environment..."
	export JAVA_OPTS="--enable-native-access=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED" && \
	flutter build apk --dart-define=ENVIRONMENT=production

setup: ## Set up the project with protobuf generation and dependencies
	@echo "⚙️ Copying protobuf files..."
	rm -rf ./proto
	mkdir -p ./proto
	cp -r ../api/proto/* ./proto/
	@echo "⚙️ Fixing import paths in proto files..."
	find ./proto -name "*.proto" -exec sed -i '' 's|import "proto/|import "|g' {} \;
	@echo "⚙️ Setting up buf dependencies..."
	buf dep update
	@echo "⚙️ Generating protobuf files..."
	buf generate
	@echo "⚙️ Cleaning up temporary proto files..."
	rm -rf ./proto
	@echo "⚙️ Installing Flutter dependencies..."
	flutter pub get
	@echo "✅ Setup complete!"
