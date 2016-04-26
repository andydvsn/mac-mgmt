#!/bin/bash

## drobologinwait.sh v1.01 (26th April 2016) by Andy Davison
##  Delays the appearance of the login window until the array is online.

DEBUG=0
DELAY=360
CHECK="/Users/.droboready"
SETUP="/Users/.drobosetup"
DRLOG="/var/log/drobologinwait.log"
##

# Exit if we're in a setup state.
[ -f /Users/.drobosetup ] && exit 0

# Housekeeping.
touch $DRLOG
LOGSIZE=$(du -k "$DRLOG" | cut -f 1)
if [ $LOGSIZE -gt 20 ]; then
	echo > $DRLOG
else
	echo >> $DRLOG
fi

# Off we go.
echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Holding the login window for $DELAY seconds." >> $DRLOG
[ $DEBUG = 1 ] || launchctl unload -w /System/Library/LaunchDaemons/com.apple.loginwindow.plist

COUNTER=0
until [ -f $CHECK ]; do 

	if [ -f /Users/.drobosetup ]; then
		echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Setup detected. Enabling the login window." >> $DRLOG
		[ $DEBUG = 1 ] || launchctl load -wF /System/Library/LaunchDaemons/com.apple.loginwindow.plist
		exit 1
	fi

	sleep 1
	let "COUNTER++"
	[ $DEBUG = 1 ] && echo "Waiting $COUNTER..."

	if [ $COUNTER -eq $DELAY ]; then
		echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : WARN : Timeout of $DELAY seconds reached. Rebooting." >> $DRLOG
		[ $DEBUG = 1 ] || reboot
		exit 1
	fi

done

echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Login window enabled after $COUNTER seconds." >> $DRLOG
[ $DEBUG = 1 ] || launchctl load -wF /System/Library/LaunchDaemons/com.apple.loginwindow.plist
exit 0
