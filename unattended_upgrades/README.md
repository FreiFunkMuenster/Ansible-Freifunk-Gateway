# unattended_upgrades

Installiert `unattended-upgrades` und `apt-listchanges` und konfiguriert automatische Updates.

Die Paketdatei `/etc/apt/apt.conf.d/50unattended-upgrades` wird **nicht** mehr angefasst. Eigene Einstellungen liegen in `/etc/apt/apt.conf.d/52unattended-upgrades-local`. Apt liest die Dateien alphabetisch, die 52 kommt also nach der 50: einfache Werte überschreiben, Listen (z. B. `Origins-Pattern`) werden *angehängt*. Soll eine Liste ersetzt werden, steht davor ein `#clear` (macht die Rolle bei `security_only: true`).

Was die Rolle verwaltet:

| Datei | Zweck |
|---|---|
| `/etc/apt/apt.conf.d/20auto-upgrades` | Aktivierung (wie `dpkg-reconfigure -plow unattended-upgrades`) |
| `/etc/apt/apt.conf.d/52unattended-upgrades-local` | Quellen, Verhalten, Mail, Reboot |
| `/etc/systemd/system/apt-daily{,-upgrade}.timer.d/override.conf` | Zeitpunkt von Update und Upgrade |
| Cronjob `weekly restart` | nur bei `reboot_mode: cron_weekly` |

Bei Konfig-Konflikten bleibt apt nie hängen (`Dpkg::Options --force-confdef --force-confold`).

## Konfiguration

Alles über **ein Dict `unattended_upgrades`**. Es müssen nur die Keys angegeben werden, die vom Default abweichen. Defaults stehen in `defaults/main.yml` (`unattended_upgrades_defaults`) und werden zu Beginn der Rolle gemergt. Unbekannte Keys (Tippfehler) und ungültige Werte für `reboot_mode`/`mail_report` brechen mit einer Fehlermeldung ab.

> **Wichtig:** Ansible merged Dicts nicht (`hash_behaviour=replace`). Wird `unattended_upgrades` in `group_vars` **und** `host_vars` gesetzt, ersetzt das Dict aus `host_vars` das aus `group_vars` vollständig. Die Rollen-Defaults gelten trotzdem. Keys aus `group_vars` müssen in `host_vars` also wiederholt werden.

| Key | Default | Bedeutung |
|---|---|---|
| `enabled` | `true` | `false` = deaktivieren (`20auto-upgrades` auf `0`, Timer-Drop-ins und Cronjob entfernt). Paket bleibt installiert. |
| `security_only` | `true` | `true` = nur Security. `false` = Paket-Default (Security + Point-Releases `label=Debian`). |
| `include_updates` | `false` | zusätzlich `${distro_codename}-updates` |
| `origins_pattern` | `[]` | weitere Origins, z. B. `"site=ftp.ripe.net"` |
| `package_blacklist` | `[]` | Python-Regex, diese Pakete werden nie automatisch aktualisiert |
| `minimal_steps` | `true` | Upgrade in kleinsten Schritten (unterbrechbar) |
| `dpkg_force_confold` | `true` | `Dpkg::Options` mit `--force-confdef`/`--force-confold`. Gilt global, auch für manuelle apt-Läufe. |
| `remove_unused_dependencies` | `true` | automatisches `autoremove` |
| `remove_unused_kernel_packages` | `true` | alte Kernel entfernen |
| `autoclean_interval` | `7` | `APT::Periodic::AutocleanInterval` (Tage) |
| `mail` | `""` | Empfänger, leer = keine Mail. Ein funktionierender MTA mit `mailx` wird vorausgesetzt. |
| `mail_report` | `only-on-error` | `always` \| `on-change` \| `only-on-error` |
| `reboot_mode` | `none` | `none`, `unattended` oder `cron_weekly` (siehe unten) |
| `reboot_with_users` | `true` | Reboot auch bei angemeldeten Benutzern (nur `unattended`) |
| `reboot_time` | `""` | Uhrzeit für `unattended`. Leer = `04:xx`, `xx = (vm_id*2)%30+30`. Ohne `vm_id`: `04:00` plus Warnung. |
| `timer_update` | `*-*-* 02:30` | `OnCalendar` von `apt-daily.timer` |
| `timer_upgrade` | `*-*-* 03:30` | `OnCalendar` von `apt-daily-upgrade.timer` |
| `timer_randomized_delay` | `"0"` | `RandomizedDelaySec` beider Timer |

