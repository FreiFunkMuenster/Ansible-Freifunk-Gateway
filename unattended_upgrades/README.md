# unattended-upgrades

Diese Rolle installiert unattended-upgrades

"unattended-upgrades" prüft täglich, ob für installierte Pakete Aktualisierungen verfügbar sind und installiert diese automatisch. Falls erforderlich wird wöchentlich ein Reboot durchgeführt.


## Konfiguration
Die Konfiguration erfolgt durch die Variable "unattended_upgrades".

Standardmäßig werden ausschließlich Sicherheitsupdates von Debian bzw. Ubuntu installiert.
Optional können weitere Updates aus weiteren Paketquellen durch Angabe ihrer "Origins-Pattern" installiert werden:
```
unattended_upgrades:
    origins_pattern:
    - "origin=Debian,codename=buster,label=Debian"
    - "origin=deb.nodesource.com"
```
Hier würden zusätzlich sämtliche, auch nicht sicherheitsrelevante, Debian-Updates installiert werden.
Außerdem würden sämtliche Pakete, die aus dem Repository deb.nodesource.com installiert wurden, aktualisiert werden.

Die Origins-Patterns aller Paketquellen kann man sich mit ''apt-cache policy'' anzeigen lassen.

Falls ein installiertes Update einen Reboot erfordert, erfolgt dieser per Cronjob automatisch einmal wöchentlich zwischen 3:30 und 3:59 Uhr nachts. Der Wochentag wird anhand der "vm_id" des Rechners festgelegt.