#!/bin/bash
#title          :set-brightness.sh
#description    :This script will increase/decrease the screen brightness
#author         :Jordi Marimon
#date           :20190422
#version        :0.1
#usage          :sudo bash set-brightness.sh <inc/dec> <%>
#===============================================================================================
BASEPATH=/sys/class/backlight
DEVICE="intel_backlight"
cd $BASEPATH
MAX=`cat ${DEVICE}/max_brightness`
CURRENT=`cat ${DEVICE}/actual_brightness`
PERCENT=`echo $MAX/100 | bc`

echo $PERCENT
if [ "$#" -ne 2 ]; then
    echo "Error: wrong parameters"
    echo "Run: # set-brightness.sh inc/dec percentage"
    exit -1
fi

MODE=$1
DELTA=$2
if [ "$MODE" = "inc" ]; then
    # Increase brightness an x%
    NEW_BRIGHT="$(( $CURRENT + ( $PERCENT * $DELTA ) ))"
    if [ $NEW_BRIGHT -gt $MAX ]; then
        NEW_BRIGHT=$MAX
    fi
elif [ "$MODE" = "dec" ]; then
    # Decrease brightness an x%
    NEW_BRIGHT="$(( $CURRENT - ( $PERCENT * $DELTA) ))"
    if [ $NEW_BRIGHT -lt 0 ]; then
        NEW_BRIGHT=0
    fi
else
    echo "Option: $MODE does not exists. Please use inc or dec"
    exit -1
fi
# Set the new bright
echo $NEW_BRIGHT
echo $NEW_BRIGHT > ${DEVICE}/brightness
exit 0
