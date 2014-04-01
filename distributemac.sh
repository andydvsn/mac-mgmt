#!/bin/bash

# distributemac.sh v1.01 (5th December 2012) by Andy Davison

if [ "$USER" != "root" ]; then
	echo "Please run $0 as root."
	exit 0
fi

echo
echo "distributemac.sh v1.01 (5th December 2012)"
echo "==========================================="
echo
echo "Before you run this, destroy the three com.apple.kerberos.kdc files"
echo "in the system keychain. Use Keychain Access to do this."
echo
echo -n "Press <ENTER> to continue..."
read WISH
echo

echo -n "Unhooking from directory servers by force..."
rm -rf /Library/Preferences/DirectoryService/*
echo " done."

echo -n "Destroying remnants of kerberos configuration..."
rm -rf /var/db/krb5kdc
echo " done."

echo -n "Removing machine-specific network configuration..."
rm /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist 2>/dev/null
rm /Library/Preferences/SystemConfiguration/com.apple.network.identification.plist 2>/dev/null
rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist 2>/dev/null
rm /Library/Preferences/SystemConfiguration/preferences.plist 2>/dev/null
echo " done."

echo -n "Making absolutely sure there's no keychain in the Default User template..."
rm -rf /System/Library/User\ Template/English.lproj/Library/Keychains
mkdir /System/Library/User\ Template/English.lproj/Library/Keychains
echo " done."
echo

echo -n "Would you like to shut down now? (y/n) "
read SHUTDWN

if [ "$SHUTDWN" == "y" ] || [ "$SHUTDWN" == "Y" ]; then
	echo
	echo "Bye, everyone!"
	echo
	shutdown -h now
	exit 0
else
	echo
	echo "If you reboot into this installation, you'll need to run this script again."
	echo "Don't hang around too long, or configurations may be regenerated!"
	echo
	exit 0
fi
