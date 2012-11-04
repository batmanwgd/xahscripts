# perl

# throw-away script.
# generate html links to image files.

use File::Find;
use File::Path;
use Data::Dumper;
use File::Basename;


$root_path= $ARGV[0];
$photo_path= '';
$icon_path = '';

sub wanted {
  if (
      (not -d $File::Find::name)
      && $File::Find::name =~ /\-s\.jpg$/i) {
    #		print "$File::Find::name\n";
    $qxout = qx(identify $File::Find::name);
    ##		print $qxout, "\n";
    $qxout =~ / (\d+)x(\d+)/; $width = $1; $height = $2;

    ($name,$path,$suffix) = fileparse($File::Find::name, qw(-s.jpg -s.JPG) );

    print qq(<a href="$photo_path/$name.jpg"><img src="$icon_path/$name$suffix" width="$width" height="$height"></a>\n);

    ## print "$width, $height\n";
    # qx(convert -scale 33.33% $File::Find::name $outpath/$name-s.png);
    # $x = 0; $y= 10; qx(convert -draw 'text $x $y "$str"' $outpath/$name-s.png $outpath/$name-s.jpg), "\n"; unlink "$outpath/$name-s.png";
    #	qx(convert -quality 85 -scale 33.33% -draw 'text 0 10 "$str"' $File::Find::name $outpath/$name-s.jpg);
  }
}


find(\&wanted, "$root_path/$icon_path");

print "done\n";

__END__
