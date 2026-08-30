#!/bin/bash

GREETING="Hello, Good Morning"
echo "$GREETING"
echo "PID of SCRIPT-1: $$"

#./script-2.sh

source ./script-2.sh
echo "PID of SCRIPT-2: $SCRIPT_2_PID"