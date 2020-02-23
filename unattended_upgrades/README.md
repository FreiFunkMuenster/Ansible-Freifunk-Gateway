Diese Rolle installiert unattended-upgrades

"unattended-upgrades" prüft täglich, ob Sicherheitsaktualisierungen des Betriebssystems verfügbar sind und installiert diese automatisch. Falls erforderlich wird wöchentlich ein Reboot durchgeführt.

Die Konfiguration erfolgt durch die Variable "unattended_upgrades".

Standardmäßig werden ausschließlich Sicherheitsupdates installiert.
Optional können weitere Updates durch Angabe ihrer "Origins-Pattern" installiert werden:
```
unattended_upgrades:
    origins_pattern:
    - "origin=Debian,codename=buster,label=Debian"
    - "origin=deb.nodesource.com"
```
Hier würden zusätzlich sämtliche, auch nicht sicherheitsrelevante, Debian-Updates installiert werden.
Außerdem würden sämtliche Pakete, die aus dem Repository deb.nodesource.com installiert wurden, aktualisiert werden.

Falls ein installiertes Update einen Reboot erfordert, erfolgt dieser per Cronjob automatisch einmal wöchentlich zwischen 3:30 und 3:59 Uhr nachts. Der Wochentag wird anhand der "vm_id" des Rechners festgelegt.