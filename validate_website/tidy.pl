#!/usr/bin/perl

# this is a perl wrapper that calls the tidy HTML checker program.

use strict;
use File::Find;

my $path = '/Users/xah/Documents/public_html/SpecialPlaneCurves_dir';

find(\&wanted, $path);


sub wanted {
	if (-d $File::Find::name) {return 0};
	if ($File::Find::name !~ m@\.html$@) {return 0};

	system (qq{tidy --quiet 1 '$File::Find::name' > /dev/null});
	my $exit = $?>>8;

	if ($exit == 1) {
		print "WARNING: $File::Find::name\n";
	} elsif ($exit == 2)
		{
			print "ERROR: $File::Find::name\n";
		} elsif ($exit == 0) {
			print "OK: $File::Find::name\n";
		} else {print "FUCKED;"}
}

__END__


tidy --quiet 1 bad.html > /dev/null

the tidy program will always prints the input to the stdout,
and all other messages such as welcome and error and warning to the stderr.
