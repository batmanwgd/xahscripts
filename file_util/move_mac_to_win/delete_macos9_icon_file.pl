# -*- coding: utf-8 -*-
# perl
# File name: delete_macos9_icon_file.pl
# Purpose: delete Mac's OS 9 "Icon^M" files.
# For detail, see: http://xahlee.info/perl-python/mac_resource_fork.html

# 2009-05-31, 2009-09-04
# http://xahlee.info/perl-python/mac_resource_fork.html

# USAGE:
# to list those icon files, do
#  perl delete_macos9_icon_file.pl /Users/xah/Documents/
# to actually delete them
#  perl delete_macos9_icon_file.pl /Users/xah/Documents/ d
# if your path contain space or other chars, you need to quote the path.
# like this
#  perl delete_macos9_icon_file.pl "/Users/xah/Documents/some dir" d

use strict;
use File::Find;

if (not defined $ARGV[0]) {die "Error: argument not received.\n$0 <dir absolute path> d. If the second argument is missing, then only reported will be done, no deletition will take place."};

my $path = $ARGV[0]; # should give a full path, not relative path. Else, the $File::Find::dir won't give full path.

my $sizesum=0;
my $filenum=0;

sub wanted {
	if (
			! -d $File::Find::name &&
			-f $File::Find::name &&
			$_ =~ m/^\Icon$/
		 ) {


		if (-s "$File::Find::name/rsrc" > 0) {
			$sizesum += -s "$File::Find::name/rsrc";
			$filenum++;

			if ($ARGV[1] eq 'd') {
				open (FF, ">$File::Find::name/rsrc") or die "cannot open $!"; print ""; close FF;
			}
		}
		if ($ARGV[1] eq 'd') {unlink $File::Find::name}
		print $File::Find::name, "\n";
	}
}


find(\&wanted, $path);
print "file touched: $filenum.\n";
print "size freed: $sizesum bytes.\n";
print "Done.\n";
