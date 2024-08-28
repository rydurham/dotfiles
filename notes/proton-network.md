
> If you look into the output of the command nmcli device you can see a connection named pvpn-ipv6leak-protection which is created by device ipv6leakintrf0(Type-dummy). This issue is caused by Proton VPN to prevent IP leak when you accidentally turn off your system or disconnect from your network without disconnecting the VPN. As long as that connection remains, it will block access to internet on your device.

> The solution is to run the following command on the terminal(in this case)

```
nmcli connection delete pvpn-ipv6leak-protection
```


https://askubuntu.com/a/1446400
