# Canvas - Wallpaper Generator App

A beautiful, modern macOS app built with SwiftUI that provides a sleek interface for the Canvas wallpaper generator script.

## Features

- **Modern UI**: Clean, intuitive interface designed with SwiftUI
- **Multiple Wallpaper Types**: 
  - Solid colors
  - Linear gradients
  - Radial gradients
  - Twisted gradients
  - Bilinear (4-point) gradients
  - Plasma effects
  - Blurred noise
  - Random generation
- **Color Picker**: Native macOS color picker integration
- **Live Preview**: See your wallpapers before setting them
- **Multiple Resolutions**: Support for various screen sizes
- **One-Click Wallpaper Setting**: Automatically set generated wallpapers as your desktop background

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later
- ImageMagick (for the underlying canvas script)

## Installation

### Prerequisites

1. Install ImageMagick:
   ```bash
   brew install imagemagick
   ```

### Building the App

1. Open `CanvasApp.xcodeproj` in Xcode
2. Select your target device/simulator
3. Build and run the project (⌘+R)

### Running from Command Line

You can also build and run from the command line:

```bash
cd CanvasApp
xcodebuild -project CanvasApp.xcodeproj -scheme CanvasApp -configuration Release build
```

## Usage

1. **Select Wallpaper Type**: Choose from the sidebar on the left
2. **Configure Colors**: Use the color pickers to select your desired colors
3. **Adjust Options**: Set resolution, angle, blur, or twist parameters as needed
4. **Generate**: Click "Generate Wallpaper" to create your wallpaper
5. **Preview**: Click "Preview" to see the generated wallpaper
6. **Set as Wallpaper**: Enable "Set as Desktop Wallpaper" or use the preview window

## Wallpaper Types

### Solid Color
Creates a solid color wallpaper with your chosen color.

### Linear Gradient
Creates a gradient between two colors with adjustable angle (0-360°).

### Radial Gradient
Creates a radial gradient with various shapes (diagonal, ellipse, maximum, minimum).

### Twisted Gradient
Creates a twisted/swirled gradient effect with adjustable twist amount (0-500).

### Bilinear Gradient
Creates a 4-point gradient using four corner colors.

### Plasma
Generates colorful plasma patterns with fractal effects.

### Blurred Noise
Creates abstract blurred noise patterns with adjustable blur strength (1-30).

### Random
Generates a random wallpaper with random colors and effects.

## File Structure

```
CanvasApp/
├── CanvasApp.swift          # Main app entry point
├── ContentView.swift        # Main UI view
├── WallpaperGenerator.swift # Core wallpaper generation logic
├── ColorPickerView.swift    # Color selection interface
├── WallpaperPreviewView.swift # Preview window
├── canvas                   # Bash script (copied from parent directory)
├── Assets.xcassets/         # App icons and assets
└── Canvas.entitlements      # App sandbox permissions
```

## Technical Details

- Built with SwiftUI for modern macOS design
- Integrates with the original Canvas bash script
- Uses NSWorkspace for setting desktop wallpapers
- Supports app sandboxing with appropriate entitlements
- Generates wallpapers in the user's Pictures/Canvas directory

## Troubleshooting

### ImageMagick Not Found
If you get errors about ImageMagick not being found:
1. Install ImageMagick: `brew install imagemagick`
2. Make sure it's in your PATH
3. Restart the app

### Permission Issues
If the app can't set wallpapers:
1. Check that the app has permission to access your Pictures folder
2. Make sure the Canvas.entitlements file is properly configured

### Script Execution Issues
If the canvas script fails to run:
1. Ensure the script has execute permissions: `chmod +x canvas`
2. Check that all dependencies (convert, feh, xcolor) are installed

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project maintains the same license as the original Canvas script.
