#!/bin/bash

# Install the Helix editor

# Determine the latest version of Helix
URL=$(curl -s https://api.github.com/repos/helix-editor/helix/releases/latest | grep -o "http.*x86_64-linux.tar.xz")
FILENAME=$(basename $URL)

# Download and extract the latest version of Helix
curl -LsSf $URL -o $FILENAME
tar -xJf $FILENAME

# Install the dependencies
sudo apt-get install -y libstdc++6

# Find the extracted directory and install Helix
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "helix-*" | head -1)
if [ -z "$EXTRACTED_DIR" ]; then
    echo "Error: Could not find extracted Helix directory"
    exit 1
fi

sudo mv "$EXTRACTED_DIR/hx" /usr/local/bin/hx

# Clean up
rm -rf $FILENAME "$EXTRACTED_DIR"
