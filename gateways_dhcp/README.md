# gateways_dhcp

Diese Rolle installiert den ISC DHCP-Server auf Gateways.

Der DHCP-Server vergibt ausschließlich IPv4 Adressen, IPv6-Adressen werden von Bird vergeben.
Außerdem teilt der DHCP-Server den Clients die IP-Adresse des DNS-Servers mit.

## Konfiguration:
### Allgemeine DHCP-Einstellungen
```
dhcp_global:
  mtu: 1280
  lease_default: 120
  lease_max: 600
```
* `mtu`: MTU, die an Clients propagiert wird. Wenn fastd verwendet wird sollte `mtu` mindestens 40 Byte kleiner sein als die für fastd konfigurierte MTU
* `lease_default`: Clients werden angewiesen, alle `lease_default` Sekunden einen dhcp-Request machen und ihre Lease zu erneuern
* `lease_max`: Erneuert ein Client seine Lease nicht einmal nach `lease_max` Sekunden, dann wird die IP-Adresse als unbelegt betrachtet und kann an andere Clients vergeben werden

### IPv4-Adressvergabe
Der gesamte private IPv4-Adressbereich, der für das Freifunk-Netz zur Verfügung steht, wird global in die Variable `ff_network.v4_network` eingetragen:

**group_vars/all:**
```
ff_network:
  v4_network: 10.43.0.0/16
  [...]
```

Jeder Domäne wird ein Teil dieses Adressbereichs zugewiesen:

**group_vars/all:**
```
domaenen:
  "01":
    name: Münster
    # Adressbereich: 10.43.8.0-10.43.15.255
    ffv4_network: 10.43.8.0/21
    [...]
  "02":
    name: Kreis Coesfeld
    # Adressbereich: 10.43.16.0-10.43.23.255
    ffv4_network: 10.43.16.0/21
    [...]
```

Der Adressbereich einer jeden Domäne wird weiter auf die Gateways aufgeteilt.
Dabei einen Adressblock am Anfang des eben definierten Domänen-IP-Adressbereichs freilassen, da dort die statisch vergebenen IP-Adressen der Gateways liegen.

**host_vars/gateway1:**
```
vm_id: 1
[...]
domaenenliste:
   "01":
      # 10.43.8.0 bis 10.43.8.255 wird nicht per DHCP vergeben
      dhcp_start: 10.43.9.0
      dhcp_ende: 10.43.11.255
      server_id: 1
      [...]
   "02":
      # 10.43.16.0 bis 10.43.16.255 wird nicht per DHCP vergeben
      dhcp_start: 10.43.17.0
      dhcp_ende: 10.43.19.255
      server_id: 1
      [...]
```

**host_vars/gateway2:**
```
vm_id: 2
[...]
domaenenliste:
   "01":
      dhcp_start: 10.43.12.0
      dhcp_ende: 10.43.15.255
      server_id: 2
      [...]
   "02":
      dhcp_start: 10.43.20.0
      dhcp_ende: 10.43.23.255
      server_id: 2
      [...]
```

### Namensauflösung
Über `domaenenliste.<Domänennummer>.server_id` wird der von den Clients zu verwendende DNS-Server konfiguriert.
Im Normalfall wird auf dem Gateway Bind laufen, dann einfach auf die "vm_id" des Gateways setzen.

Optional kann auch ein externer DNS-Server für alle Domänen verwendet werden:
Dazu die IP-Adresse des DNS-Servers in die Variable `public_dns_ip` eintragen.

Mit der optionalen Variable `dhcp_global.domain_search` kann außerdem eine Standard-DNS-Domäne gesetzt werden, die benutzt wird, wenn nach nicht-FQDN-Hostnamen gesucht wird.
