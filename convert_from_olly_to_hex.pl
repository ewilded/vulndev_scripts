#!/usr/bin/perl
use strict;

while(my $row=<STDIN>)
{
	chomp($row);
	$row=~s/^\w{8}\s+//g;
	$row=~s/\^//g;
	$row=~s/://g;
	if($row=~/^\w+ \w+ \w+/)
	{
		$row=~s/^(\w+) (\w+) (\w+)/$1$2$3/;
	}
	elsif($row=~/^\w+ \w+/)
	{
		$row=~s/^(\w+) (\w+)/$1$2/;
	}
	$row=~s/\s+.*$//g;
	$row=~s/\W+//;
	$row=lc($row);
	print $row if($row ne '');
}
