#!/usr/bin/env bash

## iplayer.sh v1.00 (21st January 2020) by Andrew Davison
##  A cozy layer in front of get_iplayer.

get_iplayer="/usr/local/bin/get_iplayer"

if [[ "$1" == "add" ]]; then
	# Really quick PVR adder.

	if [ $# -ne 3 ]; then

		echo "Usage: $0 [add] <type> <quoted name>"
		exit 1

	else

		type="$2"
		show="$3"
		[[ "$type" != "radio" ]] && type="tv"
		[ ! -d /Users/$USER/.get_iplayer/pvr ] && mkdir -p /Users/$USER/.get_iplayer/pvr
		spacesbegone="$(echo -e "${3}" | tr -d '[[:space:]]')"
		echo -e "type $type\nsearch0 $3" > /Users/$USER/.get_iplayer/pvr/$2-$spacesbegone
		echo "$(date  +'%Y-%m-%d %H:%M:%S') : INFO : Added '$3' to the PVR."
		exit 0

	fi

elif [[ "$1" == "pvr" ]]; then

	if [ -f "/Users/$USER/.get_iplayer/pvr_lock" ]; then

		echo "$(date  +'%Y-%m-%d %H:%M:%S') : WARN : Scan already underway."
		exit 0

	fi

	echo
	echo "$(date  +'%Y-%m-%d %H:%M:%S') : INFO : Scan starting!"
	echo
	$get_iplayer --pvr
	echo
	echo "$(date  +'%Y-%m-%d %H:%M:%S') : INFO : Scan complete."
	echo

else

	# Otherwise pass everything through to the real thing.
	$get_iplayer "$@"
	echo

fi

exit 0