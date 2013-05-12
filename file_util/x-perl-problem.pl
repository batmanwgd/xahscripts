# -*- coding: utf-8 -*-
# perl

# 2008-01-06

# this is a example of perl's problem. In this example, the code won't compile. If g is moved above wanted, then it works.

use File::Find qw(find);

$mydir= '/Users/xah/web/SpecialPlaneCurves_dir';
$mydir= q[/home/xah/web/xahlee_info/perl-python];

find(\&wanted, $mydir);


sub wanted {
    if ($_ =~/\.html$/ && -T $File::Find::name) { g $File::Find::name;}
    $File::Find::name;
}

sub g($) {print shift, "\n";}


__END__

Note: File::Find is one of the worst package in Perl. It cannot be used with a recursive (so-called) filter function.  The filter function cannot be defined as a pure function neither.  (because it relies on perl's implicit variable $_, which holds the current file name) And the filter function must come in certain order. (for example, the above program won't work if g is moved to the bottom.)  The quality of Perl libraries, although in massive quantity, but in general do not have good quality.
