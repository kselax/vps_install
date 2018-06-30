#!/bin/bash



m_remove_apps(){

	echo "function m_remove_apps"
	local option[1]="remove Apache2"
	local option[2]="remove MySQL"
	local option[3]="remove php"
	local option[4]="remove phpMyAdmin"
	local option[5]="remove nvm"
	local option[6]="remove let's encrypt"
	local option[7]="return back"

	
	local PS3="3Select action: "

	select var in "${option[@]}"
	do
		
		case $REPLY in
			1)
				echo "remove Apache2"
				remove_apache2
				;;
			2)
				echo "remove MySQL"
				remove_mysql
				;;
			3)
				echo "remove php"
				remove_php
				;;
			4)
				echo "remove phpMyAdmin"
				remove_phpmyadmin
				;;
			5)
				echo "remove_NVM"
				remove_nvm
				;;
			6)
				echo "remove let's encrypt"
				remove_lets_encrypt
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


