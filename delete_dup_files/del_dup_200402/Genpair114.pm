package Genpair114;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use Exporter;

@ISA = qw(Exporter);

#EXPORT and EXPORT_OK list will be added one by one below.
@EXPORT = qw(parti genpair);
@EXPORT_OK = @EXPORT;

$VERSION = q(20030916);


#####################

=pod

given a list like this [e1,e2,e3,...,en]. We want to partition a list from 1 to n, based on a function that works on the elements. The true/false predicate function is {$_[0]->[3] <=> $_[1]->[3] }

example:
parti([['x','x','x','1'],
['x','x','x','2'],
['x','x','x','2'],
['x','x','x','2'],
['x','x','x','3'],
['x','x','x','4'],
['x','x','x','5'],
['x','x','x','5']] )

returns
 [[1],['2','3','4'],['5'],['6'],['7','8']];

=cut

sub parti($$) {
my @li = @{$_[0]};
my $sameQ = $_[1];

my @tray=(1);
my @result;

for (my $i=1; $i <= ((scalar @li)-1); $i++) {
	if (&$sameQ($li[$i-1], $li[$i])) {push @tray, $i+1} else {push @result, [@tray]; @tray=($i+1);}
}
push @result, [@tray];

return \@result;
}


=pod

 given several sets e.g. [[1],['2','3','4'],['5'],['6'],['7','8']]
 generate a list of all possible pairing of elemenst in any two set.
 example:

genpair([[1],['2','3','4'],['5'],['6'],['7','8']]) returns:

 [[1,'2'],[1,'3'],[1,'4'],[1,'5'],[1,'6'],[1,'7'],[1,'8'],['2','5'],['3','5'],['4','5'],['2','6'],['3','6'],['4','6'],['2','7'],['2','8'],['3','7'],['3','8'],['4','7'],['4','8'],['5','6'],['5','7'],['5','8'],['6','7'],['6','8']];

=cut

sub genpair ($) {
my $in = $_[0]; # e.g. [[1],['2','3','4'],['5'],['6'],['7','8']];

# my @final;
my %final;

for (my $head =0; $head <= ((scalar @$in)-2); $head++ ) {
	for (my $tail = $head+1; $tail <= ((scalar @$in)-1); $tail++ ) {
		foreach my $ii (@{$in->[$head]}) {
			foreach my $jj (@{$in->[$tail]}) {
#				push @final, [$ii,$jj]
				$final{"$ii,$jj"}= [$ii,$jj];
			}
		}
	}
}

return \%final;
}

