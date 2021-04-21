#!/usr/bin/env bash

## homebridge-node-update.sh v1.00 (21st April 2021)
##  Upgrades node through homebrew in a reasonably safe way for Homebridge to be happy.

instances=("homebridge" "homebridge-vq")

for i in "${instances[@]}"; do
	echo "Stopping Homebridge instance '$i'..."
	sudo /usr/local/bin/hb-service -S "$i" stop
done

brew update
brew upgrade node@14

sudo /usr/local/bin/hb-service rebuild --all

port=8581
for i in "${instances[@]}"; do
	echo "Reinstalling and starting Homebridge instance '$i'..."
	sudo /usr/local/bin/hb-service install -S "$i" --port "$port"
	port=$((port+1))
done
