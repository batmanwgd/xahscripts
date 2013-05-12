#-*- coding: utf-8 -*-
#perl! -w

# a temp quick script to list folder contents for my generating links to midi files for my classical keyboard music web page. Xah 1998-07.

#--
use strict;

use File::Find;


#--

my $inputFolderPath=
q{APS318User:MathAll:public_html:ClassicalMusic_dir:MIDI_Files_dir:ChopinFrederic_dir:Nocturns_dir:};

my $midiIconString=q(<IMG SRC="Icons_dir/midiFileIcon.gif">);

#--

sub processFile {
my $ff=$File::Find::name;
if (-d $ff) {return 0;} else {
$ff=substr($ff,index($ff,q{MIDI_Files_dir}));
$ff=~s{:}{/}g;
print qq(<a href="$ff">$midiIconString</a>\n);
};
};


#--

find(\&processFile,$inputFolderPath);

__END__



