#!/bin/bash

# disctoiso.sh v1.02 (28th March 2014) by Andy Davison
#  Converts directories containing VIDEO_TS or BDMV content into .iso files.

DEBUG=1
LOCK="/Users/$USER/.toisoisgo"
SCRAP="/Users/$USER/.toiso"

if [ $# -lt 1 ]; then
	echo "Usage $0: <source> [destination]"
	exit 0
fi

if [[ "$1" == "-h" ]]; then
	echo "Usage $0: <source> [destination]"
	echo
	echo "Specify a source directory which will contain the output from your ripper."
	echo "If no destination is specified, the .iso file will be generated in place."
	echo "We look for directories containing VIDEO_TS or BDMV content to determine"
	echo "what to 'convert'. The process can take some time."
	echo
	echo "If .iso files exist and a destination is specified, they will be moved to"
	echo "that location. Similarly, generated .iso files will be moved immediately."
	echo
	echo "If the directory or any files contained within have been updated in the"
	echo "two minutes prior to running the script, it will be deemed to be an"
	echo "'active rip' and will not be touched."
	echo
	exit 0
fi

if [ -e /tmp/disctoisoisgo ]; then
	#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : STOP : Another instance is underway."
	echo "STOP : Another instance is underway."
	exit 0
fi

mkdir $SCRAP
touch $LOCK

DISCSRC="$1"
DISCDES="$2"
[[ "$DISCDES" == "" ]] && DISCDES="$DISCSRC"

if [ $DEBUG -eq 1 ]; then
	echo "DISCSRC = $DISCSRC"
	echo "DISCDES = $DISCDES"
fi


# This moves any .iso files that may be waiting.
moveitmoveit() {

	# Check the scrap directory for .iso files.
	find "$SCRAP" -name "*.iso" | while read f ; do

		#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Moving generated ISO files to '$DISCDES'."
		echo "INFO : Moving generated ISO files to '$DISCDES'."
		mv "$f" "$DISCDES"
		#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Move complete."
		echo "INFO : Move complete."

	done

	# Check for pre-prepared .iso files.
	find "$DISCSRC" -name "*.iso" | while read f ; do

		ISOPATH="$f"
		ISONAME=`echo "$ISOPATH" | awk -F/ '{print $NF}'`

		if [[ "$ISOPATH" != "$DISCDES/$ISONAME" ]]; then

			#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Found '$ISOPATH' and moving it to '$DISCDES'."
			echo "INFO : Found '$ISOPATH' and moving it to '$DISCDES'."
			mv "$ISOPATH" "$DISCDES"
			#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Move complete."
			echo "INFO : Move complete."

		fi

	done

}


# Check for directories containing BDMV or VIDEO_TS folders and convert them to .iso files of the same title in $SCRAP.
find "$DISCSRC" -type d -depth 2 \( -name BDMV -o -name VIDEO_TS \) | while read d ; do

	if [[ ! "$d" =~ ".ripit" ]] && [[ ! "$d" =~ ".dvdmedia" ]]; then
		
		DISCDATA="$d"

		echo $DISCDATA

		[[ "$d" =~ "BDMV" ]] && DISCPATH=`echo "$DISCDATA" | awk -F/BDMV {'print $1'}`
		[[ "$d" =~ "VIDEO_TS" ]] && DISCPATH=`echo "$DISCDATA" | awk -F/VIDEO_TS {'print $1'}`

		DISCTITLE=`echo "$DISCPATH" | awk -F/ '{print $NF}'`
		DISCISOPATH="$DISCPATH".iso
		DISCISO="$DISCTITLE".iso
		STILLRIPPING=`find "$DISCPATH" -type f -mmin -2`

		if [[ "$STILLRIPPING" != "" ]]; then

			#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : WARN : Title '$DISCTITLE' is still ripping. Leaving it for now."
			echo "WARN : Title '$DISCTITLE' is still ripping. Leaving it for now."
			continue

		else
	
			if [[ "$DISCPATH" == "$DISCTITLE" ]]; then

				[[ "$DISCDES" == "$DISCSRC" ]] && DISCDES=`pwd`
				DISCSRC="$DISCDES"
				DISCPATH="$DISCSRC/$DISCTITLE"

			fi

			if [ $DEBUG -eq 1 ]; then
				echo "DISCDATA = $DISCDATA"
				echo "DISCPATH = $DISCPATH"
				echo "DISCTITLE = $DISCTITLE"
				echo "DISCISOPATH = $DISCISOPATH"
				echo "DISCISO = $DISCISO"
			fi

			if [ -f "$DISCISOPATH" ]; then

				#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : WARN : ISO $DISCISOPATH already exists. Skipping."
				echo "WARN : ISO $DISCISOPATH already exists. Skipping."

			else

				#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Beginning work on '$DISCTITLE'."
				echo "INFO : Beginning work on '$DISCTITLE'."
				/usr/bin/hdiutil makehybrid -udf -udf-volume-name "$DISCTITLE" -o "$SCRAP/$DISCISO" "$DISCPATH" &>/dev/null
				moveitmoveit
				rm -rf "$DISCPATH"
				#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Completed generation of '$DISCTITLE.iso'."
				echo "INFO : Completed generation of '$DISCTITLE.iso'."				
				sleep 2

			fi

		fi

	else

		moveitmoveit

	fi
	
done

#echo "`date  +'%Y-%m-%d %H:%M:%S'`: [$$] : INFO : Check complete."
echo "INFO : Check complete."

rm -rf $SCRAP
rm -rf $LOCK
