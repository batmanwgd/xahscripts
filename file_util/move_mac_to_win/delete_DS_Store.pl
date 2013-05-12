# -*- coding: utf-8 -*-
# perl
# File name: delete_DS_Store.pl

# Purpose: delete those .DS_Store or Thumbs.db etc temp files.
# For detail, see: http://xahlee.info/perl-python/mac_resource_fork.html

# 2009-05-31, 2009-09-04
# http://xahlee.info/perl-python/mac_resource_fork.html

# USAGE:
# To list files that will be deleted, do:
#  perl delete_DS_Store.pl /Users/xah/Documents/
# To actually delete them, do:
#  perl delete_DS_Store.pl /Users/xah/Documents/ d
# If your path has spaces, you need to quote the path. e.g.
#  perl delete_DS_Store.pl "/Users/xah/Documents/my files"

use File::Find;

if (not defined $ARGV[0]) {die "Error: argument not received. $0 <dir absolute path> d. If the second argument 'd' is missing, then no deletion will take place, only do report.";}
my $path = $ARGV[0]; # should give a full path, not relative path. Else, the $File::Find::dir won't give full path.

$sizesum=0;
$filenum=0;

sub wanted {
	if (
      -f $File::Find::name &&
      ($_ eq '.DS_Store' ||
       $_ eq 'Thumbs.db' ||
       $_ eq '.FBCIndex' ||
       $_ eq '.FBCSemaphoreFile' ||
       $_ eq '.localized')
      ) {
		print $File::Find::name, "\n";
		$sizesum += -s "$File::Find::name"; $filenum++;

		unlink $File::Find::name if ($ARGV[1] eq 'd');
	}
}

find(\&wanted, $path);

print "total files deleted: $filenum\n";
print "size saved: $sizesum bytes\n";
print "Done.\n";

__END__

Here is a collection of files that are created by OS

.DS_Store
.localized
.FBCIndex
.FBCLockFolder
.FBCSemaphoreFile

Desktop DB
Desktop DF

Thumbs.db
