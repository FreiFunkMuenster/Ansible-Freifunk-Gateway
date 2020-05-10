# tunearpcache

Diese Rolle vergößert den ARP-Cache des Linux-Kernels und sollte auf allen Servern ausgerollt werden, auf denen es ein Batman-Interface gibt.

Im ARP-Cache wird die Zuordnung von MAC- zu IP-Adresse gespeichert.

Je größer der ARP-Cache, desto seltener müssen im Netzwerk ARP-Requests durchgeführt werden.
Eine Vergrößerung des ARP-Cache kann so für eine kleine Reduzierung der Netzlast sorgen.

Batman hat zwar selbst einen ARP-Cache, jedoch nur für IPv4. Für IPv6 wird der ARP-Cache von Linux benutzt.

## Konfiguration
Keine.