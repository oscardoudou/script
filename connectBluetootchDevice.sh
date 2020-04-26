#!/bin/bash
# this is working when reconnect to same device just disconnected, 
# but not working switch bluetooth connection all over to another device
# it involves turn on/off the bluetooth device power and manual click
# yeah so basically not working as expected at all
blueutil -p 1
for id in `blueutil --favourites| cut -d' ' -f 2 | cut -d , -f 1`; do blueutil --connect $id; done