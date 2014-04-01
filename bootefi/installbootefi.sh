#!/bin/bash

# installbootefi.sh v1.00 by Andy Davison
#  Installs whatever boot.efi file you point it to into the right places.

if [ "$USER" != "root" ]; then
	echo "You need root privileges to do this!"
	exit 0
fi

if [[ $# -ne 2 ]]; then
	echo "Usage: $0 <target root> <boot.efi>"
	exit 0
fi

TARGET="$1"
BOOTEFI="$2"

CHECKEFI=0
[ -f $TARGET/System/Library/CoreServices/boot.efi ] && CHECKEFI=$(($CHECKEFI+1))
[ -f $TARGET/usr/standalone/i386/boot.efi ] && CHECKEFI=$(($CHECKEFI+1))

if [[ $CHECKEFI -ne 2 ]]; then
	echo "Cannot find the original boot.efi files on your target."
	echo "Is your target correct? (eg. /Volumes/Macintosh)"
	exit 0
fi

echo "This will replace your boot.efi files with the one you have specified."
echo "There is no undo. There is only do."
echo
echo -n "Are you sure? (y/n) "
read SURE
echo

if [ "$SURE" == "y" ] || [ "$SURE" == "Y" ]; then
	
	echo "Removing previous boot.efi files..."
	rm -f $TARGET/System/Library/CoreServices/boot.efi
	rm -f $TARGET/usr/standalone/i386/boot.efi

	echo "Copying boot.efi..."
	cp "$BOOTEFI" $TARGET/System/Library/CoreServices/boot.efi
	cp "$BOOTEFI" $TARGET/usr/standalone/i386/boot.efi

	echo "Setting basic permissions..."
	chmod 644 $TARGET/System/Library/CoreServices/boot.efi
	chmod 644 $TARGET/usr/standalone/i386/boot.efi
	chown root:wheel $TARGET/System/Library/CoreServices/boot.efi
	chown root:wheel $TARGET/usr/standalone/i386/boot.efi

	echo "Repairing system permissions..."
	diskutil repairpermissions $TARGET

	echo "Complete."
	exit 0

else

	echo "Exited."
	exit 0
	
fi