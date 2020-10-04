#!/usr/bin/env bash

## iplayertoplex.sh v1.01 (24th January 2020) by Andrew Davison
##  Take downloaded content from get_iplayer and fumble it into Plex.

debug=0

###
atomicparsley="/usr/local/bin/AtomicParsley"
bbcurl="https://www.bbc.co.uk/programmes"
jq="/usr/local/bin/jq"
mediainfo="/usr/local/bin/mediainfo"
###

pathtothisscript="$(cd "$(dirname "$0")";pwd -P)"

pid="${1}"
filename="${2}"
type="${3}"
nameshort="${4}"
episodeshort="${5}"
firstbcastdate="${6}"
seriesnum="${7}"
episodenum="${8}"
destpath="${9}"
films="${10}"
podcasts="${11}"
tv="${12}"

[[ "$episodeshort" == "" ]] && [[ "$nameshort" != "" ]] && type="film"
[[ "${#seriesnum}" -eq 1 ]] && seriesnum="0$seriesnum"
[[ "${#episodenum}" -eq 1 ]] && episodenum="0$episodenum"

safenameshort=$(echo $nameshort | sed -e 's/://g')
safeepisodeshort=$(echo $episodeshort | sed -e 's/://g')
fileext="${filename##*.}"
metadata=$($mediainfo "$filename")

echo
echo "$bbcurl/$pid"
echo
echo "pid                : $pid"
echo "filename           : $filename"
echo "type               : $type"
echo "nameshort          : $nameshort"
echo "safenameshort      : $safenameshort"		
echo "episodeshort       : $episodeshort"
echo "safeepisodeshort   : $safeepisodeshort"
echo "firstbcastdate     : $firstbcastdate"
echo "seriesnum          : $seriesnum"
echo "episodenum         : $episodenum"
echo "destpath           : $destpath"
echo "films              : $films"
echo "podcasts           : $podcasts"
echo "tv                 : $tv"
echo "fileext            : $fileext"

if [[ "$type" == "film" ]] || [[ "$type" == "tv" ]]; then

	resolution=$(echo "$metadata" | grep Height | awk -F\:\  {'print $2'} | cut -d\  -f1)

fi

if [[ "$type" == "film" ]]; then

	# Only the programme page seems to hold the real film release date.
	datepublished=$(curl -s "$bbcurl/$pid" | grep datePublished | $jq '.datePublished' | cut -d\" -f2)

	if [[ "$datepublished" != "" ]]; then

		echo "datepublished      : $datepublished"
		year="${datepublished:0:4}"

	elif [[ -f "$pathtothisscript/omdbapikey.txt" ]] ; then

		# Get the release date of the film from OMDb if we can.
		omdbapikey=$(cat "$pathtothisscript/omdbapikey.txt")

		# The Beeb doesn't always stick to the correct title for films and occasionally adds a prefix.
		if [[ "$nameshort" =~ ":" ]]; then
			omdbnameshort=$(echo "$nameshort" | awk -F\:\  {'print $2'})
		else
			omdbnameshort="$nameshort"
		fi
		omdbnameshort=$(echo $omdbnameshort | sed -e 's/ /+/g')
		echo "omdbnameshort      : $omdbnameshort"

		omdburl="https://www.omdbapi.com/?t=$omdbnameshort&apikey=$omdbapikey"
		omdbyear=$(curl -s $omdburl | $jq '.Year' | cut -d\" -f2)
		omdbyear="${omdbyear:0:4}"
		echo "omdbyear           : $omdbyear"

		if [[ "$omdbyear" == "null" ]] || [[ "$omdbyear" == "" ]]; then
			# We're out of options. Use the date we're given.
			year=$(echo $firstbcastdate | cut -d- -f1)
		else
			year="$omdbyear"
		fi

	fi

	# Finally! The year we will actually use.
	echo "year               : $year"

	destination_dir="$destpath/$films/$safenameshort ($year)"
	destination_filename="$safenameshort ($year).$fileext"
	destination_path="$destination_dir/$destination_filename"

	# Strip all metadata from films; better for Plex to look up the real info.
	$atomicparsley "$filename" --metaEnema --overWrite > /dev/null

fi

if [[ "$type" == "radio" ]]; then

	# One for tomorrow.
	echo "Oh, hell. Radio."
	exit 1

fi

if [[ "$type" == "tv" ]]; then

	# Build the path and sXXeXX identifier into the file name. Leave all metadata intact, as it's likely better than what's available elsewhere.
	[[ "$seriesnum" == "" ]] && destination_dir="$destpath/$tv/$safenameshort/Specials" || destination_dir="$destpath/$tv/$safenameshort/Season $seriesnum"
	[[ "$resolution" == "" ]] && optionalinformation="$safeepisodeshort" || optionalinformation="$safeepisodeshort ($resolution""p)"
	[[ "$episodenum" == "" ]] && destination_filename="$safenameshort - $firstbcastdate - $optionalinformation.$fileext" || destination_filename="$safenameshort - s$seriesnum""e$episodenum - $optionalinformation.$fileext"
	destination_path="$destination_dir/$destination_filename"

fi

echo
echo "==="
echo "Destination Path : $destination_path"
echo "==="
echo

if [[ "$debug" != "1" ]] && [[ "$filename" != "" ]] && [[ "$destination_dir" != "" ]] && [[ "$destination_filename" != "" ]] && [[ "$destination_path" != "" ]]; then

	echo -n "Moving '$destination_filename'..."
	mkdir -p "$destination_dir"
	mv "$filename" "$destination_path" 2>/dev/null
	echo " done."

else

	echo "Not moving anything. You may want to check whether '$filename' exists."

fi

exit 0
