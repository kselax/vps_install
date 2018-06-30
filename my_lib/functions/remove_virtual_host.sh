#!/bin/bash


remove_virtual_host(){
	echo "function remove_virtual_host"

	#output hosts
	echo
	ls /etc/apache2/sites-available
	echo


	#input site_name	
	read -p "Input sitename to remove from /var/www/[site_name]: " site_name

	site_path="/var/www/$site_name"
	echo "$site_name"
	echo "$site_path"

	#remove folder with all files from 
	sudo rm -r $site_path

	#disable site
	sudo a2dissite "$site_name.conf"
	#remove config file 
	sudo rm "/etc/apache2/sites-available/$site_name.conf"
	#restart apache2
	sudo systemctl restart apache2.service

	#remove from /etc/hosts line with sitename
	if [ "`grep -P "^\s*127\.0\.0\.1\s+\b$site_name\b\s*$" /etc/hosts`" != '' ]; then
		echo "row has been found"
		sudo sed -ri.bak "s/^\s*127\.0\.0\.1\s+\b$site_name\b\s*$//" /etc/hosts
	else
		echo "row has not been found"
	fi

	
	echo
	echo "site $site_name has been successfully removed"


} #remove_virtual_host




