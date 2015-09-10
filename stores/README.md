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

The storefor.sh script uses a .store_template folder to generate the Store. Create this hidden folder in the location of your Stores and place in it anything that you would like the users to receive by default.

storemaintenance
----------------

The **storemaintenance.sh** script is a simple deletion pass. It checks in every Store until it finds any file modified in within a given time window. A single 'recently' modified file will mark that Store as active. If it doesn't find a modified file, the Store is deleted and the amount of recovered space is logged. As with **storefor.sh** this is handled by launchd using the .plist file.

It's pretty mercenary, as it checks for *modified* time, not *accessed* time. But the time before deletion is massive by default.

Resources.app
-------------

The **Resources.app** is a simplified version of **Store.app** which is used to mount a shared resources folder. This should always exist, so it does little in the way of checks.