#!/bin/bash

# installbootefi.sh v1.04 (30th January 2015) by Andy Davison
#  Installs whatever boot.efi file you point it to into the right places.

if [ "$USER" != "root" ]; then
	echo "You need root privileges to do this!"
	exit 0
fi

if [[ $# -lt 2 ]]; then
	echo "Usage: $0 <target root> <boot.efi> [watchdog]"
	exit 0
fi

TARGET="$1"
BOOTEFI="$2"

replace_bootefi() {

	echo "Removing previous boot.efi files..."
	chflags nouchg $TARGET/System/Library/CoreServices/boot.efi
	chflags nouchg $TARGET/usr/standalone/i386/boot.efi
	cp $TARGET/System/Library/CoreServices/boot.efi $TARGET/System/Library/CoreServices/boot.efi.prev
	cp $TARGET/usr/standalone/i386/boot.efi $TARGET/usr/standalone/i386/boot.efi.prev
	rm -vf $TARGET/System/Library/CoreServices/boot.efi
	rm -vf $TARGET/usr/standalone/i386/boot.efi
	echo

	echo "Copying boot.efi..."
	cp -v "$BOOTEFI" $TARGET/System/Library/CoreServices/boot.efi
	cp -v "$BOOTEFI" $TARGET/usr/standalone/i386/boot.efi
	echo

	echo "Setting permissions..."
	chmod 644 $TARGET/System/Library/CoreServices/boot.efi
	chmod 644 $TARGET/usr/standalone/i386/boot.efi
	chown root:wheel $TARGET/System/Library/CoreServices/boot.efi
	chown root:wheel $TARGET/usr/standalone/i386/boot.efi
	xattr -c $TARGET/System/Library/CoreServices/boot.efi
	xattr -c $TARGET/usr/standalone/i386/boot.efi
	chflags uchg $TARGET/System/Library/CoreServices/boot.efi
	chflags uchg $TARGET/usr/standalone/i386/boot.efi
	echo "Complete."

} 

CHECKEFI=0
[ -f $TARGET/System/Library/CoreServices/boot.efi ] && CHECKEFI=$(($CHECKEFI+1))
[ -f $TARGET/usr/standalone/i386/boot.efi ] && CHECKEFI=$(($CHECKEFI+1))

if [[ $CHECKEFI -ne 2 ]]; then
	echo "Cannot find the original boot.efi files on your target."
	echo "Is your target correct? (eg. /Volumes/Macintosh)"
	exit 0
fi

if [ $# -eq 3 ]; then

	echo "Exercising the watchdog..."

	EFIONETHEN=`stat -f %m $TARGET/System/Library/CoreServices/boot.efi`
	EFITWOTHEN=`stat -f %m $TARGET/usr/standalone/i386/boot.efi`

	while true ; do

		EFIONENOW=`stat -f %m $TARGET/System/Library/CoreServices/boot.efi`
		EFITWONOW=`stat -f %m $TARGET/usr/standalone/i386/boot.efi`

		if [[ "$EFIONENOW" != "$EFIONETHEN" ]] || [[ "$EFITWONOW" != "$EFITWOTHEN" ]]; then

			replace_bootefi
			EFIONETHEN=`stat -f %m $TARGET/System/Library/CoreServices/boot.efi`
			EFITWOTHEN=`stat -f %m $TARGET/usr/standalone/i386/boot.efi`

		fi

		sleep 1

	done

else

	if [[ "$TARGET" == "/" ]]; then
		echo "You are about to replace the boot.efi files on your current boot volume!"
	else
		echo "You are about to replace the boot.efi files on $TARGET"
	fi
	echo "There is no undo. There is only do."
	echo
	echo -n "Are you sure? (y/n) "
	read SURE
	echo

	if [ "$SURE" == "y" ] || [ "$SURE" == "Y" ]; then
		
		replace_bootefi
		exit 0

	else

		echo "Exited."
		exit 0
		
	fi

fi