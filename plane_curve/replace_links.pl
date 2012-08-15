#!perl

=pod

This script removes certain special files (.mov .gsp etc) and replace links to them by a url to the cdrom.html page.

mored detail:

run the script like this:
$ replace_links.pl /Users/t/SpecialPlaneCurves_dir

the special files are defined @special_files.

the replace string is:
$replaceStr='http://xahlee.org/SpecialPlaneCurves_dir/Intro_dir/cdrom.html';

Some discussions:

ideally, i would do it in such a way that all links in a set of html pages
(ex. parabola.html and conicSections.html ...) are intact. Their
links may points to files in any directory. So, this means i cannot
just delete goodies based on what directory they sit in. This means
when i process html files to replace links, the i have to check if
the link points to a .mov file that is pointed by a link from one of
the conics pages. So, this means on the whole i have to generate a
list of .mov files (that are linked by one of the conics pages),
then use this list as my criteria for checking links.

so, what i have to do is then
* define a list of html pages that i want links in them to be intact.
* process these html files to obtain a list of files "keep_files".
* delete the .mov files that are not in keep_files.
* process every .html page to replace links pointing files in "keep_files".

 problem line: Ellipse_dir/ellipse.html: <a href="../Astroid_dir/astroidTrammel.gsp">Trammel of Archemedes 1</a>; <a href="ellipseTrammelGen.gsp">2</a>; <a href="ellipseTrammelFamily.gsp">Ellipse Family</a>


History:
I used to follow the simple method by
 * delete all .mov files outside conics dir
 * then do link replacement for all non-conics pages.

 the Problem with this simple approach is: there are links from conics page to outside, and also non-conics page to conics dir. So, this scheme will leave links linking into conics pages unnecessarily replaced, and also some links in conics page linking outside will be broken since outside conics files are removed.

better solution:
 * gather all links in the conics pages.
 * do link replacement based on above, regardless of which page it is. And also do file removal based on this.

=cut

use Data::Dumper;
use File::Find;
use File::Basename;

@special_files = qw(
Parabola_dir/parabola.html
ConicSections_dir/conicSections.html
Hyperbola_dir/hyperbola.html
Ellipse_dir/ellipse.html
);

if (not defined $ARGV[0]) {die "Error: argument not received. $0 <dir absolute path>
example:
perl replace_links.pl /Users/t/Documents/public_html/SpecialPlaneCurves_dir";}
$inpath = $ARGV[0]; # should give a full path; else the $File::Find::dir won't give full path.
while ($inpath =~ m@^(.+)/$@) { $inpath = $1;} # get rid of trailing slash

$replaceStr='http://xahlee.org/SpecialPlaneCurves_dir/Intro_dir/cdrom.html';

my %file_keeps=();

##################################################
# subroutines


# getlinks($file_full_path) returns a array that is a list of links. For example, it may return ('http://xahlee.org','../image.png', '_p2/some.html', 'file.nb', 'mailto:xah@xahlee.org', '#reference')
sub getlinks ($) { $full_file_name= $_[0];
	@linx =(); open (FF, "<$full_file_name") or die "error: can not open $full_file_name $!";
	while (<FF>) { @lns = split(m/href/, $_); shift @lns;
		for $lin (@lns) { if ($lin =~ m@=\"([^\"]+)\"@) { push @linx, $1; }}
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


# if not one of the files to keep, delete it
sub delete_files {
	if (
			(not -d $File::Find::name)
			&& -f $File::Find::name
			&& (
					$File::Find::name =~ /\.mov$/
					or $File::Find::name =~ /\.fig$/
					or $File::Find::name =~ /\.gsp$/
					or $File::Find::name =~ /\.nb$/
					or $File::Find::name =~ /\.m$/
				 )
			&& (! exists $file_keeps{$File::Find::name} )
		 ) {
		print "deleting: $File::Find::name\n";
		unlink $File::Find::name;
	}
}


# this sub is used with File::Find's find. For each html file, replace certain local links in them, and make a backup copy with ~ ending.
# how it works: read in each line, split the line into array with /href/ (so that we process at most  one link. Much easier to deal with than multiple links in a line.). If the splitted line is a local link, check if it should be replaced, if so, replace it. print it to the file.
sub replaceLinks {
	if ( (not -d $File::Find::name) && $File::Find::name =~ m@\.html$@) {
		print "## processing: $File::Find::name \n";
		my ($name, $dir, $suffix) = fileparse($File::Find::name, ('\.html') );

		my $wholefile ='';
		my $wholefileNew ='';
		my @textBlocks =();
		my @textBlocksNew =();

		# read in whole file.
		{open (FF, "<$File::Find::name") or die "open problem $!"; {local $/; $wholefile = <FF>;} close FF; }

		# process the replacement by spliting whole file into href blocks
		{@textBlocks = split( m/href/, $wholefile);
		$firstBlock = shift @textBlocks;
		 for my $block (@textBlocks) {
			 if( $block =~ m@\s*=\s*\"([^\"]+)\"@ ) {
				 $url = $1;
				 if (($url !~ m@^http|^mailto|\#@) && ($url =~ m@\.nb$|\.m|\.mov|\.fig|\.gsp@)) {
					 my $fullFilePath = linkFullPath($dir ,$url);
					 if (not exists $file_keeps{$fullFilePath}  ) {
#						 print $fullFilePath, "\n";
						 $block =~ s@\s*=\s*\"([^\"]+)\"@=\"$replaceStr\"@;
					 }
				 }
				 push ( @textBlocksNew, $block);
			 }
		 }
		 @textBlocksNew = ($firstBlock, @textBlocksNew );
		 $wholefileNew = join ('href',@textBlocksNew);
	 }

		# make backup; write to file.
		{use File::Copy; copy($File::Find::name, $File::Find::name . '~'); open (F2, ">$File::Find::name") or die "open problem $!"; print F2 $wholefileNew; close F2;}

  }
}


##################################################
# main body


# collect the files to keep, by processing each of the special .html file
for $spc_f (@special_files) {
 my @manyLinks = listLocalLinks("$inpath/$spc_f");
 foreach $lik (@manyLinks) {$file_keeps{$lik} = 1;}
} # print Dumper \%file_keeps;

# delete goodies
find(\&delete_files, $inpath);

# replace links in each html file
find(\&replaceLinks, $inpath);

print "Done\n";

__END__
