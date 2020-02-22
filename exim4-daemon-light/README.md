Diese Rolle installiert den Mailserver exim4-daemon-light

E-Mails werden nur von localhost akzeptiert und dann an den in der Variable "mail" angegebenen SMTP-Server weitergeleitet.

Die Konfiguration erfolgt durch die Variable "mail":
```
mail:
  senderemail: icinga2@example.com
  smtp: mail.foo.bar
  user: benutzername
  pw: geheim
```

Als Absenderadresse wird immer "icinga2@example.com" verwendet.
Zur Authentifizierung am SMTP-Server "mail.foo.bar" wird der Benutzername "benutzername" und das Passwort "geheim" benutzt.

