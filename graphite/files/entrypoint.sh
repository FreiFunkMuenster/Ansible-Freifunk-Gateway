#!/bin/bash

PYTHONPATH=/var/lib/graphite/lib
LC_ALL=en_US.UTF-8

python /var/lib/graphite/lib/graphite/manage.py syncdb --noinput

/usr/bin/supervisord -c /etc/supervisord.conf


