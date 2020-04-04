# borg_backup_config

Diese Rolle ist für Rechner, von denen ein Backup mit Borg-Backup erstellt werden soll.

Die Rolle legt die Repository-Keys und die Repositories an und konfiguriert das tägliche Backup.


Jedes Backup-Repository benötigt einen Repository-Key, mit dem die Daten verschlüsselt werden.
Dieser Repository-Key kann im Inventory angegeben werden. Alternativ dazu wird auf dem Rechner ein neuer Key erstellt und auf den Ansible-Controller gesichert.

Außerdem wird ein Backup-Skript erstellt, das per Cronjob einmal täglich ausgeführt wird.

## Konfiguration
```
  - name: 'to-hetzner-storagebox'
    backup_server: backupserver1
    backup_server_user: borgbkp
    backup_server_port: 23
    backup_server_path: "/borg/gw2"
    backup_server_passphrase: "34048089029052892229184979317772"
    directories:
      - "/var/lib/important_data"
      - "/data/wichtig"
    borg_options: '-v --stats --list --filter=AME --compression lzma'
    borg_prune: '--keep-daily=7 --keep-weekly=4 --keep-monthly=6'
  
  - name: 'to-hetzner-storagebox'
    backup_server: backupserver2
    backup_server_user: borgusr
    backup_server_port: 23
    backup_server_path: "/borg/gw2"
    backup_server_passphrase: "{{ lookup('passwordstore','ffin/hetzner/borgbackup/gw2 create=true length=32') }}"
    directories:
      - "/var/lib/docker/volumes/map_influxdb"
      - "/var/lib/docker/volumes/map_yanic"
    borg_options: '-v --stats --list --filter=AME --compression lzma'
    borg_prune: '--keep-daily=7 --keep-weekly=4 --keep-monthly=6'

```

## TODO: Konfiguration Backupskript erklären
- prebackupcommands
- ...