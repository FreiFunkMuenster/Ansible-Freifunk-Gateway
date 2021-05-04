# watchdog

Diese Rolle installiert den Watchdog-Dämon

Der Server wird neu gestartet wenn eine der folgenden Bedingungen zutrifft:
- Kernel sendet keine Lebenszeichen mehr an das Watchdog-Device
- Die durchschnittliche Last liegt fünf Minuten lang 25 mal höher als die Anzahl der CPU-Cores
- Es ist weniger als 1 MByte freier RAM verfügbar

Wenn kein Hardware-Watchdog verfügbar ist dann wird das Softdog-Kernelmodul installiert und verwendet.
