#!perl

# delete some of the mov fig gsp nb m files under certain directory.
# this script is no longer used.
# Sun Apr 11 21:08:00 PDT 2004


use File::Find;

if (not defined $ARGV[0]) {die "Error: argument not received. $0 <dir absolute path>";}
$inpath = $ARGV[0]; # should give a full path, not relative path. Else, the $File::Find::dir won't give full path.


sub wanted {
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
			&& $File::Find::name !~ m@/ConicSections_dir/@
			&& $File::Find::name !~ m@/Hyperbola_dir/@
			&& $File::Find::name !~ m@/Parabola_dir/@
			&& $File::Find::name !~ m@/Ellipse_dir/@
		 ) {
		print $File::Find::name, "\n";
		open (FF, ">$File::Find::name/rsrc") or die "cannot open $!"; close FF; unlink $File::Find::name;
	}
}

find(\&wanted, $inpath);

