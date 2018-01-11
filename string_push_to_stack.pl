#!/usr/bin/perl

use strict;

## a simple helper to convert a string into a hexadecimal representation of dwords in an order suitable for pushing on the stack in assembly; useful for shellcode building

my $input="cmd.exe"; # /c net user hacker Password91 /add & net localgroup Administrators /add hacker";

print "INPUT: $input\n";

my $len=length($input);
print "LEN IS: $len\n\n";

my $mod=$len%4;
print "Mod is $mod\n";

if($mod eq 0)
{
	$input.="    ";
}
else
{	
	for(my $i=0;$i<4-$mod;$i++)
	{
		print "Adding a space\n";			
		$input.=" ";
	}
}
$len=length($input);
print "LEN IS: $len\n\n";



my @in = split //,$input;

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
