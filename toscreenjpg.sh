#!/usr/bin/env bash

## toscreenjpg.sh v1.00 (20th January 2022)
##  Converts image files to reasonable quality 1920x1080 JPEGs.

location="$1"

if [ ! -d "$location" ]; then

    echo "Point me to a directory."
    exit 1

fi

for filepath in $location/*; do

    printf "Resize $filepath\n"
    convert "$filepath" -resize 1920x1080 -quality 70 -density 72 "$filepath"

done