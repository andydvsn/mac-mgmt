#!/usr/bin/perl -w

## eraseoldusers.pl v1.04 (28th August 2015) by Andy Davison.
##  Erases user directories that exceed the inactive timeout.

use strict;
use POSIX qw(strftime);

## Number of days before we can consider something stale.
my $killafter = 353;
my $verbose = 1;

my $date = strftime "%a %b %e %H:%M:%S %Y", localtime;
my $clires;
my $logfile = '/var/log/eraseoldusers.log';

# Log housekeeping (erase log if >100KB). Logging is by launchd on stdout.
$clires = `touch $logfile`;
my $logsize = -s $logfile;
if ($logsize > 102400) {
	$clires = `echo > $logfile`;
}

print "\nStarted: $date\n";
print "\nBeginning removal of user accounts that have been inactive for $killafter days or more.\n\n";

my $dfpre = qx{df -g /Users/};
my @preaudiodrive = (split ' ', $dfpre);

my @userlist = qx{ls -1 /Users/};

@userlist = grep(!/.localized/, @userlist);
@userlist = grep(!/.DS_Store/, @userlist);
@userlist = grep(!/admin/, @userlist);
@userlist = grep(!/Shared/, @userlist);

foreach my $oneuser (@userlist) {
	
	my ($homeage,$desktopage,$docsage) = (0,0,0);
		
	chomp($oneuser);
	
	print "Account $oneuser: " if ($verbose > 0);
	
	# When was the home directory itself last modified?
	$homeage = -M "/Users/$oneuser";
	$homeage = int($homeage);
	print "Home is $homeage days stale" if ($verbose > 0);

	# When was the desktop directory last modified?
	if (-e "/Users/$oneuser/Desktop") {
		$desktopage = -M "/Users/$oneuser/Desktop";
		$desktopage = int($desktopage);
		print ", Desktop is $desktopage days stale" if ($verbose > 0);	
	}
	
	# When was the documents directory last modified?
	if (-e "/Users/$oneuser/Documents") {
		$docsage = -M "/Users/$oneuser/Documents";
		$docsage = int($desktopage);
		print ", Documents are $docsage days stale" if ($verbose > 0);
	}
	
	print ".\n" if ($verbose > 0);
	
	if ($homeage > $killafter && $desktopage > $killafter && $docsage > $killafter) {
		
		print "I consider the account $oneuser to be inactive. It is being erased...";
		qx{rm -rf /Users/$oneuser 2>/dev/null};
		print " done.\n\n";
		
	}
		
}

my $dfpost = qx{df -g /Users/};
my @postaudiodrive = (split ' ', $dfpost);

my $freed = $preaudiodrive[12] - $postaudiodrive[12];

print "\n";
print "  Before:  $preaudiodrive[13]GB available ($preaudiodrive[12]GB used).\n";
print "   After:  $postaudiodrive[13]GB available ($postaudiodrive[12]GB used).\n\n";

if ($freed > 0) {
	print "We've freed up ".$freed."GB!\n\n";
} else {
	print "Not managed to reclaim any space this time.\n\n"
}
