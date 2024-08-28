#!/bin/bash

# Capture our current working directory
wd=$( pwd )

# Add the release PGP keys:
sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

# Add the "stable" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

# Update and install syncthing:
sudo apt-get update
sudo apt-get install syncthing

# Configure systemd service
if [ ! -d ~/.config/systemd/user ]
then
    mkdir -p ~/.config/systemd/user
fi

cp $wd/conf/syncthing.service ~/.config/systemd/user
systemctl --user enable syncthing.service
systemctl --user start syncthing.service
