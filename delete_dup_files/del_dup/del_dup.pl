# -*- coding: utf-8 -*-

# perl
# delete files that's identical.
# see http://xahlee.info/perl-python/delete_dup_files.html

# Copyright 2005, 2011 by Xah Lee, XahLee.org. All rights reserved.

# first version: 2003-05
# first version: 2011-07-08 added a --delete and --help option. Expanded up the inline doc. Other small cleanups.


##################################################
use strict;
use File::Find;
use Data::Dumper qw(Dumper); $Data::Dumper::Indent=1;
use File::Compare;

use Combo114 qw(combo reduce merge);
use Genpair114 qw(parti genpair);
##################################################

# arguments

my $helpText = q{
To find dup files in a folder:
 perl del_dup.pl dirpath

To find dup files in several folders:
 perl del_dup.pl dirpath1 dirpath2 dirpath3 ...

To delete dup files:
 perl del_dup.pl --delete dirpath
or
 perl del_dup.pl --delete dirpath1 dirpath2 ...

When there are duplicate files, the first one found (in the order the dir is given) is preserved, the others are deleted.

To see this help again:
 perl del_dup.pl --help

Note: the options --help and --delete must be first argument.
};

if (not defined $ARGV[0]) {die qq{No argument received. \n $helpText};}

if ($ARGV[0] eq q{--help}) {print $helpText; exit 0;}


my $debugModeQ = 0;

my $septor1 = q{==============================} . "\n";
my $septor2 = q{---------------------} . "\n";
my $septor3 = q{=-=-=-=-=-=-=-=-=-=-=-=-=-} . "\n";

my $deleteModeQ = $ARGV[0] eq q{--delete} ? 1 : 0;

# print "total num of argv:", scalar(@ARGV), "\n";
# print "argv dump:", Dumper \@ARGV;

my @dirsToCheck = ();

for (my $i=0; $i < scalar(@ARGV); ++$i) {
  # print "i is:", $i, "\n";
  if (( $ARGV[$i] ne q{--delete})) {
    if (-d $ARGV[$i]) {
      print "Adding dir to check: $ARGV[$i]\n";
      push @dirsToCheck, $ARGV[$i];
    } else {
      print "Not a dir, skipped: $ARGV[$i]\n";
    }
  }
}


##################################################
# get all files and put them in an array
# each element has the form [dir path, file name, file size, integer of dir order]

my @fileList = ();

for (my $i=0; $i < scalar(@dirsToCheck); ++$i) {

    sub wanted() {
	my $fileName = $_;
	my $dirName = $File::Find::dir;
	if ( -f $File::Find::name
                # && $fileName =~ m@\.jpg$@i # check only jpg files
            ) {
          push @fileList, [$dirName, $fileName,  -s "$dirName/$fileName", $i];
        }
    }

    if (-d $dirsToCheck[$i]) {
      find(\&wanted, $dirsToCheck[$i]);
    }

}

#@fileList = sort {$a->[2] <=> $b->[2]} @fileList;

@fileList = sort {$a->[2] <=> $b->[2] || $a->[3] <=> $b->[3] } @fileList;

print qq[There are a total of ${\(scalar @fileList)} files examed.\n];
# print Dumper \@fileList;
print $septor1;

################################################################
# then partion the file list by file size.
# final result is an array @pfl, each element is another array, and each element is a file element, like this:
# ([ [ dir, name, size, dir index], ...], ...)

my @pfl; # partitioned file list, same-sized files are gathered together.

# partition the list into sublists of same-sized files
my @tray = @fileList[0]; for (my $i=1; $i < (scalar @fileList); $i++) { if ( (($fileList[$i-1]->[2]) == ($fileList[$i]->[2])) ) { push @tray, $fileList[$i] } else {push @pfl, [@tray];@tray=($fileList[$i]);} } push @pfl, [@tray]; undef @fileList;

print "There are ${\(scalar @pfl)} unique file size.\n";
if ($debugModeQ) { print "These following file groups have identical size:\n"; foreach my $group (@pfl) { for my $f (@$group) {print "$f->[0]/$f->[1]\n";}; print "\n"; }}

print $septor1;

################################################################
# fine tune the partition to be identical files instead of same sized.

