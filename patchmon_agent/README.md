# patchmon-agent

Diese Rolle installiert den PatchMon-Agent und meldet den Server bei PatchMon (https://patchmon.ffi.ms) an.

Der Agent meldet regelmäßig installierte Pakete und verfügbare Updates an den PatchMon-Server. Die Rolle wird über `all.yml` auf allen Servern ausgerollt.

## Ablauf
1. Falls `/etc/patchmon/credentials.yml` bereits existiert, ist der Server schon angemeldet. Anmeldung und Installation werden dann übersprungen.
2. Der Server meldet sich per Auto-Enrollment-Token selbst bei PatchMon an (`/api/v1/auto-enrollment/enroll`). Als Name wird der Hostname aus der `hosts.yml` verwendet, zusätzlich wird die `/etc/machine-id` übermittelt.
3. Mit der dabei erhaltenen API-ID und dem API-Key wird das offizielle Installationsskript (`/api/v1/hosts/install`) ausgeführt. Es installiert das Binary nach `/usr/local/bin/patchmon-agent`, legt die Konfiguration unter `/etc/patchmon/` ab und richtet den systemd-Dienst `patchmon-agent` ein.
4. Der Dienst `patchmon-agent` wird gestartet und aktiviert.

Die Anmeldung erfolgt direkt vom jeweiligen Server aus. Er muss den PatchMon-Server also per HTTPS erreichen können.

## Konfiguration
Die Server-URL wird in `group_vars/all` gesetzt:
```
patchmon:
  server: "https://patchmon.ffi.ms"
```

Der Auto-Enrollment-Token liegt verschlüsselt in der `passwords.yml`:
```
passwords:
  patchmon:
    token_key: "patchmon_ae_..."
    token_secret: "..."
```
Ein Token wird in PatchMon unter Settings → Integrations → Auto-Enrollment & API angelegt. Das Secret wird nur einmal angezeigt. Eingetragen wird es mit `ansible-vault edit passwords.yml`.

## Ausführen
```
ansible-playbook all.yml -t patchmon_agent
ansible-playbook all.yml -t patchmon_agent -l <host>
```

## Neu anmelden
Soll ein Server neu angemeldet werden, muss er zuerst in PatchMon gelöscht werden. Anschließend auf dem Server die Zugangsdaten entfernen und die Rolle erneut ausführen:
```
rm -f /etc/patchmon/config.yml /etc/patchmon/credentials.yml
```
Wichtig: Schlägt die Installation nach einer erfolgreichen Anmeldung fehl, existiert der Server in PatchMon bereits ohne Agent. Diesen Eintrag vor einem erneuten Durchlauf in PatchMon löschen, sonst entsteht ein doppelter Eintrag.

## Prüfen
Auf dem Server:
```
patchmon-agent ping
systemctl status patchmon-agent
```
