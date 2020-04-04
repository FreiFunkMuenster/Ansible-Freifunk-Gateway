# borg_backup_target

Diese Rolle ist für Rechner, auf denen ein Borg-Backup-Repository liegen soll, die also als Ziel für Borg-Backup verwendet werden sollen.

Es wird ein Benutzer samt Gruppe angelegt, den Borg für die SSH-Verbindung von den Quellrechnern zu diesem Rechner benutzt.
Die SSH-Verbindung wird mit SSH-Public-Keys hergestellt, für jeden Quellrechner ist also ein SSH-Key nötig (siehe Rolle "borg_backup_sshkey").
Die dazu nötigen SSH-Public-Keys werden aus `keyfiles/borg/` gelesen und in die `~/.ssh/authorized_keys` des erstellen Benutzers eingetragen.

Außerdem wird ein Verzeichnis für die Borg-Repositories erstellt.

## Konfiguration:
```
borg_backup_target:
  config:
    backup_user: borgbkp
    backup_group: borgbkp
    path_to_repo_pool: '/home/borgbkp/backups'
  target_for:
    - "hauptserver"
    - "testserver"
```

Hier wird für Borg-Backup der User "borgbkp" mit der Gruppe "borgbkp" angelegt.
Alle Borg-Backup-Repositories sollen unterhalb "/home/borgbkp/backups" erstellt werden.

Der Rechner dient als Backup-Ziel für die beiden Rechner "hauptserver" und "testserver".

Die nötigen SSH-Public-Keys müssen auf dem Rechner, auf dem Ansible ausgeführt wird, im Verzeichnis "keyfiles/borg" liegen,
hier also "keyfiles/borg/hauptserver.pub" und "keyfiles/borg/testserver.pub".
Wenn die Rolle "borg_backup_sshkey" auf den Quellrechnern eingesetzt wird, werden die SSH-Keys durch diese erstellt.