# for a list of files (of same size), we want group together identical files.

#steps:
# find its length. from now on work with indexes.
# generate the comparison list (all possible pairings of any file from different dirs)
# do comparison, if hit, reduce the comparison list, and put the pair in idTwins list.
# repeat the above until comparison list is empty.
# link the identical twins (of pairs) into groups of the same index.
# make the partition. (turn indexes back to file element [dir, name, size])


my @idTwins=(); # e.g. ([1,3],[7,9],[3,2],...) # files are represented by indexs. In @idTwins, grouped togeher are indexs of the same file. i.e. file 1 3 are the same, 7 9 are the same, etc.
my @dfl=(); # partitioned duplicate file list

foreach my $filegroup (@pfl) {
    next if 1 == scalar @$filegroup;
    @idTwins=();

    my $pairings = ((scalar @dirsToCheck) > 1 ? genpair parti( $filegroup , sub {$_[0]->[3] == $_[1]->[3] }) : combo scalar @$filegroup );

    if ($debugModeQ){ print $septor2; print 'number of same sized: ', scalar @$filegroup, "\n"; print 'pairings: '; foreach my $nnn (keys %$pairings) {print "$nnn | "; }; print "\n";}

    while (0 < scalar keys %$pairings) {
        my $pairKey = [keys %$pairings]->[0];
        my $f1 = "$filegroup->[$pairings->{$pairKey}->[0]-1]->[0]/$filegroup->[$pairings->{$pairKey}->[0]-1]->[1]"; # $f1 is the full file path
        my $f2 = "$filegroup->[$pairings->{$pairKey}->[1]-1]->[0]/$filegroup->[$pairings->{$pairKey}->[1]-1]->[1]";

        if ($debugModeQ) { print $septor3; print 'current pairings pool: '; foreach my $nnn (keys %$pairings) {print "$nnn | "; }; print "\n"; print 'current id twins: '; foreach my $nnn (@idTwins) {print "@$nnn | "; }; print "\n"; print 'f1 is: ', $f1, ' ',$pairings->{$pairKey}->[0], "\n"; print 'f2 is: ', $f2, ' ', $pairings->{$pairKey}->[1],"\n"; }

        if (compare($f1,$f2) == 0) {
            if ($debugModeQ) { print "Test result: is same \n";}
            push @idTwins, $pairings->{$pairKey};
            $pairings = reduce $pairings, $pairings->{$pairKey};
        } else { if ($debugModeQ) {print "Test result: not same \n"} delete $pairings->{$pairKey} }
    }

    if ($debugModeQ) {print $septor2; print 'id twins: ', Dumper \@idTwins; print "\n"; print 'id groups: ', Dumper [merge \@idTwins]; print "\n";}

    if (0 < scalar @idTwins) { foreach my $indexGroup (merge \@idTwins) { push @dfl, [map {$filegroup->[$_-1];} @$indexGroup];}}

}; undef @pfl;

print $septor2;

print "These following files are identical:\n"; foreach my $group (@dfl) { for my $f (@$group) {print "$f->[0]/$f->[1]\n";}; print "\n"; }


print $septor1;



################################################################
# sort the sublists in dfl according to the order of given dir
# first given dir first

my @sfl = (); foreach my $mery (@dfl) {push @sfl, [sort {$a->[3] <=> $b->[3]} @$mery];}; undef @dfl;


my $summ=0; for my $bun (@sfl) {$summ += (scalar @$bun) -1};
my $sizz=0; for my $bun (@sfl) {$sizz += ((scalar @$bun) -1) * $bun->[0]->[2]};
print "There are $summ redundant files, totaling $sizz bytes.\n";

# print Dumper \@sfl;


my @toDelete; # full file paths; to be deleted

for my $bunch (@sfl) {shift @$bunch;  for my $f (@$bunch) {push @toDelete, "$f->[0]/$f->[1]"}}; @toDelete = sort @toDelete; undef @sfl;

# print Dumper \@toDelete;

print "The following files (if any) will be deleted (if you used the “--delete” option):\n";

foreach my $goner (@toDelete) {print "$goner\n";}

if ( $deleteModeQ == 1) {
    unlink @toDelete;
    print "File deletion done (if any)!";
}

__END__
