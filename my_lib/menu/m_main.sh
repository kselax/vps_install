#!/bin/bash




m_main(){

	echo "function m_main"
	local option[1]="Update system"
	local option[2]="Apache2"
	local option[3]="MySQL"
	local option[4]="php"
	local option[5]="phpMyAdmin"
	local option[6]="NVM(node version manager)"
	local option[7]="Create/remove virtual hosts"
	local option[8]="remove apps"
	local option[9]="mail server"
	local option[10]="install ssh key"
	local option[11]="install wordpress"
	local option[12]="backup"
	local option[13]="install let's encrypt"
	local option[14]="add/remove swap"
	local option[15]="Install desktop apps"
	local option[16]="quit"
	#echo "${option[@]}"

	echo "###################################"
	echo "#### Script for Installing VPS ####"
	echo "###################################"

	local PS3="Select app: "
	select var in "${option[@]}"
	do
	#	echo "$REPLY"
	#	echo "$var"
		case $REPLY in
		1)
			echo "Update system"
			update_system
			;;
		2)
			echo "Install Aapche2 "
			install_apache2
			;;
		3)
			echo "Install MySQL"
			install_mysql
			;;
		4)
			echo "Install php"
			install_php
			;;
		5)
			echo "Install phpMyAdmin"
			install_phpmyadmin
			;;
		6)
			echo "Install NVM(node version manager)"
			install_nvm
			;;
		7)
			echo "Create/remove virtual hosts"
			m_create_remove_virtual_hosts
			;;
		8)
			echo "Remove apps"
			m_remove_apps
			;;
		9)
			echo "mail server"
			m_mail_server
			;;
		10)
			echo "install ssh key"
			install_ssh_key
			;;
		11)
			echo "install wordpress"
			install_wordpress
			;;
		12)
			echo "backup"
			m_backup
			;;
		13)
			echo "install_lets_encrypt"
			install_lets_encrypt
			;;
		14)
			echo "add/remove swap"
			add_remove_swap
			;;
		15)
			echo "Install desktop apps"
			m_install_desktop_apps
			;;
		16)
			echo "return back"
			return;
			;;
		*)
			echo "Select option from list"
			;;
		esac
	done

} #m_main
