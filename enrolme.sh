#!/bin/bash

## enrolme.sh v1.01 (26th March 2014) by Andy Davison

if [ "$USER" != "root" ]; then
	echo "Requires superuser privileges."
	exit 0
fi

if [ $# -lt 1 ]; then
	echo "Usage: $0 <server> [auto]"
	exit 0
fi

PROFILESERVER="$1"

if [ "$2" == "" ]; then
	echo
	echo "enrolme.sh v1.01 (26th March 2014)"
	echo "=================================="
	echo
	echo "Before you run this, make sure you've set the name of the system"
	echo "in System Preferences, under the Sharing component."
	echo
	echo "You should also have bound this system to Active Directory."
	echo
	echo "HINT: ou=ahc,ou=hum,ou=Workstations,dc=ds,dc=man,dc=ac,dc=uk"
	echo
	echo "Profiles will be downloaded from: http://$PROFILESERVER/system/"
	echo
	echo -n "Press <ENTER> to install if everything's ready..."
	read WISH
	echo
fi


echo "Removing existing profiles..."
/usr/bin/profiles -D -f all

echo "Fetching profiles from $PROFILESERVER..."
echo
/usr/bin/curl -o /tmp/trust.mobileconfig http://$PROFILESERVER/system/trust.mobileconfig
/usr/bin/curl -o /tmp/studios.mobileconfig http://$PROFILESERVER/system/studios.mobileconfig

echo
echo "Installing trust..."
/usr/bin/profiles -I -F /tmp/trust.mobileconfig
sleep 2

echo "Installing enrolment..."
/usr/bin/profiles -I -F /tmp/studios.mobileconfig

echo
echo "You should now add this system to an appropriate group in Profile Manager."
