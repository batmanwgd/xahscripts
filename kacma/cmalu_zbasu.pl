# perl

use File::Find;
use File::Path;
use Data::Dumper;
use File::Basename;


$inpath = '/Users/t/public_html/Whirlwheel_dir/fan/x';
$outpath = $inpath;
$str = 'Copyright 2003 XahLee.org';


sub wanted {
	if (
			(not -d $File::Find::name)
			&& $File::Find::name =~ /\.jpg$/i) {

#		print "$File::Find::name\n";

		($name,$path,$suffix) = fileparse($File::Find::name, qw(.jpg .JPG) );
		$tt = qq(convert -quality 85 -scale 33.33% -draw 'text 0 10 "$str"' $File::Find::name $outpath/$name-s.jpg);
 print $tt,"\n";

# qx(convert -scale 33.33% $File::Find::name $outpath/$name-s.png); $qxout = qx(identify $outpath/$name-s.png); $qxout =~ / (\d+)x(\d+)/; $width = $1; $height = $2; $x = 0; $y= 10; qx(convert -draw 'text $x $y "$str"' $outpath/$name-s.png $outpath/$name-s.jpg), "\n"; unlink "$outpath/$name-s.png";
	}
}

find(\&wanted, $inpath);


__END__

convert -quality 85 -scale 33.33% -draw 'text 5 10 "© 2006 XahLee.org"' blow_chopper.jpg blow_chopper-s.jpg



