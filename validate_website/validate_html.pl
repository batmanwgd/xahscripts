# perl

# 2008-06-20
# validates a given dir's html files recursively
# requires the mac os x app Validator-SAC.app
# at http://habilis.net/validator-sac/
# as of 2008-06

use strict;
use File::Find;

my $dirPath = q(/Users/xah/web/emacs);
my $validator = q(/Applications/Validator-SAC.app/Contents/Resources/weblet);

sub wanted {
  if ($_ =~ m{\.html$} && not -d $File::Find::name) {

    my $output = qx{$validator "$File::Find::name" | head -n 11 | grep 'X-W3C-Validator-Status:'};

    if ($output ne qq(X-W3C-Validator-Status: Valid\n)) {
      print q(Problem: ), $File::Find::name, "\n";
    } else {
      print qq(Good: $_) ,"\n";
    }

  }
}

find(\&wanted, $dirPath);

print q(Done.)
