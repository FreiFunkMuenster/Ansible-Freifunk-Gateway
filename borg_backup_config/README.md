# borg_backup

BorgBackup ist ein Backupprogramm. Die zu sichernden Daten werden vom Quellrechner aus per SSH zum Zielrechner übertragen und dort verschlüsselt in einem Repository ablegt. Alte Datenstände bleiben erhalten.
Zur Datenwiederherstellung kann das Repository einfach gemountet werden.

## Rollen:
BorgBackup besteht aus vier Rollen:
- **borg_backup_sshkey:** Erzeugt auf dem Quellrechner den SSH-Key für die Verbindung vom Quell- zum Zielrechner.
- **borg_backup_target:** Legt auf dem Zielrechner den für die SSH-Verbindung zu verwendenden Benutzer an, trägt den von der Rolle "borg_backup_sshkey" erzeugten SSH-Key des Quellrechners in dessen `~/.ssh/authorized_keys` ein und legt das Basisverzeichnis für Repositories an.
- **borg_backup_install:** Installiert das BordBackup-Programm auf dem Quellrechner.
- **borg_backup_config:** Legt auf dem Quellrechner den Repository-Key an, erstellt einen Cronjob für das tägliche Backup und erstellt das Repository auf dem Zielrechner.

## Konfiguration
Die Konfiguration ist zweigeteilt. Die Zielrechner, auf denen ein Backup-Repository erstellt werden soll, werden mit der Variable `borg_backup_target` konfiguriert, die Quellrechner mit der Variable `borg_backups`.

### Zielrechner: Variable `borg_backup_target`
```
borg_backup_target
  config:
    backup_user: borgbkp
    backup_group: borgbkp
    path_to_repo_pool: '/home/borgbkp/backups'
  target_for:
    - "hauptserver"
    - "testserver"
```
* Der Name von Benutzer und Gruppe, der von BorgBackup für die SSH-Verbindung von Quell- zum Zielrechner verwendet werden soll, muss unter `backup_user` und `backup_group` angegeben werden. Sollten Benutzer und/oder Gruppe auf dem Zielrechner noch nicht existieren, dann werden sie automatisch angelegt.
* In `path_to_repo_pool` muss das Verzeichnis angegeben werden, unterhalb dessen die Backup-Repositories angelegt werden sollen. Wenn das Verzeichnis noch nicht existiert wird es automatisch angelegt.
* `target_for` dient zur weiteren Absicherung des Repositories: Es werden nur SSH-Verbindungen akzeptiert, die von unter `target_for` genannten Rechnern kommen.

### Quellrechner: Variable `borg_backups`
```
borg_backups:
  - name: 'to-backupserver1'
    backup_server: backupserver1
    backup_server_user: borgbkp
    backup_server_port: 22
    backup_server_path: "/borg/gw2"
    backup_server_passphrase: "34048089029052892229184979317772"
    borg_options: '-v --stats --list --filter=AME --compression lzma'
    borg_prune: '--keep-daily=7 --keep-weekly=4 --keep-monthly=6'
    directories:
      - "/var/lib/important_data"
      - "/data/wichtig"
    pgsqldumpall: true
    pgsqldatabases:
      - 'postgresdatabasename1'
      - 'postgresdatabasename2'
    mysqldatabases:
      - 'mysqldatabase1'
      - 'mysqldatabase2'      
    mysqlparameters:
      - '--lock-tables'
      - '--default-character-set=utf8mb4'
    prebackupcommands:
      - '/usr/local/this-is-run-before-backup.sh'
      - '/usr/local/this-is-also-run-before-backup.sh'
    postbackupcommands:
      - '/usr/local/this-is-run-after-backup.sh'
      - '/usr/local/this-is-also-run-after-backup.sh'
```

