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

Das Schlüsselpaar wird aus einer Ansible-Vault verschlüsselten Variablendatei gelesen (fastd_keys.yml) . Diese muss folgende Struktur enthalten.

**Beispiel:**
```
fastd_keys:
  "01":
    gateway_a:
      secret: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
      public: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
    gateway_b:
      secret: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
      public: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
    gateway_c:
      secret: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
      public: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
    gateway_d:
      secret: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
      public: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
  "02":
    gateway_a:
      secret: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
      public: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
    gateway_b:
      secret: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
      public: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
    gateway_c:
      secret: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
      public: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
    gateway_d:
      secret: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
      public: "16091b4c32c2a6414b9ffe8f4c43df0569e40da964bf38f03c107eccf89842ae"
```

### Aktivierung
Damit fastd auf einem Gateway für eine Domäne gestartet wird, muss die Variable `domaenenliste.<Domänennummer>.fastd` auf "true" gesetzt werden. Ansonsten wird kein fastd-Prozess gestartet.

**Beispiel:**
```
domaenenliste:
  "10":
     dhcp_start: 10.10.10.0
     dhcp_ende: 10.10.19.255
     fastd: false
   "20":
     dhcp_start: 10.10.30.0
     dhcp_ende: 10.10.39.255
     fastd: true
```
- Domäne 10: fastd wird NICHT gestartet, Fastd wird auf dem Gateway für diese Domäne deaktiviert.
- Domäne 20: fastd wird gestartet.
