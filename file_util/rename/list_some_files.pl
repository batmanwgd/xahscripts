# -*- coding: utf-8 -*-
# perl

# list files that doesn't end in

# .jpg
# .jpeg
# .png
# .gif

# 2013-05-12

use strict;
use File::Find;
use File::Basename;
use Data::Dumper;

my $folderPath = q{~/Pictures/cinse_pixra3/4chan};

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

