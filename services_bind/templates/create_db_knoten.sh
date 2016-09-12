#!/bin/bash
set -e
create_db_knoten.py /var/www/html/maps/data/nodes.json /etc/bind/db.services.freifunk-muensterland.de > /etc/bind/db.knoten.freifunk-muensterland.de.new
if [ -e /etc/bind/db.knoten.freifunk-muensterland.de ]; then
    MD5OLD=`sed '1,8d' /etc/bind/db.knoten.freifunk-muensterland.de | md5sum`
    MD5NEW=`sed '1,8d' /etc/bind/db.knoten.freifunk-muensterland.de.new | md5sum`
    if [ "$MD5OLD" != "$MD5NEW" ]; then
        mv /etc/bind/db.knoten.freifunk-muensterland.de.new /etc/bind/db.knoten.freifunk-muensterland.de
        systemctl reload bind9
    fi
else
    mv /etc/bind/db.knoten.freifunk-muensterland.de.new /etc/bind/db.knoten.freifunk-muensterland.de
fi