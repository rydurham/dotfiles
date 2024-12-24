
gatsby() {
    if [ "$1" == "config" ]
    then
        openvpn3 config-import --config ~/.config/openvpn/ryan.durham.fbg.sopr6i.ovpn --name gatsby
    fi
    if [ "$1" == "start" ]
    then
        openvpn3 session-start --config gatsby
    fi
    if [ "$1" == "stop" ]
    then
        openvpn3 session-manage --config gatsby -D
    fi
    if [ "$1" == "status" ]
    then
        openvpn3 sessions-list
    fi
}
