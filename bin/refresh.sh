#!/bin/sh

#for DIR in *
#do
#	if [ -d $DIR -a -f $DIR/refresh.sh ] &&
#	   [ ! -L $DIR ] && [ ! -x $DIR/refresh.sh ]
#	then
#		echo Sourcing $DIR/refresh.sh
#		. $DIR/refresh.sh
#	fi
#done

echo Processing main directory

bin/decorate.pl src/* tmp
bin/menuize.pl tmp/about.html \
	tmp/page2.html .
