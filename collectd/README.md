## Rolle für collectd client
Diese Rolle kann sowohl für Backbone-Server, als auch für Gateway-Server, als auch für Supernodes verwendet werden. Da auf Backbone-only Servern kein DHCP und auch kein fastd läuft, können diese Monitoring-Ziele deaktiviert werden. Siehe dazu den Punkt *Variablen*.
### Variablen
Es gibt zwei Dictionaries, die für die collectd Rolle relevant sind. Diese werden üblicherweise in den ``group_vars`` konfiguriert. Das Dictionary ``graphite_data_target`` wird üblicherweise nur in der Gruppe ``all`` gesetzt.

#### Beispiel
```
# Zielserver für Graphite Daten 
graphite_data_target:
  # IP Adresse
  host: 5.9.86.154
  # Port des Carbon-Dienstes 
  port: 2003  
  
# Collectd Konfiguration 
collectd:
  # Prefix für Graphite-Daten
  graphite_prefix: host.
  # Sollen Daten über den DHCP Server erfasst werden?
  collect_dhcp: true
  # Sollen Daten über den fastd Server erfasst werden?
  collect_fastd: true
```

