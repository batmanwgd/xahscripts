# -*- coding: utf-8 -*-
# perl

# rename some jpg files in a given dir.
# file names that match a regex will be renamed, not others.
# 2006

use Data::Dumper;
use File::Find;

my $dir = "/Users/xah/cinse_pixra3/post 2006/named";
my $dir = q(/home/xah/Pictures/cinse_pixra3/);

sub wanted {
    my $fname = $_;

    if (
        $fname =~ m[\.jpg$] &&
        $fname !~ m[^\d{8}T\d{6}] &&
        ( $fname ne '.DS_Store' ) &&
       (
        $fname =~ m[^\d{1,3}-*\d{1,2}\.jpg$] ||
        $fname =~ m[^\d\.jpg$] ||
        $fname =~ m[^.+\.html$] ||
        $fname =~ m[^.+\.sh$]
       )
        ) {

        print $fname . "\n";

#         $date = qx(GetFileInfo -d "$fname"); # out: 09/25/2007 07:19:22
#         chomp($date);
#         $date =~ s[(\d\d)/(\d\d)/(\d\d\d\d) (\d\d):(\d\d):(\d\d)][\3\1\2T\4\5\6];

#         $newName = $date . '-' . $fname;

#         if (-e $newName) { print "fucked $newNam\n";} else {

#             print qq(mv "$fname" "$newName" \n);
# #            qx(mv "$fname" "$newName" \n);
#         }


    }
}

find(\&wanted, ($dir));

__END__
