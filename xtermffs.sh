#!/bin/bash

if [ -z $1 ]; then
	echo "Usage: $0 <hostname>"
	exit 1
fi
echo "Copying xterm-256color to $1..."
echo "You may well be asked for the password to $1 now."
scp /usr/share/terminfo/78/xterm-256color root@$1:/usr/share/terminfo/78
