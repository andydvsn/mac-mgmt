#!/usr/bin/env bash

## iplayer.sh v1.02 (21st September 2021) by Andrew Davison
##  A cozy layer in front of get_iplayer.

get_iplayer="/opt/homebrew/bin/get_iplayer"

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

elif [[ "$1" == "pids" ]]; then

	if [ $# -ne 2 ]; then

		echo "Usage: $0 [pids] <url>"
		exit 1

	else

		related=$(curl --silent "$2" | grep "tvip-script-app-store")

		IFS=','
		read -a strarr <<< "$related"

		title=""
		subtitle=""
		pids=""

		for val in "${strarr[@]}";
		do

			if [[ "$val" =~ '"title":"' ]]; then

				title=$(echo "$val" | awk -F\title\":\" {'print $2'} | awk -F\" {'print $1'})

			fi

			if [[ "$val" =~ '{"episode":{"id":' ]]; then

				onepid=$(echo "$val" | awk -F\id\":\" {'print $2'} | awk -F\" {'print $1'})
				pids="$pids,$onepid"

			fi

		done

		echo $title
		echo "${pids:1}"

	fi

elif [[ "$1" == "pvr" ]]; then

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