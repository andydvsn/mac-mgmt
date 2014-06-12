Stores
======

In our Studios, we provide a Store area for users to move and backup their work.

Store.app
---------

When users first log on, their Store area doesn't exist and will need to be created with the correct permissions. Store.app deals with mounting the share (causing OS X to prompt for a password where required), checking for the directory and requesting a new Store be created by the server.

storefor
--------

The storefor scripts are the server backend. The **storefor.php** script receives the request and creates a temporary marker file that the **storefor.sh** script looks for, then creates an appropriate directory in the correct place. It's **com.studios.storefor.plist** should be located in:

	/Library/LaunchDaemons
	
As it needs to run regardless of a console user being present. It redirects stdout to a log file, so the script just needs to echo out. The script should probably clear the logfile occasionally, but it doesn't right now.


Resources.app
-------------

The **Resources.app** is a simplified version of **Store.app** which is used to mount a shared resources folder. This should always exist, so it does little in the way of checks.