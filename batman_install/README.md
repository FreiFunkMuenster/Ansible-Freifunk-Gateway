# batman_install

Diese Rolle installiert das Batman-Kernelmodul und batctl.

## Konfiguration
Ohne weitere Konfiguration wird das Batman-Modul des aktuellen Kernels und batctl aus dem Debian- bzw. Ubuntu-Repository installiert.

Optional kann die zu installierende Batman-Version durch setzten der Variable `batman.version` ausgewählt werden:


**Beispiel:**
```
batman:
  version: "2018.1"
```

In `batman.version` kann eine beliebige Versionsnummer von https://downloads.open-mesh.org/batman/releases/ verwendet werden.
Achtung: Sehr alte Versionen sind nicht nutzbar, da sie sich nicht mehr mit einem aktuellen Kernel kompilieren lassen.

Wird als Version "2013.4.0" gesetzt, dann wird Batman von https://github.com/freifunk-gluon/batman-adv-legacy.git installiert.

Fehlt die Variable `batman.version` oder wird als Version "kernel" angegeben, so wird das Batman-Modul des aktuell verwendeten Kernels benutzt und batctl aus dem Debian- bzw. Ubuntu-Repository installiert.

Entspricht die ausgewählte Version der des Batman-Moduls des installierten Kernels, dann wird nicht kompiliert, sondern einfach das vorhandene Kernelmodul verwendet.