# drobologinwait.sh

Delays the OS X login window from appearing while we wait for the array to attach.

## Introduction

If you want to use an external array to host your user areas invisibly to end users, you're going to need to stop them from logging in before the array is attached. If you don't, they'll wonder where their files have gone and will experience some weirdness when the array does become available and the OS tries to pull the rug out from under their feet.

This assumes that you're using `/etc/fstab` to remap the `/Users` area to the array. I'd recommend that you use the UUID of the LUN in a line similar to this:

	UUID=905BB2FD-B42C-3DA7-B64E-74136DC1B26E    /Users    hfs    rw,auto,nobrowse
	
You get your UUID using `diskutil info /dev/diskXsY` where *diskXsY* relates to your LUN volume.

## Installation

By default this script expects to be in `/Library/Scripts/Recording` but you can put it anywhere so long as you modify `com.recording.drobologinwait.plist` to point to the right place.

Installation is just putting both files in the right place, setting permissions and loading with `launchctl`:

	sudo cp com.recording.drobologinwait.plist /Library/LaunchDaemons
	sudo cp drobologinwait.sh /Library/Scripts/Recording/
	sudo chown root:admin /Library/LaunchDaemons/com.recording.drobologinwait.plist /Library/Scripts/Recording/drobologinwait.sh
	sudo chmod 755 /Library/Scripts/Recording/drobologinwait.sh
	sudo launchctl load /Library/LaunchDaemons/com.recording.drobologinwait.plist
	
	
## Use

First off, set up your Drobo volume correctly. Install the [Legacy Java 6 Runtime](https://support.apple.com/kb/DL1572?locale=en_US), install your iSCSI initiator, install Drobo Dashboard. Configure the LUN and get it mounting correctly, add CHAP authentication if required. Make sure that 'ignore user permissions' is switched **off** for the volume.

Then copy the contents of `/Users` to the root of the volume you're going to use (including `/Users/Shared`, it's important) and make sure that all of the file permissions were copied correctly.

Then create the 'ready' file on the root of the Drobo:

	sudo touch /Volumes/YOURDROBO/.droboready
	sudo chown root:wheel /Volumes/YOURDROBO/.droboready
	sudo chmod 644 /Volumes/YOURDROBO/.droboready
	
This is what is looked for by the script to determine that your array is up and mounted in the right place.

### In Operation

When the system boots, it fires up our script as part of the launchd processes before *loginwindow* appears. The script temporarily unloads *loginwindow,* which prevents GUI login to the system. Underneath, everything else continues as normal; SSH and other processes (such as the iSCSI initiator) get on with their work.

If you create a `/Users/.drobosetup` file in the local `/Users` directory, the script will abort and load the loginwindow straight away. You can authenticate and access files in your local `/Users` directory as if nothing had ever changed.

If not, we wait until the array is mounted by watching for that `.droboready` file you created on the root of the array. Our `/etc/fstab` does the hard work of automatically attaching to the correct location, hiding the local `/Users` area. Our script then loads `loginwindow`. The end user is none the wiser that anything they now save is pushed directly to the storage array.

#### Bonus Tip

I'd recommend removing the Drobo Dashboard application from `/Applications`. Though end users wouldn't be able to modify the settings of a protected array, they would be given the option to unmount the array, which is something that might spoil their day. Keep a copy of the application on a USB stick or hidden in the local `/Users` area instead.





































