package Genpair114;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use Exporter;

@ISA = qw(Exporter);

#EXPORT and EXPORT_OK list will be added one by one below.
@EXPORT = qw(parti genpair);
@EXPORT_OK = @EXPORT;

$VERSION = q(20030916);

# Copyright 2005 by Xah Lee, XahLee.org. Permission is granted for derivative work for non-commercial purposes provided credit is given.
# http://xahlee.org/perl-python/delete_dup_files.html

#####################

=pod

parti(aList, equalFunc)

given a sortable and sorted list aList of n elements, we want to
return a list that is a range of numbers from 1 to n, partitioned by
the predicate function of equivalence equalFunc. (a predicate function
is a function that takes two arguments, and returns either True or
False.)

example:
parti([
['x','x','x','1'],
['x','x','x','2'],
['x','x','x','2'],
['x','x','x','2'],
['x','x','x','3'],
['x','x','x','4'],
['x','x','x','5'],
['x','x','x','5']], sub {$_[0]->[3] == $_[1]->[3]} )

returns
 [[1],['2','3','4'],['5'],['6'],['7','8']];

Note: a mathematical aspect: there are certain mathematical
constraints on the a function that checks equivalence. That is to say,
if a==b, then b==a. If a==b and b==c, then a==c. And, a==a. If a
equivalence function does not satisfy these, it is inconsistent and
basically give meaningless result.

Note: This parti function requires the input to be sortable and
sorted.

=cut

sub parti($$) {
my @li = @{$_[0]};
my $sameQ = $_[1];

my @tray=(1);
my @result;

for (my $i=1; $i <= ((scalar @li)-1); $i++) {
    if (&$sameQ($li[$i-1], $li[$i]))
    {push @tray, $i+1} else {push @result, [@tray]; @tray=($i+1);}
}
push @result, [@tray];

return \@result;
}


=pod

given a list that is a set partitioned into subsets, generate a list
of all possible pairings of elements in any two subset.  Example:

genpair([[1],['2','3','4'],['5'],['6'],['7','8']])

returns:

 [[1,'2'],[1,'3'],[1,'4'],[1,'5'],[1,'6'],[1,'7'],[1,'8'],['2','5'],['3','5'],['4','5'],['2','6'],['3','6'],['4','6'],['2','7'],['2','8'],['3','7'],['3','8'],['4','7'],['4','8'],['5','6'],['5','7'],['5','8'],['6','7'],['6','8']];


Actually this program returns a reference to a hash. The keys are of the form "3,7"

=cut

sub genpair ($) {
my $partiSet = $_[0]; # e.g. [[1],['2','3','4'],['5'],['6'],['7','8']];

my %result;

for (my $head =0; $head <= ((scalar @$partiSet)-2); $head++ ) {
	for (my $tail = $head+1; $tail <= ((scalar @$partiSet)-1); $tail++ ) {
		foreach my $ii (@{$partiSet->[$head]}) {
			foreach my $jj (@{$partiSet->[$tail]}) {
				$result{"$ii,$jj"}= [$ii,$jj];
			}
		}
	}
}

return \%result;
}

