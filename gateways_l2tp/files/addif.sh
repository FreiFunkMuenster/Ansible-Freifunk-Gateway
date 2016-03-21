#!/bin/bash
INTERFACE="$3"
PORT="$9"
DOM=${PORT#200}
ip link set dev $INTERFACE up mtu 1364
brctl addif br$DOM $INTERFACE
