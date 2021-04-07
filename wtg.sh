#!/bin/bash
password=$1
# disconnect to wtg vpn, replace WTG with your name for wtg vpn(run networksetup -listnetworkserviceorder to figure out)
networksetup -disconnectpppoeservice WTG
# make sure you connect to ibm vpn first, otherwise you won't have a utun interface
# remove route that is too broad, which introduced when motion pro connected
echo "$password" | sudo -S -k route delete 10.0.0.0/8
tunnel=$(netstat -nr -f inet | awk '{ print $4 }'  | grep utun | uniq)
# add speicific route for hoplite, still via tunnel
echo "$password" | sudo -S -k route add 10.177.27.192/26 -interface $tunnel
# add another route for 10.84.63.64/26 (for hulk))
echo "$password" | sudo -S -k route add 10.84.63.64/26 -interface $tunnel
# add route to jenkins
echo "$password" | sudo -S -k route add 10.185.24.192/26 -interface $tunnel
# connect to wtg vpn, replace WTG with your name for wtg vpn(run networksetup -listnetworkserviceorder to figure out)
networksetup -connectpppoeservice WTG
