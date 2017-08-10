#!/usr/bin/env bash
omd su ffms <<EOT
omd config set CORE icinga2
omd config set ADMIN_MAIL {{ freifunk.email  }}
omd config set PNP4NAGIOS off
omd config set GRAFANA on
omd config set INFLUXDB on
omd config set NAGFLUX on
exit
EOT
