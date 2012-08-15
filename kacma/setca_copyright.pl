# perl

use File::Find;
use File::Path;
use Data::Dumper;
use File::Basename;


$inpath = '/Users/xxx/Documents/public_html/Whirlwheel_dir/altimount_pass';
$outpath = '/Users/xxx/Documents/public_html/Whirlwheel_dir/alt2';

$str = '© 2003 XahLee.org';

sub wanted {

	if (
			(not -d $File::Find::name)
			&& $File::Find::name =~ /\.jpg$/i) {

#		print "$File::Find::name\n";
		($name,$path,$suffix) = fileparse($File::Find::name, qw(.jpg .JPG) );
		$tt = qq(convert -quality 95 -draw 'text 0 10 "$str"' '$File::Find::name' '$outpath/$name.jpg');
		`$tt`;
#		print $tt, "\n";

	}
}

find(\&wanted, $inpath);

print "done\n";

__END__
