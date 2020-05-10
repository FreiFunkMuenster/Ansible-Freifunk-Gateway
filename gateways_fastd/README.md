# gateways_fastd

Diese Rolle installiert fastd auf Gateways und ermöglicht so die Verwendung von fastd als Tunnel-Protokoll.

Für jede Domäne wird ein eigener fastd-Prozess gestartet. Der Port, auf dem fastd jeweils lauschen soll, wird aus einem Basis-Port und der Domänennummer berechnet. Jeder fastd-Prozess verwendet ein eigenes Schlüsselpaar.
Fastd muss pro Gateway und Domäne explizit aktiviert werden.

## Konfiguration
### Ports und MTU ###
Die globale Konfiguration erfolgt durch die Variable `fastd` (üblicherweise in `group_vars/all`):
```
fastd:
  mtu: 1320
  port_base: 10000
```
`mtu` (optional): MTU für fastd. Muss mit dem `mesh_vpn.mtu`-Wert in der `site.conf` übereinstimmen. Wenn nicht gesetzt wird 1406 benutzt.

`port_base`: Aus `port_base` + Domänennummer ergibt sich der Port, auf dem fastd für die jeweilige Domäne lauscht. Der Port muss mit dem in der `site.conf` gesetzten Port übereinstimmen.

**Beispiel:** Wenn `port_base` auf 10000 gesetzt ist, lauscht fastd für Domäne 10 auf Port 10010 und für Domäne 20 auf Port 10020.

Falls der über "port_base" berechnete fastd-Port für eine Domäne nicht passt, kann für diese Domäne der fastd-Port mit der der Variable `domaenen.<Domänennummer>.fastd_port_forced` abweichend gesetzt werden:
```
domaenen:
  "10":
    name: Beispieldorf
    community: Musterstadt
    fastd_port_forced: 5000
    ...
```

### Schlüsselpaar
Fastd benötigt pro Domäne und pro Server ein Schlüsselpaar. Ein Schlüsselpaar besteht aus Secret-Key und Public-Key.
Der Secret-Key wird vom fastd-Prozess auf dem Server benötigt.
Der Public-Key wird in der `site.conf` veröffentlicht und von den Access Points benutzt, um sich mit dem fastd-Prozess auf dem Gateway zu verbinden. 

Das Schlüsselpaar kann im Ansible Inventory in `host_vars/<servername>` in der Variable `domaenenliste.<Domänennummer>.fastd_key.secret` bzw. `domaenenliste.<Domänennummer>.fastd_key.public` gesetzt werden.
Wird dies nicht getan und es existiert auf dem Server für die jeweilige Domäne noch kein Schlüsselpaar, so wird ein Secret- und Public-Key direkt auf dem Server erzeugt und verwendet. 

### Aktivierung
Damit fastd auf einem Gateway für eine Domäne gestartet wird, muss entweder das für diese Domäne zu verwendende Schlüsselpaar im Inventory des Gateways in der Variable `domaenenliste.<Domänennummer>.fastd_key` gesetzt sein, oder alternativ die Variable `domaenenliste.<Domänennummer>.fastd` auf "true" gesetzt werden. Ansonsten wird kein fastd-Prozess gestartet.

**Beispiel:**
```
domaenenliste:
  "10":
     dhcp_start: 10.10.10.0
     dhcp_ende: 10.10.19.255
     fastd_key:
       secret: 16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae
       public: 13ec900257659ebe6eb071a1135a8bd840e29339d881e1176d64cd2c6076fb0a
   "20":
     dhcp_start: 10.10.30.0
     dhcp_ende: 10.10.39.255
     fastd: true
   "30":
     dhcp_start: 10.10.20.0
     dhcp_ende: 10.10.29.255
```
- Domäne 10: fastd wird gestartet, dabei wird der angegebene fastd_key benutzt.
- Domäne 20: fastd wird gestartet. Wenn auf dem Gateway bereits ein fastd-Key für diese Domäne existiert dann wird dieser benutzt, ansonsten wird ein neuer fastd-Key erzeugt.
- Domäne 30: fastd wird nicht gestartet weil weder die Variable `fastd_key` mit den Schlüsseln existiert noch die Variable `fastd` auf "true" gesetzt ist.
