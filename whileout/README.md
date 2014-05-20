whileout
========

This script keeps a process running on a system until someone logs in. As soon as a console user appears, the process is killed for that user to work. When the user logs out, the process is relaunched.

Setup
-----

* Copy **whileout.sh** to **/usr/local/bin**
* Copy **com.studios.whileout.plist** to **/Library/LaunchDaemons**
* Set permissions:

		chown admin:admin /usr/local/bin/whileout.sh
		chmod 770 /usr/local/bin/whileout.sh
		chown root:wheel /Library/LaunchDaemons/com.studios.whileout.plist
		chmod 644  /Library/LaunchDaemons/com.studios.whileout.plist

* Edit **whileout.sh** to include your process name and executable location.
* Launch with **launchctl** or just reboot!