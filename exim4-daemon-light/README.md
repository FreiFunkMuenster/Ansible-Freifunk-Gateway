# exim4-daemon-light

Diese Rolle installiert den Mailserver exim4-daemon-light

E-Mails werden nur von localhost angenommen und dann an den in der Variable "mail" angegebenen SMTP-Server weitergeleitet.

## Konfiguration

Die Konfiguration erfolgt durch die Variable "mail":

**Beispiel:**
```
mail:
  senderemail: icinga2@example.com
  smtp: mail.foo.bar
  user: benutzername
  pw: geheim
  force_hostname: gandalf.example.de
```

Als Absenderadresse wird immer "icinga2@example.com" verwendet.

Zur Authentifizierung am SMTP-Server "mail.foo.bar" wird der Benutzername "benutzername" und das Passwort "geheim" benutzt.

`force_hostname` ist optional und setzt den Hostnamen, der für das SMTP-Helo am SMTP-Server verwendet wird.
