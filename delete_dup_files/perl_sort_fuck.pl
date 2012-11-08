# -*- coding: utf-8 -*-

# date: 2005
# perl's sort fucking messes up the original order. This is typical of things in Perl and Perl people.
# this is fixed sometimes after 2005.

use Data::Dumper;

@fl = ([4,3],[1,3],[3,28],[2,3],[5,2],[6,1]);

@fl = sort {$a->[1] <=> $b->[1]} @fl;

$Data::Dumper::Indent=0;
print Dumper \@fl;


