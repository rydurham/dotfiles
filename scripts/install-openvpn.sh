#/bin/bash

# https://launchpad.net/~djpig/+archive/ubuntu/openvpn
sudo add-apt-repository ppa:djpig/openvpn
sudo apt update
sudo apt install openvpn3

# openvpn3 config-import --config ~/path/to/config.ovpn --name gatsby
# openvpn3 session-start --config gatsby
# openvpn3 session-manage --config gatsby --disconnect
