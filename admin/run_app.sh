#!/bin/bash

# Flutter Run Script with Constant Port
# This script runs your Flutter app on a constant port (8080)
# Usage: ./run_app.sh [mode] [device]
# mode: debug, release, profile (optional, defaults to normal)
# device: chrome, edge, firefox, web-server, etc. (optional, defaults to chrome)

PORT=8080
HOSTNAME=localhost

# Set default device to chrome, but allow override via second parameter
if [ -n "$2" ]; then
    DEVICE=$2
else
    DEVICE=chrome
fi

BROWSER_FLAGS="--web-browser-flag=--disable-features=VizDisplayCompositor"

echo "🚀 Starting Flutter app on $DEVICE at http://$HOSTNAME:$PORT"

# Check if a specific mode is requested
if [ "$1" = "debug" ]; then
    echo "📱 Running in DEBUG mode..."
    flutter run -d $DEVICE --web-port=$PORT --web-hostname=$HOSTNAME --debug $BROWSER_FLAGS
elif [ "$1" = "release" ]; then
    echo "🚀 Running in RELEASE mode..."
    flutter run -d $DEVICE --web-port=$PORT --web-hostname=$HOSTNAME --release $BROWSER_FLAGS
elif [ "$1" = "profile" ]; then
    echo "📊 Running in PROFILE mode..."
    flutter run -d $DEVICE --web-port=$PORT --web-hostname=$HOSTNAME --profile $BROWSER_FLAGS
else
    echo "🔧 Running in default mode..."
    flutter run -d $DEVICE --web-port=$PORT --web-hostname=$HOSTNAME $BROWSER_FLAGS
fi

echo "✅ App should be available at: http://$HOSTNAME:$PORT"
echo ""
echo "Usage examples:"
echo "  ./run_app.sh                    # Run in default mode with Chrome"
echo "  ./run_app.sh debug              # Run in debug mode with Chrome"
echo "  ./run_app.sh release firefox    # Run in release mode with Firefox"
echo "  ./run_app.sh profile edge       # Run in profile mode with Edge"
echo "  ./run_app.sh debug web-server   # Run in debug mode with web-server"
