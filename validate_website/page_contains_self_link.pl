#-*- coding: utf-8 -*-
# perl

# 2013-05-05
# given a dir, report all html files that contains a link to itself.
# XahLee.org

# todo:
# this script assumes your links are clean. for example, if you have a file at
# /a/b/c.html
# and it contains a link
# <a href="../b/c.html">some</a>
# this is a link to itself, but won't be reported.
# only links like this:
# <a href="c.html">some</a>
# will

use POSIX;
use File::Find;
use strict;

my $inputDir = q[/home/xah/web/xahlee_info/];

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

  my $fname = $_;
  if (
      $File::Find::name =~ m[\.html$|\.xml$]
     ) {
    my @myLinks = get_links($File::Find::name);

    map {
      if ($fname eq $_) {
        print qq[• hit: $File::Find::name\n];
        print qq[ $fname\n];
      }
    } @myLinks;
  }
}

find(\&process_file, $inputDir);

__END__
