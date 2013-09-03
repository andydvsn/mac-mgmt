#!/bin/bash

## enrolme.sh v1.01 (2nd September 2013) by Andy Davison

if [ "$USER" != "root" ]; then
	echo "Please run $0 as root."
	exit 0
fi

echo
echo "enrolme.sh v1.00 (2nd September 2013)"
echo "==========================================="
echo
echo "Before you run this, make sure you've set the name of the system"
echo "in System Preferences, under the Sharing component."
echo
echo "You should also have bound this system to Active Directory."
echo
echo "HINT: ou=ahc,ou=hum,ou=Workstations,dc=ds,dc=man,dc=ac,dc=uk"
echo
echo -n "Press <ENTER> if everything's ready..."
read WISH
echo

PROFILESERVER="xserve.studios"

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
