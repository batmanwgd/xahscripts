#!perl

=pod

Sun Apr 11 21:12:32 PDT 2004

given a html file, print all local links the file contains as full path.

For example:

list_local_links.pl /Documents/public_html/some/index.html
prints
/Documents/public_html/some/abc.jpg
/Documents/public_html/aoe/dt.html
/Documents/public_html/some/b/tn.html
... etc.


=cut

use Data::Dumper;
use File::Find;
use File::Basename;


if (not defined $ARGV[0]) {die "Error: argument not received. $0 <dir absolute path>
example:
perl $0 /Users/t/Documents/public_html/SpecialPlaneCurves_dir";}
$inpath = $ARGV[0]; # should give a full path; else the $File::Find::dir won't give full path.
while ($inpath =~ m@^(.+)/$@) { $inpath = $1;} # get rid of trailing slash

##################################################
# subroutines

# getlinks($file_full_path) returns a array that is a list of links. For example, it may return ('http://xahlee.org','../image.png', '_p2/some.html', 'file.nb', 'mailto:xah@xahlee.org', '#reference')
sub getlinks ($) { $full_file_name= $_[0];
	@linx =(); open (FF, "<$full_file_name") or die "error: can not open $full_file_name $!";
	while (<FF>) { @lns = split(m/href/, $_); shift @lns;
		for $lin (@lns) { if ($lin =~ m@\s*=\s*\"([^\"]+)\"@) { push @linx, $1; }}
	} close FF;
	return @linx;
}

# linkFullPath($dir,$locallink) returns a string that is the full path to the local link. For example, linkFullPath('/Users/t/public_html/a/b', '../image/t.png') returns 'Users/t/public_html/a/image/t.png'. The returned result will not contain double slash or '../' string.
sub linkFullPath($$){ $result=$_[0] . $_[1]; while ($result =~ s@\/\/@\/@) {}; while ($result =~ s@/[^\/]+\/\.\.@@) {}; return $result;}

# listLocalLinks($html_file_full_path) returns a array where each element is a full path of local links in the html.
sub listLocalLinks($) {
my $htmlfile= $_[0];

my @aa = getlinks($htmlfile);
my ($name, $dir, $suffix) = fileparse($htmlfile, ('\.html') );

@aa = grep(!m/#/, @aa);
@aa = grep (!m/^mailto:/, @aa);
@aa = grep (!m/^http:/, @aa);

my @linkedFiles=();
foreach my $lix (@aa) { push @linkedFiles, linkFullPath($dir,$lix);}
return @linkedFiles;
}

##################################################
@hh = listLocalLinks($inpath);

for my $ln (@hh) {print "$ln\n"}

__END__

$VAR1 = [
          '../specialPlaneCurves.html',
          '../Pedal_dir/pedal.html',
          'parabola.nb',
          '#History',
          '#Related%20Web%20Sites',
          '../ConicSections_dir/conicSections.html#History',
          '../ConicSections_dir/conicSections.html',
          '../Hyperbola_dir/hyperbola.html',
          '../Ellipse_dir/ellipse.html',
          '../ConicSections_dir/conicSections.html',
          'parabolaGen.mov',
          'parabolaReflect.mov',
          '../Envelope_dir/envelope.html',
          '../Evolute_dir/evolute.html',
          '../SemicubicParabola_dir/semicubicParabola.html',
          'http://donb.furfly.net/random_walks/vla.html',
          'p/b13.jpg',
          'p/b16.jpg',
          'p/b91.jpg',
          'mailto:xah@xahlee.org',
          'http://kenchandler.com/',
          'tv_dish3.jpg',
          'The_Dish_Parkes.jpg',
          '../ConicSections_dir/conicSections.html#Related%20Web%20Sites',
          '_p/stirlingSolarDish.jpg',
          '_p/stirlingSolarDishPhoto.jpg',
          'http://xahlee.org/PageTwo_dir/more.html',
          'mailto:xah@xahlee.org'
        ];
