#!/bin/bash

# freshadmin.sh v1.00 (15th April 2014) by Andy Davison
#  Replaces the admin user folder with a fresh one from somewhere.
#  Expects a gzipped tarball called 'admin-10.<osver>.tgz', eg. admin-10.9.tgz.

if [[ "$USER" != "root" ]]; then
	echo "Super-user privileges required."
	exit 0
fi

OSVER=`sw_vers -productVersion | awk -F\. {'print $2'}`

## Where is the fresh admin user area?
PATH="http://governor.studios/users/admin-10.$OSVER.tgz"
##

echo "Fetching new admin user area..."
cd /tmp && /usr/bin/curl -sO "$PATH"
echo "Removing old admin user area..."
/bin/rm -rf /Users/admin
echo "Copying new admin user area..."
/usr/bin/tar zxf /tmp/admin-10.$OSVER.tgz -C /Users
/bin/rm /tmp/admin-10.$OSVER.tgz
echo "Done."
exit 0
