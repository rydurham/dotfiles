#!/bin/bash

# Get the name of the most recent release asset
# https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8#gistcomment-2989645

URL=$(curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -o "http.*deb")
FILENAME=$(basename $URL)

# Download the asset file
wget $URL

Install the asset
sudo dpkg -i $FILENAME;

Remove the downloaded file
rm $FILENAME;
