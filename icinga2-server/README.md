# icinga2-server

Diese Rolle installiert Icinga2 und optional IcingaWeb2.
Für den E-Mail-Versand wird ein lokaler Mailserver benötigt (z.B. Rolle exim4-daemon-light).

## Konfiguration
Die Konfiguration erfolgt durch Variable "icinga2":
```
    icinga2:
      api: true
      api_listener:
        address: "192.168.5.2"
        port: "5000"
      icingaweb2: true
      http_listener:
        address: "192.168.102.69"
        port: "81"
      mail_interval: "2h"
      mail_sender: icingaserver@foo.bar
      xmpp:
        jid: icinga2@jabberexample.com
        pw: passwort0
      userliste:
        - user: username1
          pw: passwort1
          email: username1@foobar.com
          jid: username1@jabberfoobar.com
        - user: username2
          pw: passwort2
        - email: beispiel@bar.baz
```
- **api:** Icinga2-API ein- (=true) oder ausschalten (=false). Wenn nicht gesetzt wird "false" angenommen. Über die API ist nur Monitoring erlaubt, kein Anlegen/Ändern/Löschen von Objekten u.ä..
- **api_lister:**  Ändert die IP-Adresse und den Ports für Icinga2-API. Wenn nicht gesetzt wird als "address" "::" und als "port" "5665" verwendet, womit die Icinga2-API an alle Netzwerkschnittstellen auf Port 5665 verfügbar ist.
- **icingaweb2:** IcingaWeb2-Weboberfläche ein- (=true) oder ausschalten (=false).
- **http_listener:** Ändern die IP-Adresse und den Ports für IcingaWeb2. Wenn nicht gesetzt wird als "address" "*" und als "port" "80" verwendet, womit IcingaWeb2 an alle Netzwerkschnittstellen auf Port 80 verfügbar ist.
- **mail_interval:** Icinga2 kann bei länger andauernden Alerts nicht nur einmalig, sondern regelmäßig per E-Mail informieren. Hier kann eingestellt werden, in welchen Abständen diese E-Mails versendet werden sollen (z.B. "30m" für alle 30 Minuten, "2h" für alle zwei Stunden usw., "0" für keine regelmäßigen E-Mails). Standardwert ist "30m".
- **mail_sender:** Optional. Absenderadresse für von Icinga2 versendeten E-Mails. (Standard: nagios@hostname)
- **xmpp:** Optional. JID ("jid") und Passwort ("pw") des XMPP-Accounts, der von Icinga2 verwenden soll um Alerts an User per XMPP zu verschicken.
- **userliste:** Enthält eine Liste mit Benutzern. Ein Benutzer muss Benutzername und Passwort und/oder E-Mailadresse haben. Zusätzlich ist eine XMPP-Adresse möglich.


Falls die Icinga2-API und/oder IcingaWeb2 eingeschaltet ist, dann haben alle in "userliste" mit Benutzername ("user") und Passwort ("pw") angebenen Benutzer darauf Zugriff.
An alle in "userliste" angegebenen E-Mail-Adressen ("email") versendet Icinga2 Notifications.
Dazu ist die Rolle exim4-daemon-light nötig, die die E-Mails lokal annimmt und an einen SMTP-Server weiterleitet.
Zusätzlich zur E-Mail-Addresse können Notifications an eine XMPP-ID ("jid") gesendet werden.


Im Beispiel oben gibt es drei User: Zwei davon können sich an der API und an IcingaWeb2 anmelden, einer davon bekommt die Alerts zusätzlich per E-Mail und XMPP.
Der dritte User kann sich nirgends anmelden und wird nur per E-Mail über Alerts informiert.


Auf die API kann, wenn nicht anders konfiguriert, über https, Port 5665, zugegriffen werden.
Das von Icinga2 dafür erzeugte CA-Zertifikat wird auf dem Ansible-Controller unter "keyfiles/icinga2/HOSTNAME-ca.crt" abgelegt.
Auf IcingaWeb2 kann, wenn nicht anders konfiguriert, über http, Port 80, zugegriffen werden.

## Kompatibilität:
Nur Debian 10 und Ubuntu 18.04.
