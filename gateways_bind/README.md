# gateways_bind

Diese Rolle installiert den DNS-Server Bind9 auf Gateways.

Dieser DNS-Server wird durch die Clients im Freifunk-Netz für die Namensauflösung verwendet.
Er ist als "Forwarding DNS Server" konfiguriert, d.h. Anfragen, die er nicht selbst beantworten kann, werden an die vom jeweiligen Gateway verwendeten DNS-Server weitergereicht.

Für jede Domäne wird eine eigene DNS-Zone installiert.
Für den einfachen Zugriff auf die Access Point werden die DNS-Einträge "node.<freifunk.kurzname>", "knoten.<freifunk.kurzname>" und "freifunk.<freifunk.kurzname>" gesetzt.



## Konfiguration
Erforderlich ist die Angabe von `bind_zonemaster.server` und `bind_zonemaster.email`:
```
bind_zonemaster:
  server: localhost
  email: noc@freifunk-beispielstadt.de
```
* `server`: Falls mehrere DNS-Server in einer Master-Slave-Konstallation betrieben werden hier den Hostnamen des Master-Servers eintragen. Ansonsten "localhost" eintragen.
* `email:`: E-Mailadresse des DNS-Verantwortlichen zur Konaktaufnahme

Außerdem wird `freifunk.kurzname` als interne Standard-DNS-Domain verwendet:
```
freifunk:
  kurzname: ffms
```


### Optional: Weitere DNS-Einträge hinzufügen
Durch die optionale Variable `freifunk.ffnet_dns_entries_for_internal_tld` können weitere DNS-Einträge zu den Domänen hinzugefügt werden:

**Beispiel:**

```
freifunk:
  kurzname: ffms
  [...]
  ffnet_dns_entries_for_internal_tld:
    "foo":
      A: 11.11.11.11
    "bar":
      A: 22.22.22.22
      AAAA: 2a03:2260::22
    "baz":
      A: 33.33.33.33
      AAAA:
        - 2a03:2260::33
        - 2a03:2260::44
```
Ergibt dann in den Zonefiles "/etc/bind/db.domaene-*.ffnet" aller Domänen folgende Einträge:
```
  foo    IN      A       11.11.11.11
  bar    IN      A       22.22.22.22
  bar    IN      AAAA    2a03:2260::22
  baz    IN      A       33.33.33.33
  baz    IN      AAAA    2a03:2260::33
  baz    IN      AAAA    2a03:2260::44
```
Die so hinzugefügten Hosts werden in allen Domänen als "Hostname.<freifunk.kurzname>" aufgelöst, hier also "foo.ffms", "bar.ffms" und "baz.ffms".

# TODO:
- is_external_nameserver