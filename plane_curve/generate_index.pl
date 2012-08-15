#!perl

# generate a index file.

use File::Find;
use File::Basename;

$inpath = '/Users/t/Documents/public_html/SpecialPlaneCurves_dir/';

sub gen {

	print $File::Find::name, "\n";

	($name,$path,$suffix) = fileparse($File::Find::name, qw(.html .mov .fg .gsp .nb .m));

	$str = $path;
	$str =~ s@^$inpath@@;

1 while $str =~ s@^/@@; 1 while $str =~ s@/$@@;
@ss = split( '/', $str);
$level = scalar @ss;


# print "$str $level", "\n";

## 	if (
## 			(not -d $File::Find::name)
## 			&& ($File::Find::name =~ m@\.html$@
## 			or $File::Find::name =~ /\.mov$/
## 			or $File::Find::name =~ /\.fig$/
## 			or $File::Find::name =~ /\.gsp$/
## 			or $File::Find::name =~ /\.nb$/
## 			or $File::Find::name =~ /\.m$/)
## 		 ) {
## 		print $File::Find::name, "\n";
## 	};
}

find(\&gen, $inpath);

print "done checking.";

__END__


	<img src="../Icons_dir/textIcon.gif" width="13" height="16"> <a href="../Cardioid_dir/cardioid.html">cardioid.html</a>
	<img src="../Icons_dir/mmaIconSmall.gif" width="16" height="16"> <a href="../Cardioid_dir/cardioid.nb">cardioid.nb</a>

	<img src="../Icons_dir/cabriIconSmall.gif" width="14" height="16"> <a href="../Cardioid_dir/cardioidByCaustic.fig">cardioidByCaustic.fig</a>

	<img src="../Icons_dir/gspIconSmall.gif" width="14" height="16"> <a href="../Cardioid_dir/cardioidByCaustic.gsp">cardioidByCaustic.gsp</a>

	<img src="../Icons_dir/movieIconSmall.gif" width="13" height="16"> <a href="../Cardioid_dir/cardioidCaustic.mov">cardioidCaustic.mov</a>



# need to insert
