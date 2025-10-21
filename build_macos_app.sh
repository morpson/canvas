#!/bin/bash

# Canvas macOS App Build Script
echo "🎨 Building Canvas macOS App..."

# Check if required tools are available
if ! command -v swiftc &> /dev/null; then
    echo "❌ Swift compiler not found. Please install Xcode Command Line Tools."
    exit 1
fi

if ! command -v sips &> /dev/null; then
    echo "❌ sips not found. This tool is required for icon generation."
    exit 1
fi

if ! command -v iconutil &> /dev/null; then
    echo "❌ iconutil not found. This tool is required for icon generation."
    exit 1
fi

# Create app bundle structure
echo "📁 Creating app bundle structure..."
mkdir -p Canvas.app/Contents/{MacOS,Resources}

# Create Info.plist
echo "📄 Creating Info.plist..."
cat > Canvas.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>Canvas</string>
  <key>CFBundleIdentifier</key>
  <string>com.canvas.wallpaper</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>Canvas</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSMinimumSystemVersion</key>
  <string>14.0</string>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>CFBundleIconFile</key>
  <string>AppIcon</string>
</dict>
</plist>
EOF

# Generate app icons
echo "🎨 Generating app icons..."
mkdir -p AppIcon.iconset

# Create all required icon sizes from the dark variant
sips -z 16 16 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_16x16.png > /dev/null 2>&1
sips -z 32 32 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_16x16@2x.png > /dev/null 2>&1
sips -z 32 32 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_32x32.png > /dev/null 2>&1
sips -z 64 64 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_32x32@2x.png > /dev/null 2>&1
sips -z 128 128 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_128x128.png > /dev/null 2>&1
sips -z 256 256 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_128x128@2x.png > /dev/null 2>&1
sips -z 256 256 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_256x256.png > /dev/null 2>&1
sips -z 512 512 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_256x256@2x.png > /dev/null 2>&1
sips -z 512 512 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_512x512.png > /dev/null 2>&1
sips -z 512 512 canvas_ico/canvas-macOS-Dark-1024x1024@2x.png --out AppIcon.iconset/icon_512x512@2x.png > /dev/null 2>&1

# Create .icns file
iconutil -c icns AppIcon.iconset -o Canvas.app/Contents/Resources/AppIcon.icns

# Copy all appearance variants for macOS 26+ support
cp canvas_ico/*.png Canvas.app/Contents/Resources/

# Clean up temporary files
rm -rf AppIcon.iconset

# Compile Swift app
echo "🔨 Compiling Swift application..."
swiftc -parse-as-library -o Canvas canvas_app_full.swift -framework SwiftUI -framework AppKit

if [ $? -ne 0 ]; then
    echo "❌ Swift compilation failed"
    exit 1
fi

# Copy executable to app bundle
cp Canvas Canvas.app/Contents/MacOS/Canvas
chmod +x Canvas.app/Contents/MacOS/Canvas
rm Canvas

echo "✅ Canvas.app built successfully!"
echo "📱 You can now run the app by double-clicking Canvas.app"
echo ""
echo "To install to Applications folder:"
echo "cp -R Canvas.app /Applications/"