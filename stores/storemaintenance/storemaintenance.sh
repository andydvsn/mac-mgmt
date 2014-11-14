#!/bin/bash

# storemaintenance.sh v1.00 (14th November 2014)
#  Scans the Stores and automatically removes content when ancient.

set -e

STORELOC="/Volumes/Drobo/Stores"

for STORETYPE in `ls -1 $STORELOC | grep -vF . | grep -v Academics`; do

	echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Looking at $STORETYPE..."

	STORESAVING=0
	for STOREUSER in `ls -1 $STORELOC/$STORETYPE | grep mf`; do

		AGE=999
		[[ "$STORETYPE" == "Undergraduates" ]] && AGE=400
		[[ "$STORETYPE" == "Postgraduates" ]] && AGE=600

		NEWFILE=`find $STORELOC/$STORETYPE/$STOREUSER -type f -mtime -$AGE -not -path '*/\.*' -print -quit`

		if [[ "$NEWFILE" == "" ]]; then

			USERINFO=`/usr/bin/ldapsearch -x -H ldap://ldap.man.ac.uk -s sub -b "c=uk" "cn=$STOREUSER"`
			FULLNAME=`echo "$USERINFO" | grep fullName | awk -F\:\  '{print $2}'`
			[[ "$FULLNAME" == "" ]] && FULLNAME="DELETED USER"

			USERSAVING=`du -ms $STORELOC/$STORETYPE/$STOREUSER | awk -F\  '{print $1}'`
			STORESAVING=$(($STORESAVING+$USERSAVING))

			echo
			echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : $FULLNAME ($STOREUSER) has been inactive for $AGE days. Beginning deletion."

			[[ "$1" == "" ]] && rm -rf $STORELOC/$STORETYPE/$STOREUSER
			[[ "$1" != "" ]] && echo "TEST MODE : rm -rf $STORELOC/$STORETYPE/$STOREUSER"

			echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Deletion of $STOREUSER recovered $USERSAVING MB."

		fi

	done

	STORESAVINGUNITS="MB"
	if [ $STORESAVING -gt 2000 ]; then
		STORESAVINGUNITS="GB"
		STORESAVING=$(($STORESAVING/1000))
	fi
	echo
	echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Total deletions from $STORETYPE recovered $STORESAVING $STORESAVINGUNITS"
	echo

done