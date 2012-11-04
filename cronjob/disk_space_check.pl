#!/usr/local/bin/perl

# test disk space

#--
use strict;
use Data::Dumper;
use Mail::Sendmail;

my $df = '/usr/xpg4/bin/df';


my $ss = qx{$df -k | grep /dev/dsk/c0t0d0s0;};
my @aa = split(m{\s+}, $ss);


if ( substr($aa[-2],0,2) > 92) {

my $result = qx{$df -k};

my %mail = 
	 (To      => 'xah@netopia.com',
		From    => 'imp@ada.netopia.com',
		Subject => 'heed: ada disks > 92%',
		Message => $result
	 );

sendmail(%mail) or die $Mail::Sendmail::error;

# print $aa[-2];
};

__END__


