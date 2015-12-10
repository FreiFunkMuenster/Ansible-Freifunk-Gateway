## Bird-Rolle für die FFMS Backbone-Server
Zusätzlich zu den üblichen ``host_vars`` (ffrl settings, etc) ist für die Bird-Backbone-Rolle noch folgendes in die ``backbone`` Gruppe in den ``group_vars`` einzutragen:

Beispielcode:

```
ffms_routing:
  net: 2a03:2260:115::/48
  domaenen:
  - group_name: domaene-01
    v6_net: 2a03:2260:115:100::/56
  - group_name: domaene-02
    v6_net: 2a03:2260:115:200::/56
```
