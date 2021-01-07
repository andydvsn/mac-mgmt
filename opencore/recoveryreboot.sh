#!/usr/bin/env bash

## recoveryreboot.sh v1.00 (7th January 2021)
##  Reboots to recovery without having to do so much typing.

if [ "$USER" != "root" ] && [ "$USER" != "" ]; then
	echo "You need to run this with superuser privileges. Try 'sudo $0'."
	exit 1
fi

nvram "recovery-boot-mode=unused"
reboot recovery
