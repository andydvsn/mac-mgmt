#!/bin/bash

for IP in $(seq 254); do
	OUTPUT=`ping -i 0.1 -W 0.1 -c 1 "$1"."$IP"`
	[[ $OUTPUT =~ "0 packets received" ]] || echo "$1"."$IP" 
done
