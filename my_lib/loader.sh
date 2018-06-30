#!/bin/bash


#for test you should pass test as argument (loader.sh test)


#load functions
functions_dir="my_lib/functions"
[ "$1" == "test" ] && functions_dir="functions"
#echo "$functions_dir"
for entry in "$functions_dir"/*
do
#	echo "$entry"
	source "$entry"
done



#load menu
menu_dir="my_lib/menu"
[ "$1" == "test" ] && menu_dir="menu"

for entry in "$menu_dir"/*
do
	source "$entry"
done
