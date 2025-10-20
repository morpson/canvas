#!/bin/bash

echo "🎨 Canvas Wallpaper Generator"
echo "============================="
echo ""
echo "Choose an app to launch:"
echo "1) Full-featured app (recommended)"
echo "2) Simple test app"
echo "3) Exit"
echo ""
read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        echo "Launching full-featured Canvas app..."
        ./canvas_app_full
        ;;
    2)
        echo "Launching simple test app..."
        ./test_app
        ;;
    3)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice. Please run the script again."
        exit 1
        ;;
esac
