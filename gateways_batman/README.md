# gateways_batman

Diese Rolle konfiguriert auf Gateways für jede Domäne je ein Batman-Netzwerkinterface (Name: `bat<Domänennummer>`).

Jedem Batman-Netzwerkinterface wird außerdem eine Netzwerkbrücke (Name: `br<Domänennummer>`) vorgeschalten.
Mit diesem können sich dann die L2TP- und/oder fastd-Tunnel verbinden können.

Die Netzwerkbrücke ist notwendig, weil Batman mit dem häufigen Hinzufügen und Entfernen von Netzwerkschnittstellen beim Auf- und Abbau von L2TP-Verbindungen nicht gut zurecht kommt.

## Konfiguration

Keine.