#### Verbindung zum Zielrechner
Die Verbindung vom Quell- zum Zielrechner wird per SSH-Public-Key hergestellt. Dazu wird von der Rolle "borg_backup_sshkey" auf dem Quellrechner ein SSH-Schlüsselpaar erstellt und unter `/root/.ssh/id_rsa` bzw. `/root/.ssh/id_rsa.pub` gespeichert.
Der SSH-Public-Key wird außerdem auf den Ansible-Controller (der Rechner, auf dem "ansible-playbook" ausgeführt wird) ins Verzeichnis `keyfiles/borg` kopiert.
Die Rolle "borg_backup_target" trägt den SSH-Public-Key auf dem Zielrechner ein.

Der SSH-Private-Key verbleibt ausschließlich auf dem Quellrechner.

* Der Zielrechner muss unter `backup_server` angegeben werden.
* `backup_server_port` gibt den SSH-Port an (im Normalfall 22).
* `backup_server_user` gibt den User auf dem Zielrechner an, der für die SSH-Verbindung benutzt werden soll.
* `backup_server_path` (optional) gibt das Unterverzeichnis für das Repository auf dem Zielrechner. Wenn nicht gesetzt wird "/&lt;hostname&gt;-bkp" benutzt.

#### Repository-Key
Jedes Backup-Repository benötigt einen Repository-Key (oft auch als Passphrase bezeichnet), mit dem die Daten verschlüsselt werden.

Ein vorhandender Repository-Key kann im Inventory als Variable `backup_server_passphrase` angegeben werden.
Alternativ dazu wird auf dem Quellrechner ein neuer Key erstellt und auf den Ansible-Controller gesichert.
Der Repository-Key liegt auf dem Quellrechner unter `/root/<name>.repokey`.

#### Backupskript
Für jede unter `borg_backups` angebene Borg-Backup-Konfiguration wird ein eigenes Backupskript erstellt und als `/usr/bin/backup-<name>` gespeichert.
* `borg_options`: Hier müssen die für die Backuperstellung zu verwendenden Borg-Backup-Optionen angegeben werden (im Zweifelsfall "-v --stats --list --filter=AME --compression lzma" angeben).
* `borg_prune` (optional): Sollen alte Daten automatisch aus dem Repository gelöscht werden können hier die entsprechenden Borg-Optionen angeben. (z.B. "--keep-daily=7 --keep-weekly=4 --keep-monthly=6" um tägliche Snapshots für eine Woche aufzuheben, für 4 Wochen nur einen pro Woche, und für ein halbes Jahr nur einen pro Monat - alles andere wird automatisch gelöscht).

##### Sicherung von Verzeichnissen:
* `directories`: Hier die Verzeichnisse angeben, die gesichert werden sollen

##### Sicherung von Datenbanken
Datenbanken sollten nicht als Verzeichnis gesichert werden, sondern als Datenbank-Dump.
Das Backupskript kann Dumps von MySQL- bzw MariaDB- und ProsgreSQL-Datenbanken erstellen und sichern.

###### Sicherung von MySQL-/MariaDB-Datenbanken
* `mysqldatabases`: Hier die Datenbanknamen angeben, die gesichert werden sollen.
* `mysqlparameters`: Hier müssen die Parameter angegeben werden, die für das Erstellen des Dumps mit mysqldump benutzt werden sollen.

Die Datenbankdumps werden unter `/root/mysqlbackup/backup-<datenbankname>.sql` erstellt und automatisch gesichert. Das Verzeichnis muss nicht extra unter `directories` eingetragen werden.

###### Sicherung von PostgreSQL-Datenbanken
* `pgsqldumpall`: Wenn auf "true" gesetzt werden alle vorhandenen Datenbanken gesichert.
* `pgsqldatabases`: Wenn nicht alle vorhandenen Datenbanken gesichert werden sollen, können hier die Datenbanknamen angegeben werden, die gesichert werden sollen.

##### Ausführen von Befehlen vor und nach dem Backup
In `prebackupcommands` und `postbackupcommands` und können Befehle konfiguriert werden, die vor bzw. nach dem Erstellen eines Backups ausgeführt werden sollen.

