## Tunnel für das Routing von den Domänen zum FFMS Backbone

### Rollen
Es gibt zwei Rollen, die die Tunnel zwischen den Supernodes der einzelnen Domänen und dem FFMS Backbone aufbauen.

- ``interfaces_ffms_backbone``
- ``interfaces_ffms_supernodes`` (diese Rolle)

Die Rolle ``interfaces_ffms_backbone`` muss auf den Backbone Servern ausgeführt werden. Die Rolle ``interfaces_ffms_supernodes`` muss auf den Supernodes ausgeführt werden.

### Konfiguration
Die Konfiguration findet ausschließlich in den ``host_vars`` statt.
Die Konfiguration sieht exemplarisch wie folgt aus:

```
ffms_tun_to:
- host_name: remue-01
  v4routing_net: 10.43.1.4/30
  v6routing_net: 2a03:2260:115:ffa0::4/126
- host_name: test-des5
  v4routing_net: 10.43.1.8/30
  v6routing_net: 2a03:2260:115:ffa0::8/126 
```

#### Hinweise

- ``host_name`` bezeichnet nicht den Hostnamen, der auf dem Server konfiguriert ist, sondern der habe der in Ansible in der ``hosts`` Datei steht.
- Das IPv6-Subnetz, welches geroutet werden muss brauch nicht gesondert angegeben werden, da dieses bereits in den ``group_vars`` der jeweiligen Domäne konfiguriert ist.
- Der Backbone-Server muss in der Ansible-Gruppe ``backbone`` sein, damit das Template funktioniert. Falls mehr Flexibilität erfoderlich sein sollte, müsste das noch angepasst werden.

