#!/bin/bash

if [ "$HOSTALIAS" == "" ]; then
    echo Wird nur aus Icinga heraus aufgerufen! 
    exit 1
fi


case "$HOSTSTATE" in
  UP)
    COLOR=green
    ;;
  DOWN)
    COLOR=red
    ;;
  UNREACHABLE)
    COLOR=blue
    ;;
  *)
    COLOR=blue
    ;;
esac

curl  -d "{\"color\":\"$COLOR\",\"message\":\"$LONGDATETIME: host $HOSTALIAS is $HOSTSTATE ($HOSTOUTPUT) $NOTIFICATIONTYPE \",\"notify\":false,\"message_format\":\"text\"}" -H 'Content-Type: application/json' {{ icinga_alert_hipchat_url }}
