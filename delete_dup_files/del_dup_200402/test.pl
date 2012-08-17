# perl's sort is a fucking destructive sort. # it messes up the original order

use Data::Dumper;

 @fl = ([1,3],[2,3],[3,28],[4,3],[5,2],[6,1],[7,4]);

# foreach my $i (1..9) {push @fl, [$i,$i];};

@fl = sort {$a->[1] <=> $b->[1]} @fl;

print Dumper \@fl;


