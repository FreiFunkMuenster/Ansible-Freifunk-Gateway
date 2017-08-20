#!/bin/bash
set > /tmp/test1.txt

if [ "$HOSTALIAS" == "" ]; then
    echo Wird nur aus Icinga heraus aufgerufen!
    exit 1
fi

case "$SERVICESTATE" in
  OK)
    COLOR=green
    ;;
  WARNING)
    COLOR=yellow
    ;;
  CRITICAL)
    COLOR=red
    ;;
  UNKNOWN)
    COLOR=blue
    ;;
  *)
    COLOR=blue
    ;;
esac

curl  -d "{\"color\":\"$COLOR\",\"message\":\"$LONGDATETIME: service $SERVICEDESC on host $HOSTALIAS is $SERVICESTATE ($SERVICEOUTPUT) $NOTIFICATIONTYPE \",\"notify\":false,\"message_format\":\"text\"}" -H 'Content-Type: application/json' {{ icinga_alert_hipchat_url }}
