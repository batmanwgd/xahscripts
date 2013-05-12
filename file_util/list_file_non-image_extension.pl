# -*- coding: utf-8 -*-
# perl

# list all files in a dir whose file extension is not one of the image ones. e.g jpg, jpeg, png, etc.

# 2013-05-12

use strict;
use File::Find;

if (not defined $ARGV[0]) {die qq[
Error: argument not received.

Correct syntax:
perl $0 ‹dirFullPath›
]}

my $path = $ARGV[0];

# should give a full path, not relative path.  Else, the $File::Find::dir won't give full path.

sub wanted {
  if (
      -f $File::Find::name &&
      (
       $_ !~ m/\.jpg$/i &&
       $_ !~ m/\.jpeg$/i &&
       $_ !~ m/\.gif$/i &&
       $_ !~ m/\.bmp$/i &&
       $_ !~ m/\.png$/i
      )

     ) {

# 2013-05-12 remove gThumb created junk. ⁖ ~/Pictures/mypics/.comments/133390985673-2.jpg.xml
#    if (
#        $File::Find::name =~ m{/\.comments/.+\.xml$}
#       ) {
##      unlink $File::Find::name;
#    }

    print $File::Find::name, "\n";


  }
}

find(\&wanted, $path);

print "Done.\n";
