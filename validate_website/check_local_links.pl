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

# TODO 2014-02-01 need to fix on Mac, remove all hardcoded home dir

my $userHomeDir = $ENV{"HOME"};
my $webRootPath = qq{$userHomeDir/web};

my $inDirPath = qq{$userHomeDir/web/};
# my $inDirPath = qq{$userHomeDir/web/ergoemacs_org};

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
  open (FF, "<$full_file_path") or die qq[error: cannot open $full_file_path $!];

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
      && $File::Find::dir !~ m(xahlee_info/clojure-doc-1.6)
      && $File::Find::dir !~ m(xahlee_info/java8_doc)
      && $File::Find::dir !~ m(xahlee_info/css_2.1_spec)
      && $File::Find::dir !~ m(xahlee_info/dom3-core)
      && $File::Find::dir !~ m(xahlee_info/REC-SVG11-20110816)
      && $File::Find::dir !~ m(xahlee_info/php-doc)

     ) {
    my @myLinks = get_links($File::Find::name);

    map {
      my $orig_link_value = $_;
      my $pathToCheck = $_;

      # report local links that goes outside domain
      if (
          $pathToCheck =~ m{/ergoemacs_org/}
          or $pathToCheck =~ m{/wordyenglish_com/}
          or $pathToCheck =~ m{/xaharts_org/}
          or $pathToCheck =~ m{/xahlee_info/}
          or $pathToCheck =~ m{/xahlee_org/}
          or $pathToCheck =~ m{/xahmusic_org/}
          or $pathToCheck =~ m{/xahporn_org/}
          or $pathToCheck =~ m{/xahsl_org/}
          ) {
          print qq[• $File::Find::name $orig_link_value\n];
      }

      # change xah inter domain links to file path
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

          # change it to full path
          if ( $pathToCheck !~ m{$webRootPath} ) {
              $pathToCheck = qq[$File::Find::dir/$pathToCheck]; # relative path. prepend dir
          }

          if (not -e $pathToCheck) {
              print qq[• $File::Find::name $orig_link_value\n];
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
