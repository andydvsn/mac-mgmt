ddupd
=====

World's simplest dynamic DNS updater.


Installation
------------

Put it somewhere and run it occasionally.


More In-Depth Installation
--------------------------

	sudo cp com.ddupd.update.plist /Library/LaunchDaemons
	sudo ddupd /usr/local/bin
	sudo chown root:admin /Library/LaunchDaemons/com.ddupd.update.plist /usr/local/bin/ddupd
	sudo launchctl load /Library/LaunchDaemons/com.ddupd.update.plist


Use
---

Check the log file in /Library/Logs/ddupd.log now and then to make sure it's running.