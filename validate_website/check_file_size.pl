# perl

# Tue Oct  4 14:36:48 PDT 2005
# given a dir, report all html file's size. (counting inline images)
# XahLee.org

use Data::Dumper;
use File::Find;
use File::Basename;

$inpath = "c:/Users/h3/web/xahlee_org/funny";
$sizeLimit = 800 * 1000;

# $inpath = $ARGV[0]; # should give a full path; else the $File::Find::dir won't give full path.
while ($inpath =~ m@^(.+)/$@) { $inpath = $1;} # get rid of trailing slash

die "dir $inpath doesn't exist! $!" unless -e $inpath;

##################################################
# subroutines


# getInlineImg($file_full_path) returns a array that is a list of inline images. For example, it may return ('xx.jpg','../image.png')
sub getInlineImg ($) { $full_file_path= $_[0];
	@linx =(); open (FF, "<$full_file_path") or die "error: can not open $full_file_path $!";
	while (<FF>) { @txt_segs = split(m/src/, $_); shift @txt_segs;
		for $linkBlock (@txt_segs) {
        if ($linkBlock =~ m@\s*=\s*\"([^\"]+)\"@) { push @linx, $1; }
    }
	} close FF;
	return @linx;
}


# linkFullPath($dir,$locallink) returns a string that is the full path to the local link. For example, linkFullPath('/Users/t/public_html/a/b', '../image/t.png') returns 'Users/t/public_html/a/image/t.png'. The returned result will not contain double slash or '../' string.
sub linkFullPath($$){
    $result=$_[0] . $_[1];
    $result =~ s@\/+@\/@g;
    while ($result =~ s@/[^\/]+\/\.\.@@g) {};
    return $result;
}


# listInlineImg($html_file_full_path) returns a array where each element is a full path to inline images in the html.
sub listInlineImg($) {
	my $htmlfile= $_[0];

	my ($name, $dir, $suffix) = fileparse($htmlfile, ('\.html') );
	my @imgPaths = getInlineImg($htmlfile);

	my @result=();
	foreach my $aPath (@imgPaths) { push @result, linkFullPath($dir,$aPath);}
	return @result;
}

##################################################
# main
sub checkLink {
    if (
        $File::Find::name =~ m@\.html$@ && -T $File::Find::name
    ) {
        $totalSize= -s $File::Find::name;
        @imagePathList = listInlineImg($File::Find::name);
        for my $imgPath (@imagePathList) {$totalSize += -s $imgPath;};
        push (@fileSizeList, [$totalSize, $File::Find::name]);
	};
}

find(\&checkLink, $inpath);

@fileSizeList = sort { $b->[0] <=> $a->[0]} @fileSizeList;

print Dumper(\@fileSizeList);

# {
#   $ii = 0;
#   $fsize;
#   $fname;
#   while ($ii < scalar @fileSizeList) {
#     # print qq{$i \n};
#     $fsize = $fileSizeList[$ii][0];
#     $fname = $fileSizeList[$ii][1];
#     print sprintf( qq{%dk, %s\n}, $fsize, $fname);
#     $ii++;
#   }
# }

# foreach ($x,$y) (@fileSizeList) {
# # print sprintf( "%s",  $xx[0]/1000. , $xx[1]);
# print sprintf( "%s %s",  $x , $y);
# }

print "done reporting. (any file above size are printed above.)";

__END__
