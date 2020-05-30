# reverse-proxy

Diese Rolle installiert einen Reverse-Proxy mit Nginx.

Ein Reverse-Proxy nimmt Anfragen auf Freifunk-Subdomains aus dem Internet entgegen und leitet sie an interne Webserver weiter.

Die Kommunikation zwischen Reverse-Proxy und internen Webservern läuft über HTTP.
Für die Kommunikation zum Internet wird HTTPS oder HTTP verwendet. Die für HTTPS nötigen Zertifkate werden durch Certbot automatisch von Let's Encrypt besorgt und vor Ablauf aktualisiert.

Zugriffe werden unter /var/log/nginx/access.log protokolliert. Dabei werden zur Anonymisierung bei IPv4 das letzte Tupel auf 0 gesetzt, bei IPv6 die letzten 64 Bit.

## Konfiguration
Für die Registrierung bei Let's Encrypt wird die unter `freifunk.email` gesetzte E-Mailadresse verwendet.
Die Zuordnung von Subdomain zu internem Webserver erfolgt über die Variable `reverse_proxy`. Die Subdomains liegen unterhalb von `freiunk.domain` und müssen im DNS eingetragen sein:

```
reverse_proxy:
  http:
    <Subdomain>[:Port]:
      backend: <Protokoll>://<Host>[:Port]
  https:
    <Subdomain>[:Port]:
      backend: <Protokoll>://<Host>[:Port]
```

"Subdomain" ist die Subdomäne unterhalb von `freifunk.domain`, unter der der unter `backend` eingetragene Webserver erreichbar gemacht werden soll.
Je nachdem, ob die Subdomain im Abschnitt "http" oder "https" konfiguriert wird, ist sie von außen über http oder eben https erreichbar. Wird sie in beiden Abschnitten konfiguriert, ist sie über http und https erreichbar.
Die Angabe von "Port" ist optional. Als Standard wird "443" bei unter https gelisteten Subdomains und "80" bei http verwendet.

Das Backend ist der interne Server, der die Anfragen für die jeweilige Subdomain beantworten soll.
Das "Protokoll" das Backends kann entweder http oder https sein.
Als "Host" kann entweder eine IP-Adresse oder ein Hostname eingetragen werden.
Wenn als Backend-Protokoll https verwendet wird und als "Host" ein IP-Adresse angegeben ist, dann wird das Zertifikat des Backend-Servers nicht geprüft.
Die Angabe von "Port" ist optional. Wenn kein Port angegeben ist wird "80" verwendet.


*Bespiel:*
```
freifunk.domain: freifunk-musterstadt.de
```

```
reverse_proxy:
  http:
    foo:
      backend: http://192.168.123.5:82
    bar:464:
      backend: https://example.com
  https:
    foo:
      backend: http://192.168.123.5:82
    baz:
      backend: https://127.0.0.1:8080
```
Hier leitet der Revere-Proxy eingehende Anfragen wie folgt weiter:
- "http://foo.freifunk-musterstadt.de" zu "http://192.168.123.5:82"
- "http://bar.freifunk-musterstadt.de:464" zu "https://example.com", der Reverse Proxy überprüft das Zertifikat von example.com
- "https://foo.freifunk-musterstadt.de" zu "http://192.168.123.5:82"
- "https://baz.freifunk-musterstadt.de" zu "https://127.0.0.1:8080", der Reverse-Proxy überprüft das Zertifikat vin 127.0.0.1:8080 nicht
