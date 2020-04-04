# borg_backup_sshkey

Diese Rolle ist für die Rechner, von denen ein Backup mit Borg-Backup erstellt werden soll.

Die Rolle erstellt einen SSH-Key, mit dem sich Borg mit dem Zielrechner verbindet.

Der Private-Key verbleibt ausschließlich auf dem Borg-Zielrechner.
Der Public-Key wird nach "keyfiles/borg/{{ inventory_hostname }}.pub" kopiert.

Wenn die Rolle "borg_backup_target" verwendet wird, installiert diese den Public-Key auf den Rechner, auf dem die Backups gespeichert werden sollen.

## Konfiguration
Keine.