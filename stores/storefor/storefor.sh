#!/bin/bash

## storefor.sh v1.01 (25th March 2014) by Andy Davison
##  This creates a store folder for the given user, if certain criteria are met.
##  It should be triggered by a 'storefor_USERNAME' appearing in /tmp and is triggered by launchd.

STORETEMPLATE="/Volumes/Drobo/Stores/.store_template"
STORELOCATION="/Volumes/Drobo/Stores"

#echo "Running!"

# So, we find out who we're creating a Store for...
for f in `find -f /tmp/storefor_* 2>/dev/null`
do

	# Read the group from the file, then bin the file.
	STOREGROUP=`cat $f`
	rm -f $f

	# Read the username from the filename.
	STORENAME=`echo $f | awk -F\_ '{print $2}'`

	# Work out where the Store should live.
	THISSTOREGROUP=""

	[[ "$STOREGROUP" =~ "aca" ]] || [[ "$STOREGROUP" =~ "Acad" ]] && THISSTOREGROUP="Academics"
	[[ "$STOREGROUP" =~ "pos" ]] || [[ "$STOREGROUP" =~ "Post" ]]&& THISSTOREGROUP="Postgraduates"
	[[ "$STOREGROUP" =~ "und" ]] || [[ "$STOREGROUP" =~ "Under" ]]&& THISSTOREGROUP="Undergraduates"

	if [[ "$THISSTOREGROUP" == "" ]]; then

		echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : WARN : New Store requested, but '$STOREGROUP' is not a valid group name in $f."
		exit 0

	else

		THISSTOREPATH="$STORELOCATION/$THISSTOREGROUP/$STORENAME"

		if [ -d $THISSTOREPATH ]; then

			echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : WARN : Store for '$STORENAME' already exists as $THISSTOREPATH"
			exit 0

		else

			echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Creating a new Store for '$STORENAME' as $THISSTOREPATH"

			# If there's a nice template, use it.
			if [ -d $STORETEMPLATE ]; then

				/usr/bin/ditto "$STORETEMPLATE" "$THISSTOREPATH" 2>/dev/null

			else

				/bin/mkdir "$THISSTOREPATH"

			fi

			# Set permissions.
			/usr/sbin/chown -R "$STORENAME:admin" "$THISSTOREPATH"
			/bin/chmod 770 -R "$THISSTOREPATH"

		fi

	fi

done