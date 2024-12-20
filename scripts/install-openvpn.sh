#/bin/bash

# https://community.openvpn.net/openvpn/wiki/OpenVPN3Linux
sudo apt install apt-transport-https curl
sudo wget https://swupdate.openvpn.net/repos/openvpn-repo-pkg-key.pub
sudo apt-key add openvpn-repo-pkg-key.pub
rm openvpn-repo-pkg-key.pub
sudo wget -O /etc/apt/sources.list.d/openvpn3.list https://swupdate.openvpn.net/community/openvpn3/repos/openvpn3-jammy.list

sudo apt update
sudo apt install openvpn3

# openvpn3 config-import --config ~/path/to/config.ovpn --name gatsby
# openvpn3 session-start --config gatsby
# openvpn3 session-manage --config gatsby --disconnect
