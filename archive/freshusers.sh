#!/bin/bash

# blankusers.sh v1.04 (8th October 2012) by Andy Davison
#  Swaps out Users dir on root and replaces the Users folder on Workspace with a fresh one.

if [ ! -e /Volumes/Workspace ]; then
	echo "There's no Workspace volume! Halting."
	exit 0
fi

if [ "$USER" != "root" ]; then
	echo "You need root privs to do this!"
	exit 0
fi

if [[ `sw_vers` =~ "10.8" ]]; then
        PLATFORM="mountainlion"
elif [[ `sw_vers` =~ "10.7" ]]; then
        PLATFORM="lion"
else
	echo "Doesn't work on your platform."
	exit 0
fi

cd /var/root

curl -o /var/root/users.$PLATFORM.fresh.tgz xserve.studios/system/users/users.$PLATFORM.fresh.tgz
SUMR=`curl xserve.studios/system/users/users.$PLATFORM.fresh.tgz.md5`
SUML=`md5 users.$PLATFORM.fresh.tgz`

if [ "$SUMR" = "$SUML" ]; then
	
	echo "Checksums match. Extracting fresh user area..."
	tar zxvf /var/root/users.$PLATFORM.fresh.tgz -C /Volumes/Workspace/
	
	echo "Swapping user areas..."
	if [ -e /Volumes/Workspace/Users ]; then
		mv /Volumes/Workspace/Users /Volumes/Workspace/users.previous
	fi
	mv /Volumes/Workspace/users.$PLATFORM.fresh /Volumes/Workspace/Users
	chown -R admin:staff /Users/admin
	
	echo "Moving network users from old area to new..."
	find /Volumes/Workspace/users.previous -maxdepth 1 -mindepth 1 -name m* -exec mv '{}' /Volumes/Workspace/Users \;
	
	echo "Checking the link is correct..."
	if [ ! -L /Users ]; then
		if [ -d /Users ]; then
			mv /Users /users.original
		else
			rm -rf /Users
		fi
		ln -s /Volumes/Workspace/Users /Users
	fi
	
	echo "Please check the following locations for orphans:"
	
	[ -e /users.original ] && echo "/users.original"
	[ -e /Volumes/Workspace/users.previous ] && echo "/Volumes/Workspace/users.previous"
	
	echo
	echo "All done."
	
	exit 0
		
else
	
	echo "Checksum mismatch. Halting here."
	exit 1

fi
