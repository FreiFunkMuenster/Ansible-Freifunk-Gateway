#!/bin/bash
INTERFACE="$3"
PORT="$9"
DOM=${PORT#200}
if grep -Fq "$8" "/srv/tunneldigger/broker/scripts/sperrliste.txt"
then
	echo "Der Knoten $8 ist auf der Sperrliste, verweigere Zugang."
	exit 1
else
	ip link set dev $INTERFACE up mtu 1364
	brctl addif br$DOM $INTERFACE
fi
