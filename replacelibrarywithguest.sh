#!/bin/bash

# replacelibrarywithguest.sh v1.00 (1st September 2014) by Andy Davison

if [ "$USER" != "root" ]; then
	echo "Please run $0 as root."
	exit 0
fi

echo
echo "replacelibrarywithguest.sh v1.00 (1st September 2014)"
echo "====================================================="
echo
echo "This will replace the Library in the Default User Template"
echo "with the one from the Guest user, then repair permissions."
echo
echo -n "Press <ENTER> to continue..."
read WISH
echo

if [ ! -d /Users/Guest/Library ]; then
	echo "No Library could be found for the Guest user. They must be logged in for it to exist!"
	exit 1
fi

echo -n "Removing current default Library..."
rm -rf /System/Library/User\ Template/English.lproj/Library
echo " done."

echo -n "Copy in current Guest Library..."
cp -R /Users/Guest/Library /System/Library/User\ Template/English.lproj/
echo " done."

echo -n "Emptying the Keychain from the new default Library..."
rm -rf /System/Library/User\ Template/English.lproj/Library/Keychains
mkdir /System/Library/User\ Template/English.lproj/Library/Keychains
echo " done."

echo -n "Removing additional ACLs..."
xattr -c /System/Library/User\ Template/English.lproj/Library
echo " done."

echo
diskutil repairpermissions /
echo

echo "All done. You can now log out the Guest user."
exit 0
