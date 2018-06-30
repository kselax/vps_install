#!/bin/bash



m_backup(){

	echo "function m_backup"

	local option[1]="backup wp site"
	local option[2]="backup mysql"
	local option[3]="return back"

	local PS3="Select action: "
	select var in "${option[@]}"
	do
		case $REPLY in
			1)
				echo "backup wp site"
				backup_wp_site
				;;
			2)
				echo "backup mysql"
				backup_mysql
				;;
			3)
				echo "return back"
				return
				;;
			*)
				echo "Unknown selection"
				;;
		esac
	done
	


} #m_backup





