# backbone_gre_intern
Diese Rolle legt GRE-Tunnel zwischen allen Gateways an.
So wird ermöglicht, dass sich die einzelnen Server untereinander direkt erreichen können.

Die Netzwerkschnittstellen für die Tunnel werden `bck-<Hostname des Zielservers>` benannt.

## Konfiguration
Die Variable `ipv6backbone64prefixstr` muss global auf einen Teilbereich innerhalb des Adressraums von `ff_network.v6_network` gesetzt werden.

Aus diesem Adressbereich werden die IPv6-Adressen für die Tunnelendpunkte gebildet. Er darf nicht in der site.conf für Clients benutzt werden.

**Beispiel:**
Als `ff_network.v6_network` ist gesetzt "2a03:2260:115::/48" (d.h. von 2a03:2260:115:0:0:0:0:0 bis 2a03:2260:115:ffff:ffff:ffff:ffff:ffff).
In der site.conf wird für die Clients davon der Adressbereich "2a03:2260:115::/64" (d.h. von 2a03:2260:115:0:0:0:0:0 bis 2a03:2260:115:0:ffff:ffff:ffff:ffff) freigegeben.
Dann kann kann für `ipv6backbone64prefixstr` "2a03:2260:115:ffa1::" verwendet werden.
