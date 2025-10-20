#!/bin/bash

# Canvas App Build Script
echo "🎨 Building Canvas Wallpaper Generator App..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store."
    exit 1
fi

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "❌ ImageMagick is not installed. Installing via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install imagemagick
    else
        echo "❌ Homebrew is not installed. Please install ImageMagick manually."
        exit 1
    fi
fi

# Make sure the canvas script is executable
chmod +x CanvasApp/canvas

# Build the app
echo "🔨 Building the app..."
xcodebuild -project CanvasApp.xcodeproj -scheme CanvasApp -configuration Release build

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📱 You can now run the app from Xcode or find it in the build directory."
    echo ""
    echo "To run the app:"
    echo "1. Open CanvasApp.xcodeproj in Xcode"
    echo "2. Press ⌘+R to build and run"
    echo ""
    echo "Or run from command line:"
    echo "open CanvasApp.xcodeproj"
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi
