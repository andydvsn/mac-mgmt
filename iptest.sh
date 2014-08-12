#!/bin/bash


for i in {1..254}
do
	R=`ping -t1 -c1 10.2.95.$i`
	if [[ ! "$R" =~ "100.0% packet loss" ]]; then
		echo "10.2.95.$i is live."
	fi
done

