#!/bin/bash

# Define possible installation paths
INSTALL_PATHS=(
    "/opt/android-studio"
    "$HOME/android-studio"
    "/snap/android-studio/current/android-studio"
)

# Find the correct installation path
ANDROID_STUDIO_PATH=""
for path in "${INSTALL_PATHS[@]}"; do
    if [ -d "$path" ]; then
        ANDROID_STUDIO_PATH="$path"
        break
    fi
done

# Check if Android Studio is found
if [ -z "$ANDROID_STUDIO_PATH" ]; then
    echo "❌ Android Studio not found! Please install it first."
    exit 1
fi

# Define paths for the executable and icon
EXEC_PATH="$ANDROID_STUDIO_PATH/bin/studio.sh"
ICON_PATH="$ANDROID_STUDIO_PATH/bin/studio.svg"

# Check if the executable exists
if [ ! -f "$EXEC_PATH" ]; then
    echo "❌ Android Studio executable not found at $EXEC_PATH!"
    exit 1
fi

# Create the desktop entry file
DESKTOP_FILE="$HOME/.local/share/applications/android-studio.desktop"
echo "Creating desktop entry at $DESKTOP_FILE..."

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Comment=Android Development Environment
Exec=$EXEC_PATH
Icon=$ICON_PATH
Terminal=false
Categories=Development;IDE;
StartupWMClass=jetbrains-studio
EOF

# Make the desktop file executable
chmod +x "$DESKTOP_FILE"

# Refresh the desktop database
update-desktop-database "$HOME/.local/share/applications/"

echo "✅ Android Studio desktop entry created successfully!"
echo "🔍 You can now find 'Android Studio' in the Applications menu."

# Ask user if they want to move it system-wide
read -p "Do you want to make this entry available for all users? (y/n): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    sudo mv "$DESKTOP_FILE" /usr/share/applications/
    echo "✅ Android Studio is now available system-wide."
fi
