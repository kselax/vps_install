#!/bin/bash



m_remove_ng_apps(){

	echo "function m_remove_apps"
	local option[1]="remove nginx"
	local option[2]="remove ng MySQL"
	local option[3]="remove ng php"
	local option[4]="remove ng phpMyAdmin"
	local option[5]="remove ng varnish"
	local option[6]="remove ng let's encrypt"
	local option[7]="return back"


	local PS3="Select action: "

	select var in "${option[@]}"
	do

		case $REPLY in
			1)
				echo "remove nginx"
				remove_nginx
				;;
			2)
				echo "remove ng MySQL"
				remove_ng_mysql
				;;
			3)
				echo "remove ng php"
				remove_ng_php
				;;
			4)
				echo "remove ng phpMyAdmin"
				remove_ng_phpmyadmin
				;;
			5)
				echo "remove ng varnish"
				remove_ng_varnish
				;;
			6)
				echo "remove ng let's encrypt"
				remove_ng_lets_encrypt
				;;
			7)
				return;
				;;
			*)
				echo "unknown select"
				;;
		esac

	done

} #m_remove_apps
