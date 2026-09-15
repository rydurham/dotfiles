#!/usr/bin/env sh
set -e

# Get current scheme without relying on exact quote format
CURRENT=$(gsettings get org.gnome.desktop.interface color-scheme)

# Check if currently prefer-dark
if echo "$CURRENT" | grep -q "prefer-dark"; then
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita

    # Send notification about the change
    notify-send "Theme Changed" "Switched to Light Mode" -i preferences-desktop-theme

    # Signal apps to reload theme (optional but helps)
    dbus-send --session --dest=org.gtk.Settings --type=signal /org/gtk/Settings org.gtk.Settings.PropertiesChanged string:org.gnome.desktop.interface string:gtk-theme

    echo "Switched to light mode"
else
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

    notify-send "Theme Changed" "Switched to Dark Mode" -i preferences-desktop-theme

    dbus-send --session --dest=org.gtk.Settings --type=signal /org/gtk/Settings org.gtk.Settings.PropertiesChanged string:org.gnome.desktop.interface string:gtk-theme

    echo "Switched to dark mode"
fi
