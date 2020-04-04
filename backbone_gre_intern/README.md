## backbone_gre_intern
Diese Rolle legt GRE-Tunnel zwischen allen Gateways an.
So wird ermöglicht, dass sich die einzelnen Server untereinander direkt erreichen können.

Die Netzwerkschnittstellen für die Tunnel werden `bck-<Hostname des Zielservers>` benannt.

### Konfiguration
Die Variable `ipv6backbone64prefixstr` muss global auf einen Teilbereich innerhalb des Adressraums von `ff_network.v6_network` gesetzt werden.

Aus diesem Adressbereich werden die IPv6-Adressen für die Tunnelendpunkte gebildet. Er darf nicht in der site.conf für Clients benutzt werden.

##### Beispiel:
Wenn als `ff_network.v6_network` "2a03:2260:115::/48" gegeben ist, kann für `ipv6backbone64prefixstr` "2a03:2260:115:ffa1::" verwendet werden.