### Reboot-Modi

- `none`: kein automatischer Reboot. Anstehende Reboots stehen in `/run/reboot-required` und müssen selbst geprüft werden.
- `unattended`: `Unattended-Upgrade::Automatic-Reboot` zur Uhrzeit `reboot_time`.
- `cron_weekly`: Cronjob `weekly restart`, einmal pro Woche zwischen 03:30 und 03:59, wenn `/var/run/reboot-required` existiert. Wochentag und Minute werden aus `vm_id` gestaffelt. Ohne `vm_id` wird ein stabiler Wert aus dem Hostnamen abgeleitet (mit Warnung). Der Upgrade-Timer läuft standardmäßig um 03:30, ein Reboot kann also in ein noch laufendes Upgrade fallen. `shutdown -r +5`, `MinimalSteps` und `unattended-upgrade-shutdown` fangen das ab. Wer sicher gehen will, setzt `timer_upgrade` früher.

## Beispiele (host_vars)

```yaml
# Gateway: nur Security (Default), Reboot wöchentlich gestaffelt
unattended_upgrades:
  reboot_mode: cron_weekly

# Dienst-Host: alles inkl. -updates, nächtlicher Reboot bei Bedarf
unattended_upgrades:
  security_only: false
  include_updates: true
  reboot_mode: unattended
  reboot_time: "04:00"

# Host mit Fremdrepo, kein Auto-Reboot, Mail bei Fehlern
unattended_upgrades:
  origins_pattern:
    - "site=ftp.ripe.net"
  reboot_mode: none
  mail: "root"

# komplett aus
unattended_upgrades:
  enabled: false
```

## Prüfen

- Origins ermitteln: `apt-cache policy`
- Wirksame Konfiguration: `apt-config dump | grep -i unattended`
- Trockenlauf: `unattended-upgrade --dry-run --debug` (oder per Ansible mit dem Tag `uu_test` und `-v`)
- Timer: `systemctl list-timers 'apt-daily*'` (Tag `uu_timers` bzw. `uu_test`)
- Anstehende Reboots (v. a. bei `reboot_mode: none`): `ls /run/reboot-required`

## Hinweis zu eigenen systemd-Units

Dienste mit eigenen systemd-Units neben paketierten Units (z. B. eine zweite BIND-Instanz) können bei einem Upgrade gestoppt und nicht neu gestartet werden. Abhilfe: im Unit-Drop-in `PartOf=<paketierte Unit>` setzen.

## Verhaltensänderungen gegenüber der alten Rolle

- Die alte Rolle hat effektiv nur Security installiert. Das bleibt mit den Defaults so. Point-Releases und `-updates` gibt es erst mit `security_only: false` bzw. `include_updates: true`.
- **Der wöchentliche Reboot-Cronjob ist nicht mehr Default** (`reboot_mode: none`). Wer ihn behalten will, setzt `reboot_mode: cron_weekly`. Bei allen anderen Hosts wird der bestehende Cronjob `weekly restart` beim ersten Lauf entfernt.
- Der Zeitpunkt richtet sich nach den systemd-Timern statt nach apt-Periodic.

## Migration bestehender Hosts

Beim ersten Lauf auf einem Alt-Host passiert Folgendes (alles idempotent):

1. Enthält `/etc/apt/apt.conf.d/50unattended-upgrades` den Marker `Ansible managed` (also unsere alte Datei), wird sie gelöscht und die Originalversion per `apt-get install --reinstall -o Dpkg::Options::=--force-confmiss unattended-upgrades` wiederhergestellt. Sonst bleibt die Datei unberührt.
2. `/etc/apt/apt.conf.d/10periodic` wird entfernt, wenn sie genau dem alten Template entspricht und kein Paket sie besitzt (`dpkg -S`). Sonst bleibt sie liegen (`20auto-upgrades` gewinnt alphabetisch ohnehin).
3. `20auto-upgrades`, `52unattended-upgrades-local` und die Timer-Drop-ins werden angelegt, der Cronjob `weekly restart` je nach `reboot_mode` weitergeführt oder entfernt.
