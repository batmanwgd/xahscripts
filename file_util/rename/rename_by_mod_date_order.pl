# perl

# rename all jpg files in the current dir (same dir this file is in).
# The result names are such that when sorted, they are the same order as original file's mod date from “ls -t”
# the dir

# 2006-07-21, 2008-12-16

# file path should not contain weird chars such as “"” or starting with dash “-”.

use Data::Dumper;

@filesToProcess = qx(ls -t *jpg);
chomp(@filesToProcess);

# print Dumper(\@filesToProcess);

$i = 0; for my $afile (@filesToProcess) {
# print $afile, "\n";

my $newName = 'ab' . sprintf("%03d", $i) . '-' . $afile, "\n"; $i++;
print qx(mv "$afile" "$newName" \n);
}
