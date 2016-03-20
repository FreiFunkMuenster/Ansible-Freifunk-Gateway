#!/bin/bash
INTERFACE="$3"
PORT="$7"
DOM=${PORT#200}
brctl delif br$DOM $INTERFACE
