#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Python3-Skript zum Erzeugen des Zonefiles für knoten.freifunk-muesnterland.de
# Aufruf: create_db_knoten.py nodes.json Beispiel-Zonefile > Ausgabe-Zonefile

import sys, re, json, time

# Our IPv6 prefix
prefix6 = '2a03:2260:115:'

if len(sys.argv) != 3:
    print("Aufruf: create_db_knoten.py nodes.json Beispiel-Zonefile > Ausgabe", file=sys.stderr)
    sys.exit(2)
file_nodes = sys.argv[1]
file_db = sys.argv[2]

nodes = {}
jnodes = json.load(open(file_nodes, 'r'))
for node in jnodes['nodes'].values():
    try:
        hostname = re.sub(r'[^a-z0-9\-]',"", node["nodeinfo"]["hostname"].lower())
        for address in node["nodeinfo"]["network"]["addresses"]:
            if address.lower().startswith(prefix6):
                nodes[hostname[0:63]] = address
    except:
        pass

print(
'''; zonefile for knoten.freifunk-muensterland.de.
$TTL    86400
@       IN      SOA     service.freifunk-muensterland.de. info.freifunk-muensterland.de. (
                     {}         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
'''.format(time.strftime("%s")), end=""
)
for line in open(file_db, 'r'):
    if re.search('IN\s*NS', line):
        print(line, end="")
for hostname in nodes.keys():
    print(hostname + "  AAAA    " + nodes[hostname])
