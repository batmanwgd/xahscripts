######################

package Combo114;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);
use Exporter;

@ISA = qw(Exporter);

#EXPORT and EXPORT_OK list will be added one by one below.
@EXPORT = qw(combo reduce merge);
@EXPORT_OK = @EXPORT;

$VERSION = q(20050211);

# first version: 20030916
# Copyright 2005 by Xah Lee, http://xahlee.org/perl-python/delete_dup_files.html

#####################

# combo(n) returns a collection with elements of pairs that is all possible combinations of 2 things from n. For example, combo(4) returns {'3,4' => ['3',4],'1,2' => [1,2],'1,3' => [1,3],'1,4' => [1,4],'2,3' => ['2',3],'2,4' => ['2',4]}; Each pair ($i,$j) returned must have $i < $j. Hash form is returned instead of array for this program.
sub combo {
  my $max = shift;
  my %hh=();
  for my $j ( 1 .. $max ) {
    for my $i ( 1 .. $j-1 ) {
      $hh{"$i,$j"} = [$i, $j];
    }
  }
  return \%hh;
}

# old implementation with lesser algorithm
# sub combo ($) { my $max=$_[0]; my %hh=(); for (my $j=1; $j < $max; ++$j) { for (my $i=1; $i <= $max; ++$i) { my $m = (($i+$j)-1)%$max+1; if ($i < $m){ $hh{"$i,$m"}=[$i,$m];}}} return \%hh;}


=pod

e.g. reduce( $pairings, $a_pair) retured the first argument with some pairs deleted.

Detail:

we have n things, represented by numbers 1 to n. Some of these are
identical. We want to partition the range of numbers 1 to n so that
identical ones are grouped together.

To begin comparison, we generate a list of pairings that's all
possible parings of numbers 1 to n. (of course order does not matter,
and the pairing does not contain repeations) This is the first
argument to reduce.

We'll go thru this pairings list one by one and do comparisons, remove
the pair once it has been compared. However, more pairs can be removed
if a we find a pair identical.

For example, suppose we know that 2 and 4 are identical, and if the
pairing list contains (2,3) and (4,3), one of them can be deleted
because now 2 and 4 are the same thing.

(We do this because we expect the comparison operation will be
expensive.)

reduce( $pairings, $a_pair) returns a reduced $pairings knowing that
$a_pair are identical.

The first argument $pairings must be in the form of a hash.

 {'1,5' => [1,5],'3,5' => [3,5],'2,4' => [2,4],'4,5' => [4,5],'1,3' =>
 [1,3],'2,5' => [2,5],'1,2' => [1,2],'3,4' => [3,4],'2,3' =>
 [2,3],'1,4' => [1,4]}

(Note that keys are strings of the pairs separated by a comma.)

$a_pair is a reference to a list of the form [$a,$b].

For example, if the input is the hash given above,
and if 2,3 is identical,
then these pairs will be deleted
3,4
1,3
3,5

(different pairs may be deleted if the hash's pairs are given in
different order. i.e. 3,4 instead of 4,3)

The return value is a reference to a hash.

=cut

sub reduce ($$) {
  my %hh= %{$_[0]};             # e.g. {'1,2'=>[1,2],'5,6'=>[5,6],...}
  my ($j1,$j2)=($_[1]->[0],$_[1]->[1]); # e.g. [3,4]
  delete $hh{"$j1,$j2"};
  foreach my $k (keys %hh) {
    $k=~m/^(\d+),(\d+)$/;
    my ($k1,$k2)=($1,$2);
    if ($k1==$j1) {
      if ($j2 < $k2) {
        delete $hh{"$j2,$k2"};
      } else {
        delete $hh{"$k2,$j2"};
      }
      ;
    }
    ;
    if ($k2==$j1) {
      if ($k1 < $j2) {
        delete $hh{"$k1,$j2"};
      } else {
        delete $hh{"$j2,$k1"};
      }
      ;
    }
    ;
  }
  return \%hh;
}


=pod

merge($pairings) takes list of pairs, each pair indicates the sameness
of the two indexes. Returns a partitioned list of same indexes.

For example, if the pairings is
merge( [ [1,2], [2,4], [5,6] ] );

that means 1 and 2 are the same. 2 and 4 are the same. Therefore
1==2==4. The result returned is

[[4,2,1],[6,5]];

(ordering of the returned list and sublists are not specified/important.)

=cut

sub merge($) {
  my @pairings = @{$_[0]};     # @pairings is, e.g. ([a,b], [c,d],...)

  my @interm; # array of hashs. For the hash, Keys are numbers, values are dummy 'x'.

  # chop the first value of @pairings into @interm
  $interm[0]={$pairings[0][0]=>'x'}; ${interm[0]}{$pairings[0][1]}='x'; shift @pairings;

 N1: for my $aPair (@pairings) {
    for my $aGroup (@interm) {
      if (exists ${$aGroup}{$aPair->[0]}) {
        ${$aGroup}{$aPair->[1]}='x'; next N1;
      }
      if (exists ${$aGroup}{$aPair->[1]}) {
        ${$aGroup}{$aPair->[0]}='x'; next N1;
      }
    }
    push @interm, {$aPair->[0]=>'x'}; ${interm[-1]}{$aPair->[1]}='x';
  }

  my @fin = shift @interm;

 N2: for my $group (@interm) {
    for my $newcoup (@fin) {
      foreach my $k (keys %$group) {
        if (exists ${$newcoup}{$k}) {
          map { ${$newcoup}{$_}='x'} (keys %$group); next N2;
        }
      }
    }
    push @fin, $group;
  }
  return map {[keys (%$_)]} @fin;
}
