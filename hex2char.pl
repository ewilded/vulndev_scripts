#!/usr/bin/perl

use strict;



while(my $row=<STDIN>)
{
	$row=lc($row);
	while($row=~/([a-f0-9]{2})/g)
	{
		my $hx=$1;	
		
		eval('print '.'"chr('.$hx.')=".'.'chr(0x'.$hx.')."\n"');
	}
}
