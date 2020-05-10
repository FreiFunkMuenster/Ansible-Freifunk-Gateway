# common

Diese Rolle nimmt allgemeine Servereinstellungen vor.
Sie sollte immer eingebunden werden.

Diese Rolle:
- installiert Standardpakete wie wget, tmux, host usw.
- deaktiviert die SSH-Anmeldung mit Passwort und installiert die SSH-Public-Keys der Administratoren
- konfiguriert das Logging mit logrotate und journald
- installiert das Bash-Profile
- konfiguriert Syntax-Highlighting in vim

## Konfiguration
### SSH-Anmeldung:
Die Anmeldung an den Servern ist ausschließlich mit SSH und Public-Key-Authentifizierung möglich.
Jeder Server-Administrator, der sich per SSH an den Servern anmelden soll, muss in der Variable `administratorenteam` gelistet
und sein SSH-Public-Key nach `keyfiles/<name>.pub` kopiert werden.
Diese Rolle trägt diese dann in `/root/.ssh./authorized_keys` ein:

Variable (üblicherweise in `group_vars/all`):
```
administratorenteam:
  - "pinky"
  - "inky"
  - "clyde"
```

Dateien:
```
keyfiles/pinky.pub
keyfiles/inky.pub
keyfiles/clyde.pub
```

### Logging
Wie lange Logdateien aufgehoben werden wird mit der Variable `logrotate` festgelegt:
```
logrotate
  cycle: weekly
  count: 2
 ```
 
 * `logrotate.cycle` kann "daily", "weekly" oder "monthly" sein und gibt an, wie oft eine neue Logdatei angefangen werden soll.
 * `logrotate.count` gibt an, wie viele Logdateien aufgehoben werden sollen.
 
Im obigen Beispiel wird wöchentlich ("weekly") eine neue Logdatei erstellt.
Die letzten zwei Logdateien werden aufgehoben, alle älteren werden gelöscht.
Es existieren also Logdateien für die letzten 14 Tage.
Journald wird automatisch so konfiguriert, dass Logs den selben Zeitraum aufbewahrt werden.
