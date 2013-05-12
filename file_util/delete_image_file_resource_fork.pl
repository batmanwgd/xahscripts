# -*- coding: utf-8 -*-
# perl
# File name: delete_image_file_resource_fork.pl
# Purpose: Report or delete image files's resource fork of a given dir.
# For detail, see: http://xahlee.info/perl-python/mac_resource_fork.html

# 2009-05-31, 2009-09-04
# http://xahlee.info/perl-python/mac_resource_fork.html

# USAGE:
# To list files that have resource fork, do
#  perl delete_image_file_resource_fork.pl /Users/xah/Documents/
# To actually delete the resource forks, do
#  perl delete_image_file_resource_fork.pl /Users/xah/Documents/ d
# if your path contain space or other chars, you need to quote the path.
# like this
#  perl delete_image_file_resource_fork.pl "/Users/xah/Documents/" d

# you can modify the script so that it only checks certain file suffix.
# To do that, go to the body of “wanted” function.

use strict;
use File::Find;

if (not defined $ARGV[0]) {die "Error: argument not received. $0 <dir absolute path> 'd'. If the second argument 'd' is missing, then no deletion will take place, only do report."}

my $path = $ARGV[0];
# should give a full path, not relative path.  Else, the $File::Find::dir won't give full path.

my $sizesum=0;
my $filenum=0;

sub wanted {
  if (
      ! -d $File::Find::name &&
      -f $File::Find::name &&

      $_ =~ m/\.jpg$/i ||
      $_ =~ m/\.jpeg$/i ||
      $_ =~ m/\.gif$/i ||
      $_ =~ m/\.bmp$/i ||
      $_ =~ m/\.png$/i

     ) {

    if (-s "$File::Find::name/rsrc" > 0) {
      print $File::Find::name, "\n";

      $sizesum += -s "$File::Find::name/rsrc";
      $filenum++;

    if ($ARGV[1] eq 'd') {
        open (FF, ">$File::Find::name/rsrc") or
        die "cannot open $!"; close FF;}
    }
  }
}

find(\&wanted, $path);
print "number of file: $filenum.\n";
print "total size in bytes: $sizesum.\n";
print "Done.\n";
