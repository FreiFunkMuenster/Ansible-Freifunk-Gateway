#!/bin/bash

TEMPLATE=/usr/src/services-ffms/apifile/ffapi-template.json
APIFILE=/var/www/html/freifunk/ffapi.json
NODES=/var/www/html/maps/data/nodes.json

NUMNODES=$(jq '.nodes|.[]|.flags|.online' < $NODES | grep true | wc -l)

echo "$NUMNODES"

[[ $NUMNODES =~ ^[0-9]+$ ]] || exit 1

cat $TEMPLATE | sed 's/#NUMNODES#/'$NUMNODES'/' | sed 's/#LASTCHANGE#/'$(date "+%Y-%m-%dT%T.%Z")'/' > $APIFILE

