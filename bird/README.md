# bird

Diese Rolle installiert bird.

Bird setzt die Routen, um den Traffic durch die GRE-Tunnel zu leiten.
Das betrifft sowohl die GRE-Tunnel zwischen den Servern (siehe Rolle "backbone_gre_intern") als auch die GRE-Tunnel zu Freifunk Rheinland (siehe Rolle "gateways_gre_upstream").

Außerdem sendet Bird für IPv6 Router Advertisements in das Batman-Netz, wodurch Freifunk-Clients ihre IPv6-Adresse bekommen und erfahren, welche Router es gibt.


# TODO:
Konfiguration erläutern:
- domaenenliste 
- more_specific_routes
- hostvars[host].hoster
- ffrl_nat_ip , ffnw_nat_ip
- ffrl_tun, ffnw_tun 
- ff_network.as_number
- ffrl/nw_tun.<tunnel>.bgp_local_pref