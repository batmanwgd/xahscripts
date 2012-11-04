#!/usr/local/bin/perl

#--
use strict;

use Data::Dumper;
use Date::Manip;

my $time = ParseDate(scalar localtime());

my $gzip = '/usr/local/bin/gzip';

chdir('/home2/xah');
qx{tar cf notes_unix_dir.tar notes_unix_dir && $gzip -f notes_unix_dir.tar && mv -f notes_unix_dir.tar.gz /home2/xah/temp_garbage_dir};

qx{tar cf notes_work_dir.tar notes_work_dir && $gzip -f notes_work_dir.tar && mv -f notes_work_dir.tar.gz /home2/xah/temp_garbage_dir};

qx{tar cf perl_dir.tar perl_dir && $gzip -f perl_dir.tar && mv -f perl_dir.tar.gz /home2/xah/temp_garbage_dir};

qx{tar cf cron_dir.tar cron_dir && $gzip -f cron_dir.tar && mv -f cron_dir.tar.gz /home2/xah/temp_garbage_dir};

__END__

