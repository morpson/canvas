#!/bin/bash
set -euo pipefail

APP_NAME="Canvas"
BUNDLE_DIR="${APP_NAME}.app"
CONTENTS_DIR="${BUNDLE_DIR}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RES_DIR="${CONTENTS_DIR}/Resources"
PLIST_PATH="${CONTENTS_DIR}/Info.plist"
EXECUTABLE="canvas_app_full"

if [[ ! -x "${EXECUTABLE}" ]]; then
  echo "Error: ${EXECUTABLE} not found. Build it first (it's in this folder already)."
  exit 1
fi

rm -rf "${BUNDLE_DIR}"
mkdir -p "${MACOS_DIR}" "${RES_DIR}"

# Write minimal Info.plist for a SwiftUI app
cat > "${PLIST_PATH}" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>${APP_NAME}</string>
  <key>CFBundleIdentifier</key>
  <string>com.canvas.wallpaper</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>${APP_NAME}</string>
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
</dict>
</plist>
PLIST

# Place executable
cp -f "${EXECUTABLE}" "${MACOS_DIR}/${APP_NAME}"
chmod +x "${MACOS_DIR}/${APP_NAME}"

# Optional: include script dependency in Resources (not required to run)
if [[ -f "canvas-simple" ]]; then
  cp -f "canvas-simple" "${RES_DIR}/canvas-simple"
  chmod +x "${RES_DIR}/canvas-simple"
fi

# Ad-hoc sign so Gatekeeper allows running locally
codesign --force --deep --sign - "${BUNDLE_DIR}" >/dev/null 2>&1 || true

echo "Built ${BUNDLE_DIR}"
open "${BUNDLE_DIR}"
