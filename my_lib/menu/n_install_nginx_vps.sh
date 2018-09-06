#!/bin/bash



m_install_nginx_vps(){

	echo "function m_remove_mail_apps"
	local option[1]="Install nginx"
	local option[2]="Install ng MySQL"
	local option[3]="Install ng php"
	local option[4]="Install ng PhpMyAdmin"
	local option[5]="remove ng apps"
	local option[6]="Install ng varnish"
	local option[7]="Install ng lets encript"
	local option[8]="Create Server Blocks"
	local option[9]="return back"

	local PS3="Select action: "

	select var in "${option[@]}"
	do
		case $REPLY in
			1)
				echo "Install nginx"
				install_nginx
				;;
			2)
				echo "Install ng MySQL"
				install_ng_mysql
				;;
			3)
				echo "Install ng php"
				install_ng_php
				;;
			4)
				echo "Install ng PhpMyAdmin"
				install_ng_phpmyadmin
				;;
			5)
				echo "remove ng apps"
				m_remove_ng_apps
				;;
			6)
				echo "Install ng varnish"
				install_ng_varnish
				;;
			7)
				echo "Install ng lets encript"
				install_ng_lets_encript
				;;
			8)
				echo "Create Server Blocks"
				m_create_server_blocks
				;;
			9)
				echo "return back"
				return
				;;
			*)
				echo "unknown command"
				;;
		esac
	done

} #m_remove_mail_apps
