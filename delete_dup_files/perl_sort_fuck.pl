# perl's sort is fucking messes up the original order. This is typical of things in Perl and Perl people

use Data::Dumper;

 @fl = ([4,3],[1,3],[3,28],[2,3],[5,2],[6,1],[7,4]);
# @fl = ([1,3],[9,3],[3,2]);

# foreach my $i (1..9) {push @fl, [$i,$i];};

@fl = sort {$a->[1] <=> $b->[1]} @fl;

$Data::Dumper::Indent=0;
print Dumper \@fl;


