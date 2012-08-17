import java.util.*;

/*
*/

public class comb {

static ArrayList merge(ArrayList pairings) {

    ArrayList interm;

//    $interm[0]={$pairings[0][0]=>'x'}; ${interm[0]}{$pairings[0][1]}='x'; shift 
//                                                                        @pairings;
//
//  N1: for my $aPair (@pairings) {
//      for my $aGroup (@interm) {
//          if (exists ${$aGroup}{$aPair->[0]}) 
//{${$aGroup}{$aPair->[1]}='x'; next N1}
//          if (exists ${$aGroup}{$aPair->[1]}) 
//{${$aGroup}{$aPair->[0]}='x'; next N1}
//      }
//      push @interm, {$aPair->[0]=>'x'}; ${interm[-1]}{$aPair->[1]}='x';
//  }
//
//my @fin = shift @interm;
//
//  N2: for my $group (@interm) {
//      for my $newcoup (@fin) {
//          foreach my $k (keys %$group) {
//              if (exists ${$newcoup}{$k}) {map { ${$newcoup}{$_}='x'} 
//(keys %$group); next N2;}
//          }
//      }
//      push @fin, $group;
//}
    return map {[keys (%$_)]} @fin;
}


    public static void main(String[] args) {
        HashMap result = new HashMap(100);
        HashMap result2 = new HashMap(100);
        int[] pair= {2,3};
        result = combo(5);
        System.out.println(result.keySet().toString());
        System.out.println( reduce(result, pair).keySet().toString());
    }
}

/*
%20girzu/skami_bangu/java/java_tutorial/tutorial/collections/interfaces/map.html

sub merge($) {
my @pairings = @{$_[0]};

my @interm; # array of hashs

# chop the first value of @pairings into @interm
$interm[0]={$pairings[0][0]=>'x'}; ${interm[0]}{$pairings[0][1]}='x'; shift 
@pairings;

  N1: for my $aPair (@pairings) {
      for my $aGroup (@interm) {
          if (exists ${$aGroup}{$aPair->[0]}) 
{${$aGroup}{$aPair->[1]}='x'; next N1}
          if (exists ${$aGroup}{$aPair->[1]}) 
{${$aGroup}{$aPair->[0]}='x'; next N1}
      }
      push @interm, {$aPair->[0]=>'x'}; ${interm[-1]}{$aPair->[1]}='x';
  }

my @fin = shift @interm;

  N2: for my $group (@interm) {
      for my $newcoup (@fin) {
          foreach my $k (keys %$group) {
              if (exists ${$newcoup}{$k}) {map { ${$newcoup}{$_}='x'} 
(keys %$group); next N2;}
          }
      }
      push @fin, $group;
}
return map {[keys (%$_)]} @fin;
}

*/
