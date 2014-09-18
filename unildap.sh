#!/bin/bash

## unildap.sh v1.01 (18th September 2014)
##  Unauthenticated reads from the university LDAP server.
##  Only works on campus, for obvious reasons.

if [ $# -lt 1 ]; then
	echo "Usage: $0 <username|id> [raw]"
	exit 1
fi

if [[ "$1" =~ [^0-9] ]]; then
	SEARCHTERM="$1"
	USERINFO=`/usr/bin/ldapsearch -x -H ldap://ldap.man.ac.uk -s sub -b "c=uk" "cn=$SEARCHTERM"`
else
	SEARCHTERM=`echo $1 | cut -b 1-7`
	USERINFO=`/usr/bin/ldapsearch -x -H ldap://ldap.man.ac.uk -s sub -b "c=uk" "umanPersonID=$SEARCHTERM"`
fi

[ "$2" == "raw" ] && echo "$USERINFO" && exit 0

FULLNAME=`echo "$USERINFO" | grep fullName | awk -F\:\  '{print $2}'`
EMAIL=`echo "$USERINFO" | grep mail | awk -F\:\  '{print tolower($2)}'`
UNIID=`echo "$USERINFO" | grep umanPersonID | grep -v "filter: " | awk -F\:\  '{print tolower($2)}'`

if [ "$UNIID" = "" ]; then
	echo "No match found."
else
	echo "$FULLNAME ($UNIID)"
	echo "$EMAIL"
fi
