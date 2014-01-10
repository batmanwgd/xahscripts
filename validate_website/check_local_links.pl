# -*- coding: utf-8 -*-
# perl
# 2004-09-21, …, 2012-06-21

# given a dir, check all local links and inline images in the html files there. Print a report.
# XahLee.org

use strict;
use Data::Dumper;
use File::Find;
use File::Basename;

# normal Microsoft Windows style path
# "c:/Users/h3/web/"
# Cygwin style path
# "/cygdrive/c/Users/h3/web"
# NTFS on linux path
# "/media/OS/Users/h3/web/"
# normal linux path
# "/home/xah/web/"

my $inDirPath = q{/home/xah/git/xah-emacs-tutorial/};
my $inDirPath = q{/home/xah/web/xahlee_info/node_api/};
my $inDirPath = q{/home/xah/web/};
# my $inDirPath = q{/home/xah/web/xahlee_org/diklo/xy_xah_emacs_tutorial/};


# my $inDirPath = q{/home/xah/web/xahlee_org/diklo/xy_xah_emacs_tutorial/};

my $webRootPath = q{/home/xah/web};

$inDirPath = ($ARGV[0] ? $ARGV[0] : $inDirPath) ; # should give a full path; else the $File::Find::dir won't give full path.

die qq{dir $inDirPath doesn't exist! $!} unless -e $inDirPath;

##################################################
# subroutines

# get_links($file_full_path) returns a list of values in <a href="…">. Sample elements:
# http://xahlee.org
# ../image.png
# ab/some.html
# file.nb
# mailto:xah@xahlee.org
# #reference
# javascript:f('pop_me.html')

sub get_links ($) {
  my $full_file_path = $_[0];
  my @myLinks = ();
  open (FF, "<$full_file_path") or die qq[error: can not open $full_file_path $!];

  # read each line. Split on char “<”. Then use regex on 「href=…」 or 「src=…」 to get the url. This assumes that a tag 「<…>」 is not broken into more than one line.
  while (my $fileContent = <FF>) {
    my @textSegments = ();
    @textSegments = split(m/</, $fileContent);
    for my $oneLine (@textSegments) {
      if ($oneLine =~ m{href\s*=\s*"([^"]+)".*>}i) { push @myLinks, $1; }
      if ($oneLine =~ m{src\s*=\s*\"([^"]+)".*>}i) { push @myLinks, $1; }
    } }
  close FF;
  return @myLinks;
}

sub process_file {
  if (
      $File::Find::name =~ m[\.html$|\.xml$]
      # && $File::Find::dir !~ m(/xx)
     ) {
    my @myLinks = get_links($File::Find::name);

    map {
      my $orig_link_value = $_;
      my $pathToCheck = $_;

      $pathToCheck =~ s{^http://ergoemacs\.org/}{$webRootPath/ergoemacs_org/};
      $pathToCheck =~ s{^http://wordyenglish\.com/}{$webRootPath/wordyenglish_com/};
      $pathToCheck =~ s{^http://xaharts\.org/}{$webRootPath/xaharts_org/};
      $pathToCheck =~ s{^http://xahlee\.info/}{$webRootPath/xahlee_info/};
      $pathToCheck =~ s{^http://xahlee\.org/}{$webRootPath/xahlee_org/};
      $pathToCheck =~ s{^http://xahmusic\.org/}{$webRootPath/xahmusic_org/};
      $pathToCheck =~ s{^http://xahporn\.org/}{$webRootPath/xahporn_org/};
      $pathToCheck =~ s{^http://xahsl\.org/}{$webRootPath/xahsl_org/};

      if ( $pathToCheck !~ m[^//|^http:|^https:|^mailto:|^irc:|^ftp:|^javascript:]) {
        $pathToCheck =~ s/#.*//; # delete url fragment identifier e.g. 「http://example.com/index.html#a」
        $pathToCheck =~ s/%20/ /g; # decode percent encode url
        $pathToCheck =~ s/%27/'/g;

        if ( $pathToCheck !~ m{$webRootPath} ) {
          $pathToCheck = qq[$File::Find::dir/$pathToCheck]; # relative path. prepend dir
        }
        if (not -e $pathToCheck) {
          print qq[• $File::Find::name $orig_link_value\n];
          # my $mm = $orig_link_value;
          # $mm =~ s{^http://xahlee.org/}{http://xahlee.info/};
          # # print qq[(u"""<a href="$orig_link_value">""", u"""<a href="$mm">"""),\n];
          # print qq[(u"""<img src="$orig_link_value" """, u"""<img src="$mm" """),\n];
        }
      }
 }
      @myLinks;
 } }

my $mytime = localtime();
print "$mytime, Broken links in 「$inDirPath」.\n\n";

find(\&process_file, $inDirPath);

print "\nDone checking. (any errors are printed above.)\n";

__END__
