# Rolle für die Unterstützung von L2TP-Tunneln

Diese Rolle installiert auf Gateways tunneldigger von https://github.com/wlanslovenija/tunneldigger.

Für jede Domäne wird eine eigene tunneldigger-Instanz gestartet.

## Konfiguration
Die Broker-Komponente von Tunneldigger lauscht auf eingehende Verbindungen auf Port 20000 + Domänennummer, also z.B. für Domäne 11 auf Port 20011.
Dieser Port muss für die Access Points in der `site.conf` unter `mesh_vpn.tunneldigger.brokers` angegeben werden.

Der L2TP-Tunnel selbst wird dann vom Gateway über den unten mit `port_base` konfigurierten Port aufgebaut und in die von der Rolle "gateways_batman" Netzwerkbrücke eingehängt.

Zur Konfiguration muss die Dictionary-Variable `tunneldigger` mit den beiden Einträgen `max_tunnels` und `port_base` gesetzt werden, üblicherweise in den `group_vars`:

**Beispiel:**
```
tunneldigger:
  max_tunnels: 1024
  port_base: 20100
```

- `max_tunnel` beschränkt die maximale Anzahl der verbundenen Clients auf den gesetzten Wert
- `port_base` muss auf einen auf dem Gateway freien Port gesetzt werden und auch in der site.conf eingetragen werden.
