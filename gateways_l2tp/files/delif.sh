#!/bin/bash
INTERFACE="$3"
PORT="$9"
DOM=${PORT#200}
brctl delif br$DOM $INTERFACE
