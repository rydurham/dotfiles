
gatsby() {
    if [ "$1" == "config" ]
    then
        existing=$(openvpn3 configs-list)
        if [[ $existing == *"gatsby"* ]]; then
            echo "It's there!"
        else
            openvpn3 config-import --config ~/.config/openvpn/ryan.durham.fbg.sopr6i.ovpn --name gatsby
        fi
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
    if [ "$1" == "help" ]
    then
        echo "config / start / stop / status"
    fi
}
