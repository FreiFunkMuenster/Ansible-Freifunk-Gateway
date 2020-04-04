# gateways_gretap

Diese Rolle verbindet sämtlichen Gateways und Mapserver über Batman.
Dazu wird zwischen allen Gateways und Mapserver für jede Domäne ein GRE-Tunnel eingerichtet.

Die Namen der eingerichtet Schnittstellen für die GRE-Tunnel lauten: `t<Domänennummer>-<Zielrechner>`

## Abhängigkeiten
Diese Rolle benötigt die Rollen "batman_install" und "gateways_batman".

## Konfiguration
Wenn die optionale Variable `build_tunnels_over_ipv6_if_available` auf `true` gesetzt ist und die beiden am Tunnel beteiligten Server IPv6-Adressen haben, werden die GRE-Tunnel über IPv6 aufgebaut.
Ansonsten wird IPv4 verwendet.
