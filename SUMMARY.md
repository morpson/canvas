# Canvas - Beautiful macOS Wallpaper Generator App

## 🎨 What We Built

I've created a **super pleasant, sleek, and simple to use** macOS app that provides a beautiful SwiftUI interface for your Canvas wallpaper generator bash script.

## ✨ Key Features

### Modern UI Design
- **Clean, intuitive interface** built with SwiftUI
- **Sidebar navigation** for easy wallpaper type selection
- **Real-time color pickers** with native macOS color selection
- **Live preview window** to see wallpapers before setting them
- **Responsive layout** that adapts to different window sizes

### Wallpaper Types Supported
- 🎨 **Solid Color** - Single color backgrounds
- 🌈 **Linear Gradient** - Two-color gradients with angle control (0-360°)
- ⭕ **Radial Gradient** - Circular gradients with shape options
- 🌪️ **Twisted Gradient** - Swirled gradient effects with twist control
- 🔲 **Bilinear Gradient** - Four-corner color gradients
- ⚡ **Plasma** - Colorful fractal patterns
- 🌫️ **Blurred Noise** - Abstract noise patterns with blur control
- 🎲 **Random** - Surprise combinations of all types

### Smart Features
- **Multiple resolutions** (1366x768, 1920x1080, 2560x1440, 3840x2160)
- **One-click wallpaper setting** - automatically sets as desktop background
- **Preview before setting** - see your creation before applying
- **macOS integration** - uses native wallpaper setting APIs
- **Error handling** - graceful fallbacks and user feedback

## 🏗️ Technical Architecture

### SwiftUI App Structure
```
CanvasApp/
├── CanvasApp.swift          # Main app entry point
├── ContentView.swift        # Main UI with sidebar and panels
├── WallpaperGenerator.swift # Core generation logic and script integration
├── ColorPickerView.swift    # Dynamic color selection interface
├── WallpaperPreviewView.swift # Preview window with actions
├── canvas                   # macOS-compatible bash script
└── Assets.xcassets/         # App icons and resources
```

### Backend Integration
- **Modified bash script** for macOS compatibility
- **ImageMagick integration** for wallpaper generation
- **Process management** for script execution
- **File system integration** for wallpaper storage and retrieval

## 🚀 Getting Started

### Prerequisites
```bash
# Install ImageMagick
brew install imagemagick
```

### Build and Run
```bash
# Quick start
./build.sh

# Or manually
open CanvasApp.xcodeproj
# Press ⌘+R in Xcode
```

### Usage
1. **Select wallpaper type** from the sidebar
2. **Choose colors** using the native color pickers
3. **Adjust parameters** (angle, blur, twist, etc.)
4. **Generate wallpaper** with one click
5. **Preview and set** as your desktop background

## 🎯 User Experience Highlights

### Intuitive Design
- **Visual feedback** for all interactions
- **Contextual controls** that appear based on wallpaper type
- **Progress indicators** during generation
- **Error messages** with helpful suggestions

### Accessibility
- **Native macOS controls** for familiar feel
- **Keyboard navigation** support
- **High contrast** color schemes
- **Responsive text** sizing

### Performance
- **Background processing** for smooth UI
- **Efficient image handling** with proper memory management
- **Fast generation** using optimized ImageMagick commands
- **Cached previews** for quick viewing

## 🔧 Customization Options

### Wallpaper Parameters
- **Size selection** from common resolutions
- **Color customization** with hex and named color support
- **Effect intensity** controls (blur, twist, angle)
- **Random generation** for creative inspiration

### App Behavior
- **Auto-set wallpaper** toggle
- **Preview preferences** configuration
- **Output directory** management
- **Script integration** options

## 📱 Screenshots & Demo

The app features:
- **Elegant header** with app branding
- **Organized sidebar** with wallpaper type icons
- **Dynamic main panel** that adapts to selected type
- **Color picker grid** for multi-color wallpapers
- **Options panel** for size and behavior settings
- **Preview window** with generation and setting actions

## 🎉 Result

You now have a **professional-grade macOS app** that transforms your command-line wallpaper generator into a beautiful, user-friendly application. The interface is:

- ✅ **Super pleasant** - Clean, modern design with smooth animations
- ✅ **Sleek** - Minimalist layout with intuitive navigation
- ✅ **Simple to use** - One-click generation with smart defaults
- ✅ **Powerful** - Full feature set with advanced customization
- ✅ **Native** - Built specifically for macOS with proper integration

The app successfully bridges the gap between powerful command-line tools and user-friendly graphical interfaces, making your Canvas wallpaper generator accessible to everyone!
