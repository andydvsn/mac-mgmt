#!/bin/bash

## workspacestostore.sh v1.01 (27th January 2015)
##  Given a directory of user areas, this searches for a corresponding Store
##  directory and copies the user area to a new directory there.

if [ $# -lt 3 ]; then
	echo "Usage: $0 <source> <dest> <destdirname>"
	echo " source      : Source containing user areas, eg. /Volumes/Studio1Users/"
	echo " dest        : Destination containing matching dirs, eg. /Volumes/Drobo/Stores/"
	echo " destdirname : Directory name to put the copied area into within <dest>"
	exit 1
fi

for USERAREA in `ls -1 $1 | grep mf`; do

	DESTINATION=`find $2 -maxdepth 2 -iname $USERAREA`

	if [[ "$DESTINATION" == "" ]]; then
		[ -d $1/nostore ] || mkdir $1/nostore
		echo "No Store found for $USERAREA"
		mv $1/$USERAREA $1/nostore
	else
		[ -d $1/stored ] || mkdir $1/stored
		echo -n "Copying $1$USERAREA to $DESTINATION/$3..."
		[ -d $DESTINATION/$3 ] || mkdir $DESTINATION/$3
		cp -R $1/$USERAREA $DESTINATION/$3/
		echo " done."
		echo -n "Setting permissions..."
		chown -R $USERAREA:admin $DESTINATION/$3
		chmod -R 755 $DESTINATION/$3
		echo " done."
		mv $1/$USERAREA $1/stored
	fi

done

echo "User spaces with a matching Store in $2 have been copied."
echo "User spaces with no Store have been moved to $1nostore."
echo "This only checks for usernames starting 'mf'. Please check for remainders!"

exit 0
