#!/bin/bash

# toisobyhand.sh v1.01 (20th February 2016)
#  Converts directories to .iso files.

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

		echo "Bundling '$DISCTITLE'$TODEST..."
		/usr/bin/hdiutil makehybrid -udf -udf-volume-name "$DISCTITLE" -o "$DEST/$DISCTITLE.iso" "$DISCPATH/"

	done
else

	DEST=`echo ${2%/}`
	DISCPATH="$1"
	DISCPATHONEUP=`echo ${DISCPATH%/*}`
	SOURCE=`echo ${1%/}`
	DISCTITLE=`echo "$SOURCE" | awk -F/ '{print $NF}'`

	if [[ "$DEST" != "" ]]; then
		TODEST=" into $DEST"
	else
		DEST="$DISCPATHONEUP"
		if [[ "$DEST" =~ "$DISCTITLE" ]]; then
			echo "Remove that trailing forward slash from the path and we're good to go."
			exit 0
		fi
		TODEST=""
	fi

	echo "Bundling '$DISCTITLE'$TODEST..."
	/usr/bin/hdiutil makehybrid -udf -udf-volume-name "$DISCTITLE" -o "$DEST/$DISCTITLE.iso" "$DISCPATH/"

fi

echo "Complete."
exit 0