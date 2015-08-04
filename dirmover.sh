#!/bin/bash

## dirmover v1.00 (4th August 2015) by Andy Davison
##  Prepends a directory's name to it's children and moves them up to
##  the top directory that you pointed the script at, with very few checks
##  as to whether what it's doing is sane or not.

if [ ! -d "$1" ]; then
	echo "Give me a directory to look at!"
	exit 1
fi

for DIRPATH in `find $1 -type d`; do

	if [ "$DIRPATH" != "$1" ]; then

		DIRNAME=`echo $DIRPATH | awk -F "/" '{print $NF}'`
		
		echo "Directory is: $DIRNAME"

		for FILEPATH in $DIRPATH/*; do

			FILENAME=`echo $FILEPATH | awk -F "/" '{print $NF}'`

			mv $FILEPATH $DIRPATH/$DIRNAME-$FILENAME
			mv $DIRPATH/$DIRNAME-$FILENAME $1/

		done

	fi

done
