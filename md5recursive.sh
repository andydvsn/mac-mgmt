#!/usr/bin/env bash

## md5recursive.sh v1.00 (15th May 2022) by Andrew Davison
##  Remove lower resolution duplicates.

find "$1" -type f ! -iname ".*" | while read filepath; do

    md5 "$filepath" > "$filepath".md5

done