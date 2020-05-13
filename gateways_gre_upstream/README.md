# gateways_gre_upstream

Diese Rolle legt auf Gateways die GRE-Tunnel zu Freifunk Rheinland an.

GRE-Tunnel können bei Freifunk Rheinland hier beantragt werden: https://ticket.freifunk-rheinland.net, Topic: Backbone AS201701

Ein GRE-Tunnel funktioniert nur von der IP-Adresse aus, mit der er bei Freifunk Rheinland registriert wurde.
Er kann also nicht auf einem anderen Gateway verwendet werden.

## Konfiguration
Die benötigten Daten bekommt man von Freifunk Rheinland.

`host_vars/beispielgateway:`

```
ffrl_tun:
- name: dus
  gre_target: 185.66.193.0
  v4_local: 100.64.0.209/31
  v4_remote: 100.64.0.208/31
  v6_local: 2a03:2260:0:6e::2/64
  v6_remote: 2a03:2260:0:6e::1/64
- name: fra
  gre_target: 185.66.194.0
  v4_local: 100.64.0.207/31
  v4_remote: 100.64.0.206/31
  v6_local: 2a03:2260:0:6d::2/64
  v6_remote: 2a03:2260:0:6d::1/64
```
`name` ist ein frei wählbarer Name für den Tunnel (Achtung: Keine Bindestriche oder Leerzeichen verwenden!), aus dem die Bezeichnung für die virtuelle Netzwerkschnittstelle des Tunnels gebildet wird: Tunnel "dus" wird auf das Interface "tun-ffrl-dus" gelegt, "fra" auf "tun-ffrl-fra".

`gre_target` ist der Server bei Freifunk Rheinland, mit dem der Tunnel aufgebaut wird.

Jeder Tunnel hat hat zwei Enden, ein GRE-Tunnel hat zusätzlich an jedem Ende je eine IPv4- und eine IPv6-Adresse:
Die `*_local`-Adressen sind die Tunnelendpunkte auf dem Gateway, die `*_remote`-Adressen die Tunnelendpunkte bei Freifunk Rheinland.
