#!/bin/bash

# Download and install the binary
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz

# Remove the download
rm nvim-linux64.tar.gz

# Create a symbolic link to the binary in a path location that can be found by sudoers
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/sbin/nvim
