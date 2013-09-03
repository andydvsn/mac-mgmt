#!/usr/bin/perl -w

#powerman.pl v1.03 (11/09/12)
# Installed in /usr/local/bin

# Makes sure basic power management settings are maintained, and
# power down machines when we can get away with it.

use strict;

my $clires;
my $logfile = '/var/log/powerman.log';
my $lockfile = '/tmp/powermanpmsetdone';

# Log housekeeping (erase log if >100KB).
$clires = `touch $logfile`;
my $logsize = -s $logfile;
if ($logsize > 102400) {
	$clires = `echo > $logfile`;
}

# Let us alter the power management settings if we force it.
if ("@ARGV" =~ 'force') {
	$clires = `rm $lockfile 2>/dev/null`;
}

# Figure out where we are.
my $hostname = `hostname`;

# Discover system version.
#  We're expecting to be running Mountain Lion
my $osxver = "8";
#  But you never know.
my $fullosxver = `sw_vers`;
if ($fullosxver =~ "10.8") {
	$osxver = "8"
} elsif ($fullosxver =~ "10.7") {
	$osxver = "7"
}


# Set some basics, unless we've already done so recently.
if (! -e $lockfile) {

	my $pmbasics = `pmset -a ttyskeepawake 1 hibernatemode 0 halfdim 1 womp 1 sleep 0 powerbutton 0 disksleep 30 autorestart 1 displaysleep 9 repeat wakeorpoweron MTWRF 08:45:00`;
	$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: UPDATE: General power management settings have been applied." >> $logfile`;
	
	if ($hostname !~ 'cluster') {
		my $pmleo = `pmset -a displaysleep 20 disksleep 0`;
		$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: UPDATE: Studio-specific power management settings have been updated." >> $logfile`;
	}
	
	if ($hostname =~ 'cluster') {
		my $pmleo = `pmset -a displaysleep 40 disksleep 1`;
		$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: UPDATE: Cluster-specific power management machines have been updated." >> $logfile`;
	}

}


# Now we get active with some potential shutdowns.
my $currenthour = `/bin/date +%H`; chomp $currenthour;
my $idletime;
my $consoleuser;
my $ttysuser;
my $sysload;

# How long have we been idle?
my @idle = `/usr/sbin/ioreg -c IOHIDSystem`;
foreach (@idle) {
	if (/Idle/) {
		my @idlevalue = split /= /, $_;		
		$idletime = int((pop @idlevalue)/1000000000);
		last;
	}
}

# Is anybody using the console?
my @console = `/usr/bin/who`;
foreach (@console) {
	if (/console/) {
		$consoleuser = 1;
	}
	if (/ttys/) {
		$ttysuser = 1;
	}
}

# Are we madly processing away on something?
my @uptime = `uptime`;
foreach (@uptime) {
	my @load = split / /, $_;
	$sysload = int((pop @load));
	last;
}

# Things to do if we're outside our usual hours (0800-2100).
if (($currenthour < 8) || ($currenthour > 20)) {
	
	$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: snore: powerman.pl starting an out-of-hours check..." >> $logfile`;
	
	# If there's no console user, nobody on a terminal session, the system has been idle 20 mins and there's not much activity, shut down.
	if (($idletime > 1200) && ($consoleuser < 1) && ($ttysuser < 1) && ($sysload <= 2)) {
		
		if ($hostname =~ "cluster") {
			$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: SHUTDOWN: Shutting down the system due to lack of activity out-of-hours." >> $logfile`;
			my $shutdown = `/sbin/shutdown -h now`;
		} else {
			$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: If this had been a cluster machine, it would have been shut down due to lack of out-of-hours activity." >> $logfile`;
		}
			
	}
	
	# If there IS a console user, but they've been inactive for an hour and there's barely a hint of processor usage, shut down.
	if (($idletime > 3600) && ($consoleuser == 1) && ($ttysuser < 1) && ($sysload <= 1)) {
		
		if ($hostname =~ "cluster") {
			$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: SHUTDOWN: Forcing an out-of-hours shutdown with an inactive console user present." >> $logfile`;
			my $shutdown = `/sbin/shutdown -h now`;
		} else {
			$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: If this had been a cluster machine, we would have forced an out-of-hours shutdown with an inactive console user present." >> $logfile`;
		}
			
	}
	
} else {
	
	$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: heartbeat: powerman.pl just completed an in-hours check." >> $logfile`;

}

if (! -e $lockfile) {

	$clires = `echo "\`date  +'%Y-%m-%d %H:%M:%S'\`: heartbeat: powerman.pl successfully completed it's first run for this boot." >> $logfile`;
	$clires = `touch $lockfile`;

}





