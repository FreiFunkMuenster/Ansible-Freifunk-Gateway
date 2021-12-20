# exim4-daemon-light

Diese Rolle installiert den Mailserver exim4-daemon-light

E-Mails werden nur von localhost angenommen und dann an den in der Variable "mail" angegebenen SMTP-Server weitergeleitet.

## Konfiguration

Die Konfiguration erfolgt durch die Variable "mail":
```
mail:
  senderemail: Bestimmte Absender-E-Mail-Adresse für alle von diesem Server gesendeten E-Mails erzwingen (optional)
  smtp: SMTP-Server:Portnummer (Portnummer ist optional, Standard: 25)
  user: Benutzername am SMTP-Server
  pw: Passwort am SMTP-Server
  force_hostname: Hostnamen, der für das SMTP-Helo am SMTP-Server verwendet wird (optional, default: Hostname des Servers)
```

**Beispiel:**
```
mail:
  senderemail: icinga2@example.com
  smtp: mail.foo.bar:587
  user: benutzername
  pw: geheim
  force_hostname: gandalf.example.de
```

Als Absenderadresse wird immer "icinga2@example.com" verwendet.

Zur Authentifizierung am SMTP-Server "mail.foo.bar" wird der Benutzername "benutzername" und das Passwort "geheim" benutzt.

Beim SMTP-Helo wird "gandalf.example.de" als Hostname verwendet.
