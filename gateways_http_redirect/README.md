# gateways_http_redirect

Diese Rolle installiert einen Nginx-Webserver auf dem Gateway, der auf HTTP lauscht und zu anderen Webseiten (z.B. ein Grafana-Dashboard oder die Homepage) weiterleitet.

## Konfiguration
Gateways haben neben ihren normalen öffentlichen IPv4- und IPv6-Adressen zusätzlich pro Domäne eine öffentliche IPv6-Adresse und IPv4-Adresse, die nur aus dem Freifunk-Netz erreicht werden kann.

Mit `public` wird konfiguriert, auf welche URL beim Zugriff auf die öffentlichen IP-Adressen weitergeleitet werden soll.

Mit `per_domain` wird das Weiterleitungsziel für Zugriffe auf die Freifunk-IP-Adressen gesetzt.
Taucht in der URL der String "NODEID" auf, wird dieser durch die Node-ID, d.h. durch die MAC-Adresse des Batman-Devices der Domäne, ersetzt.

```
http_redirect:
  public: <URL>
  per_domain: <URL>
```

Es muss mindestens `public` oder `per_domain` konfiguriert sein.


**Beispiel:**

```
http_redirect:
  public: https://ingolstadt.freifunk.net
  per_domain: https://grafana.freifunk-ingolstadt.de/d/00000003/freifunk-ingolstadt-gateways?orgId=1&from=now-24h&to=now-1m&refresh=30s&var-node=NODEID
```
