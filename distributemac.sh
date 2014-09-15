#!/bin/bash

## distributemac.sh v1.03 (2nd September 2014) by Andy Davison
##  Prepares OS X to be imaged.

if [ "$USER" != "root" ]; then
	echo "$0 requires superuser privileges."
	exit 1
fi

echo
echo "distributemac.sh v1.03 (2nd September 2014)"
echo "==========================================="
echo
echo "Before you run this, destroy the three com.apple.kerberos.kdc files"
echo "in the system keychain. Use Keychain Access to do this."
echo
echo -n "Press <ENTER> to continue..."
read WISH
echo

echo -n "Unhooking from directory servers..."
rm -rf /Library/Preferences/DirectoryService/*
echo " done."

echo -n "Destroying remnants of Kerberos configuration..."
rm -rf /var/db/krb5kdc
echo " done."

echo -n "Removing machine-specific network configuration..."
rm /Library/Preferences/SystemConfiguration/com.apple.network.identification.plist 2>/dev/null
rm /Library/Preferences/SystemConfiguration/NetworkInterfaces.plist 2>/dev/null
rm /Library/Preferences/SystemConfiguration/preferences.plist 2>/dev/null
echo " done."

echo -n "Making absolutely sure there's no keychain in the Default User template..."
rm -rf /System/Library/User\ Template/English.lproj/Library/Keychains
mkdir /System/Library/User\ Template/English.lproj/Library/Keychains
echo " done."

echo -n "Removing old log files..."
rm -rf /Users/admin/Library/Logs/* 2>/dev/null
rm -rf /Library/Logs/* 2>/dev/null
mkdir /Library/Logs/DiagnosticReports 2>/dev/null
chown root:admin /Library/Logs/DiagnosticReports 2>/dev/null
chmod 750 /Library/Logs/DiagnosticReports 2>/dev/null
rm -rf /var/log/*.gz 2>/dev/null
echo > /var/log/apache2/access_log 2>/dev/null
echo > /var/log/apache2/error_log 2>/dev/null
rm -rf /var/log/appstore.log 2>/dev/null
rm -rf /var/log/asl/* 2>/dev/null
echo > /var/log/authd.log 2>/dev/null
echo > /var/log/com.apple.revisiond/revisiond.log 2>/dev/null
rm -rf /var/log/com.apple.launchd* 2>/dev/null
echo > /var/log/cups/access_log 2>/dev/null
echo > /var/log/cups/error_log 2>/dev/null
echo > /var/log/cups/page_log 2>/dev/null
echo > /var/log/daily.out 2>/dev/null
rm -rf /var/log/displaypolicyd* 2>/dev/null
rm -rf /var/log/DiagnosticMessages/* 2>/dev/null
echo > /var/log/fsck_hfs.log 2>/dev/null
rm /var/log/hdiejectd.log 2>/dev/null
echo > /var/log/install.log 2>/dev/null
rm -rf /var/log/module/com.apple.securityd/*.gz 2>/dev/null
echo > /var/log/monthly.out 2>/dev/null
echo > /var/log/notifyd.log 2>/dev/null
echo > /var/log/opendirectoryd.log 2>/dev/null
rm -rf /var/log/opendirectoryd.log.* 2>/dev/null
rm -rf /var/log/powerman.log 2>/dev/null
rm -rf /var/log/powermanagement/*.asl 2>/dev/null
echo > /var/log/system.log 2>/dev/null
echo > /var/log/weekly.out 2>/dev/null
echo > /var/log/wifi.log 2>/dev/null
echo " done."
echo

diskutil repairpermissions /

echo
echo -n "Would you like to shut down now? (y/n) "
read SHUTDWN

if [ "$SHUTDWN" == "y" ] || [ "$SHUTDWN" == "Y" ]; then
	echo
	echo "Bye, everyone!"
	echo
	echo > /Users/admin/.bash_history
	shutdown -h now
	exit 0
else
	echo
	echo "If you reboot into this installation, you'll need to run this script again."
	echo "You may find that certain services do not work as designed until the system has been restarted."
	echo
	exit 0
fi

exit 0
