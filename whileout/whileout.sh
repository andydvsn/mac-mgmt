#!/bin/bash

# whileout.sh v1.07 (20th May 2014)
#  Run a process only when users are logged out.

# Give the system some time to think.
sleep 30


### CONFIGURE #######################################
PROCESSLOCATION="/usr/local/bin/busything"
PROCESSNAME="busything"
#####################################################


CONSOLEUSER=`who | grep -c console`

echo "Started."

while true ; do

	# Check if we have a console user.
	who | grep -c console | while read c ; do

		# If we don't, start the process.
		if [[ $c -eq 0 ]]; then

			sleep 20

			ps -Af | grep $PROCESSNAME | grep -vc grep | while read s ; do

					if [[ $s -eq 0 ]]; then
						[ -x $PROCESSLOCATION ] && $PROCESSLOCATION &
					else
						break
					fi

			done

		# If we do have a console user, make sure the process is killed.
		else

			ps -Af | grep $PROCESSNAME | grep -vc grep | while read s ; do

				if [[ $s -ne 0 ]]; then
					killall $PROCESSNAME
				else
					break
				fi

			done

		fi

	done

	sleep 5

done

echo "Stopped."

exit 1
