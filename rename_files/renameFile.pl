#!/usr/local/bin/perl5

# a temp quick script to replace strings in file or folder names. Used for facilitating of creating my classical keyboard music web page. Xah 1998-07.

# warning: file will be renamed. check script before run.

#--

use strict;
use File::Find;
use File::Basename;
use Data::Dumper;

#--

my $folderPath = q{/Users/o/web/bb/i/x};

#--

# @fileArray contains a array of full paths (including subfolders) in the given $folderPath.
my @fileArray;
find(sub{push(@fileArray,$File::Find::name)},$folderPath);
shift @fileArray; # rid of current dir
# print Dumper (\@fileArray);

foreach my $fileFullName (@fileArray) {
    my ($name,$folderPath,$suffix) = fileparse($fileFullName,());
    next unless {$name =~ /jpg$/i} ;
    next unless -f $fileFullName ;
    my $newName= $name;
    $newName =~ s(cap)(swordsman_);

#    print "$newName\n";
    rename(qq($folderPath$name),qq($folderPath$newName));

};

print "done\n";

__END__

