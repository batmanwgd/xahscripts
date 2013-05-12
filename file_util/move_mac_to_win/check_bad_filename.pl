# -*- coding: utf-8 -*-
# perl
# File name: check_bad_filename.pl
# Purpose: Report file names that contains chars not allowed in NTFS (Windows), and,
# also report file names with non-ascii chars.
# this script is designed for transferring files from Mac/Unix to Windows
# For detail, see: http://xahlee.info/perl-python/mac_resource_fork.html

# 2009-09-04
# http://xahlee.info/perl-python/mac_resource_fork.html

# USAGE:
# To run the script, do
#  perl check_bad_filename.pl /Users/xah/Documents/
# If your path has spaces, you need to quote the path. e.g.
#  perl check_bad_filename.pl "/Users/xah/Documents/my files"

use utf8;
use File::Find;

if (not defined $ARGV[0]) {
  die "Error: argument not received. $0 <dir absolute path>.";
}

my $path = $ARGV[0]; # should give a full path, not relative path. Else, the $File::Find::dir won't give full path.

sub wanted {
  if (  $_ =~ m{[/\\:*?"<>|]} ) {
    # chars not allowed in NTFS / \ : * ? " < > |
    # ref http://en.wikipedia.org/wiki/NTFS
    print "Chars not allowed in NTSF: ";
    print $File::Find::name, "\n";
  }
  if ( $_ =~ m@ $@ ) {
    # if file ends in a space, Windows Vista Explorer will complain “Could not find this item” when copying to Windows.
    print "File name cannot end in space “ ”: ";
    print $File::Find::name, "\n";
  }
  if ( $_ =~ m@.\.$@ ) {
    # if a mac file name ends in a period, then it will displayed in Windows Vista as encoded gibberish, probably because Windows expect a file name extension.
    print "If ending in a period, name will become gibberish: ";
    print $File::Find::name, "\n";
  }
  if ( $_ =~ m@[^[:ascii:]]@ ) {
    # non-ascii chars.
    # 2009-09-04 rsync in cygwin will have problem transferring Chinese chars, Single curly quotes ‘’, double curly quotes “”, and probably many others
    # non-ascii chars also will not display correctly in Windows version of emacs's dired.
    print "Non-ascii: ";
    print $File::Find::name, "\n";
  }
}

find(\&wanted, $path);

print "Done.\n";

__END__

