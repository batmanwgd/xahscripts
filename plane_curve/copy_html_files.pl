# perl

use File::Find;
use File::Path;
use File::Copy;

############
my $inPath = '/Users/t/web/SpecialPlaneCurves_dir/';
my $outPath = '/Users/t';

###########

sub processFile () {
my $dirName = $File::Find::dir;
my $fileName = $_;
my $file = $File::Find::name;

if ($file =~ m{\.html$}) {

    print "$outPath/$dirName/$fileName\n";

#    mkpath(qq($outPath/$dirName), 1, 0711) or die qq(error: mkpath fucked ($outPath$dirName) $!);
#    copy($file, qq($outPath/$dirName/$fileName)) or die qq(error: copy fucked ($outPath$dirName$fileName) $!);
}
}

#------

find(\&processFile, $inPath);

