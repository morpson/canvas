#!/bin/bash

# Canvas App Demo Script
echo "🎨 Canvas Wallpaper Generator - Demo"
echo "====================================="
echo ""

# Check if the canvas script works
echo "Testing the canvas script..."
if ./canvas-simple --help &> /dev/null; then
    echo "✅ Canvas script is working"
else
    echo "❌ Canvas script has issues. Please check ImageMagick installation."
    exit 1
fi

echo ""
echo "📱 SwiftUI App Features:"
echo "• Modern, intuitive interface"
echo "• Real-time color picker"
echo "• Live wallpaper preview"
echo "• Multiple wallpaper types"
echo "• One-click wallpaper setting"
echo "• Support for various resolutions"
echo ""

echo "🚀 To get started:"
echo "1. Run: ./build.sh"
echo "2. Open CanvasApp.xcodeproj in Xcode"
echo "3. Press ⌘+R to build and run"
echo ""

echo "🎯 Available wallpaper types:"
echo "• Solid Color - Single color backgrounds"
echo "• Linear Gradient - Two-color gradients with angle control"
echo "• Radial Gradient - Circular gradients with shape options"
echo "• Twisted Gradient - Swirled gradient effects"
echo "• Bilinear Gradient - Four-corner color gradients"
echo "• Plasma - Colorful fractal patterns"
echo "• Blurred Noise - Abstract noise patterns"
echo "• Random - Surprise me with random combinations"
echo ""

echo "✨ The app provides a beautiful interface for all these features!"
