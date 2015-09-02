#!/bin/bash

## freshadmin.sh v1.01 (2nd September 2015) by Andy Davison
##  Replaces the admin user account with a shiny new one from a server.
##  Also checks that you have Shared and Technical directories with the right permissions.

# Path to file on server. Files on the server should be named in 'admin_10.X.tgz' format,
# where X is the OS X secondary version number, eg. 'admin_10.10.tgz' for Yosemite.
SERVERPATH="172.16.10.1/system/users"

if [ "$USER" != "root" ]; then
	echo "You need to run this as a superuser."
	exit 1
fi

ADMINLOGGEDIN=`who | grep console | grep -c admin`
if [ $ADMINLOGGEDIN -ne 0 ]; then
	echo "Halting. The admin user is logged in on the console."
	exit 1
fi

if [ ! -d /Users/Shared ]; then
	echo -n "No Shared directory. Recreating..."
	mkdir /Users/Shared
	chown 0:0 /Users/Shared
	chmod 777 /Users/Shared
	chmod +t /Users/Shared
	echo " done."
fi

if [ ! -d /Users/Technical ]; then
	echo -n "No Technical directory. Recreating..."
	mkdir /Users/Technical
	chown 501:80 /Users/Technical
	chmod 700 /Users/Technical
	echo " done."
fi

OSXVER=`sw_vers -productVersion | awk -F\. {'print $2'}`
FILENAME="admin_10.$OSXVER.tgz"

echo -n "Fetching fresh admin user area for OS X v10.$OSXVER..."
FETCH=$(curl -sSf -o /var/root/$FILENAME $SERVERPATH/$FILENAME)

if [ $? -eq 0 ]; then

	echo -n " checksumming..."

	SUM1=`curl -s $SERVERPATH/$FILENAME.md5 | awk -F\=\  {'print $2'}`
	SUM2=`md5 /var/root/$FILENAME | awk -F\=\  {'print $2'}`

	if [[ "$SUM1" == "$SUM2" ]]; then

		echo " matched."
		echo -n "Replacing current admin user..."
		rm -rf /Users/admin
		tar zxf /var/root/$FILENAME -C /Users/
		rm /var/root/$FILENAME
		echo " done."
		exit 0

	else

		echo " failed."
		echo
		echo "Checksum mismatch."
		rm /var/root/$FILENAME
		exit 1

	fi

	exit 0

else

	echo
	echo "A template for the admin user on OS X v10.$OSXVER was not found."
	echo "I was looking for http://$SERVERPATH/$FILENAME"
	echo
	exit 1

fi


