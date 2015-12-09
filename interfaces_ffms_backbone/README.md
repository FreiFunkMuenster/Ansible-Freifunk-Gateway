## Tunnel für das Routing von den Domänen zum FFMS Backbone

### Rollen
Es gibt zwei Rollen, die die Tunnel zwischen den Supernodes der einzelnen Domänen und dem FFMS Backbone aufbauen.

- interfaces_ffms_backbone (diese Rolle)
- interfaces_ffms_supernodes

Die Rolle <pre>interfaces_ffms_backbone</pre> muss auf den Backbone Servern ausgeführt werden. Die Rolle <pre>interfaces_ffms_supernodes</pre> muss auf den Supernodes ausgeführt werden.

### Konfiguration
Die Konfiguration findet ausschließlich in den <pre>host_vars</pre> statt.
Die Konfiguration sieht exemplarisch wie folgt aus:
<code>
ffms_tun_to:
- host_name: remue-01
  v4routing_net: 10.43.1.4/30
  v6routing_net: 2a03:2260:115:ffa0::4/126
- host_name: test-des5
  v4routing_net: 10.43.1.8/30
  v6routing_net: 2a03:2260:115:ffa0::8/126 
</code>

#### Hinweise

- <pre>host_name</pre> bezeichnet nicht den Hostnamen, der auf dem Server konfiguriert ist, sondern der habe der in Ansible in der <pre>hosts</pre> Datei steht.
- Das IPv6-Subnetz, welches geroutet werden muss brauch nicht gesondert angegeben werden, da dieses bereits in den <pre>group_vars</pre> der jeweiligen Domäne konfiguriert ist.
- Der Backbone-Server muss in der Ansible-Gruppe <pre>backbone</pre> sein, damit das Template funktioniert. Falls mehr Flexibilität erfoderlich sein sollte, müsste das noch angepasst werden.

