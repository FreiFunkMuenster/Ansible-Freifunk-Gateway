# Rolle für die Unterstützung von L2TP-Tunneln

Diese Rolle installiert auf Gateways tunneldigger von https://github.com/wlanslovenija/tunneldigger.

Für jede Domäne wird eine eigene tunneldigger-Instanz gestartet.

## Konfiguration
Die Broker-Komponente von Tunneldigger lauscht auf eingehende Verbindungen auf einem von außen erreichenbaren Port.
Der von außen erreichbare Port muss für die Access Points in der `site.conf` unter `mesh_vpn.tunneldigger.brokers` angegeben werden.

Der L2TP-Tunnel selbst wird dann vom Gateway über einen internen Port aufgebaut und in die von der Rolle "gateways_batman" erstellte Netzwerkbrücke eingehängt.

Zur Konfiguration muss die Dictionary-Variable `tunneldigger` mindestens mit dem Eintrag `max_tunnels` gesetzt werden, üblicherweise in den `group_vars`:

**Beispiel:**
```
tunneldigger:
  max_tunnels: 1024
  listening_port_base: 20000
  port_base: 20100
  mtu: 1320
```

- `max_tunnels` beschränkt die maximale Anzahl der verbundenen Clients auf den gesetzten Wert
- `listening_port_base` legt den von Startwert zur Berechnung des von außen erreichbaren Port fest (Default: 20000). Der Broker lauscht auf dem Port `listening_port_base` + Domänennummer.
- `port_base` legt den Startwert zur Berechnung des intern auf dem Gateway verwendeten Port fest (Default: 20100). Verwendet wird der Port `port_base` + Domänennummer.
- `mtu` setzt die MTU für die L2TP-Tunnel. Wenn nicht gesetzt wird 1364 verwendet. Die MTU muss auch in der site.conf eingetragen werden.
