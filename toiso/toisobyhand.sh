#!/bin/bash

# toisobyhand.sh v1.00 (15th April 2014)
#  Converts every directory in a location to .iso files.

if [ $# -lt 1 ]; then
	echo "Usage $0: <source> [destination]"
	exit 0
fi

if [[ "$1" == "-h" ]]; then
	echo "Usage $0: <source> [destination]"
	echo
	echo "Specify a source directory which will contain directories to be converted."
	echo
	exit 0
fi

if [[ "$1" == "-r" ]]; then

	SOURCE=`echo ${2%/}`

	find "$SOURCE" -type d -depth 1 | while read d ; do

		DEST=`echo ${3%/}`
		DISCPATH="$d"
		DISCTITLE=`echo "$DISCPATH" | awk -F/ '{print $NF}'`

		if [[ "$DEST" != "" ]]; then
			TODEST=" into $DEST"
		else
			DEST="$SOURCE"
			TODEST=""
		fi

	done

else

	DEST=`echo ${2%/}`
	DISCPATH="$1"
	SOURCE=`echo ${1%/}`
	DISCTITLE=`echo "$SOURCE" | awk -F/ '{print $NF}'`

	if [[ "$DEST" != "" ]]; then
		TODEST=" into $DEST"
	else
		DEST="$SOURCE"
		TODEST=""
	fi

fi

echo "Bundling '$DISCTITLE'$TODEST..."
/usr/bin/hdiutil makehybrid -udf -udf-volume-name "$DISCTITLE" -o "$DEST/$DISCTITLE.iso" "$DISCPATH/"

echo "Complete."
exit 0