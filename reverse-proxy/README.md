# reverse-proxy

Diese Rolle installiert einen Reverse-Proxy mit Nginx.

Ein Reverse-Proxy nimmt Anfragen auf Freifunk-Subdomains aus dem Internet entgegen und leitet sie an interne Webserver weiter.

Die Kommunikation zwischen Reverse-Proxy und internen Webservern läuft über HTTP.
Für die Kommunikation im Internet wird HTTPS verwendet, die dazu nötigen Zertifkate werden durch Certbot automatisch von Let's Encrypt besorgt und vor Ablauf aktualisiert.

Zugriffe werden unter /var/log/nginx/access.log protokolliert. Dabei werden zur Anonymisierung bei IPv4 das letzte Tupel auf 0 gesetzt, bei IPv6 die letzten 64 Bit.

## Konfiguration
Für die Registrierung bei Let's Encrypt wird die unter `freifunk.email` gesetzte E-Mailadresse verwendet.
Die Zuordnung von Subdomain zu internem Webserver erfolgt über die Variable `reverse_proxy`. Die Subdomains liegen unterhalb von `freiunk.domain` und müssen im DNS eingetragen sein:

```
reverse_proxy:
  <Subdomain>[:Port]:
    backend: <Protokoll>://<Host>[:Port]
```

"Subdomain" ist die Subdomäne unterhalb von `freifunk.domain`, unter der der unter `backend` eingetragene Webserver erreichbar gemacht werden soll.
Die Angabe von "Port" ist jeweils optional, als Standard wird "443" bei der Subdomain und "80" beim Backend verwendet.

Als "Host" kann entweder eine IP-Adresse oder ein Hostname eingetragen werden.
Das "Protokoll" das Backends kann entweder http oder https sein.
Wenn als Backend-Protokoll https verwendet wird und als "Host" ein IP-Adresse angegeben ist, dann wird das Zertifikat des Backend-Servers nicht geprüft.

*Bespiel:*
```
freifunk.domain: freifunk-musterstadt.de
```

```
reverse_proxy:
  foo:
    backend: http://192.168.123.5:82
  bar:464:
    backend: https://example.com
  baz:
    backend: https://127.0.0.1:8080
```
Hier leitet der Revere-Proxy eingehende Anfragen wie folgt weiter:
- "https://foo.freifunk-musterstadt.de" zu "http://192.168.123.5:82"
- "https://bar.freifunk-musterstadt.de:464" zu "https://example.com" aus, der Reverse Proxy überprüft das Zertifikat von example.com
- "https://baz.freifunk-musterstadt.de" zu "https://127.0.0.1:8080", der Reverse-Proxy überprüft das Zertifikat vin 127.0.0.1:8080 nicht
