#!/bin/bash

## whatami.sh v1.00 (9th October 2014)
##  Displays the useful information about what a Mac actually is.

IOREG=`ioreg -p IODeviceTree -r -n / -d 1`
echo "$IOREG" | grep model | awk -F\"  {'print $4'}
echo "$IOREG" | grep board-id | awk -F\"  {'print $4'}
