# mapserver_ffin

Installiert mapserver-docker aus dem Git-Repository

mapserver-docker besteht aus:
- Grafana
- InfluxDB
- Meshviewer
- Yanic
- Freifunk-API
- Gluon-Firmware-Selector
- Webserver für Firmwareimages und Gluon-Pakete


## Konfiguration
### Git-Repository
Die Variable `mapserver_docker.repository` gibt das Git-Repository an, aus dem mapserver-docker installiert wird.

*Beispiel:*

```
mapserver_docker:
  repository: https://git.bingo-ev.de/freifunk/mapserver-docker.git
```

### Mount für Firmware-Images
Die Firmware-Images und Gluon-Pakete werden für die Docker-Container auf dem Server lokal nach /mnt/firmware gemountet.
Von wo gemountet werden soll wird unter `firmware.mount` konfiguriert.

*Beispiel:*
```
firmware:
  mount:
    src: "//hal3000.your-storagebox.de/firmwareimages') }}"
    fstype: "cifs"
    opts: "user=user0815,password=TopSecret"
```

### Passwörter für InfluxDB
mapserver-docker verwendet InfluxDB zum Speichern statistischer Daten über's Freifunknetz.

Der admin-User kann zur Benutzerverwaltung verwendet werden.
Der User "freifunkwrite" wird von Yanic verwendet, um die eingesammelten Daten in die InfluxDB-Datenbank "freifunk" zu schreiben.

Achtung: Das Passwörter werden nur beim ersten Start von InfluxDB gesetzt, spätere Änderungen müssen direkt in InfluxDB durchgeführt werden!

*Beispiel:*
```
mapserver_docker:
  influxdb:
    users:
      admin: "TopSecret"
      freifunkwrite: "StrengGeheim"
```
