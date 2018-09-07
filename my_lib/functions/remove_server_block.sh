#!/bin/bash

remove_server_block(){
  echo "function remove_server_block"

  #output hosts
	echo
	ls /etc/nginx/sites-available
	echo


	# input site_name
	read -p "Input sitename to remove from /var/www/[site_name]: " site_name

	# remove folder with all files from
	sudo rm -r /var/www/$site_name

	# remove symbolic link from /etc/nginx/sites-enabled/
  sudo rm /etc/nginx/sites-enabled/$site_name
	# remove config file
	sudo rm /etc/nginx/sites-available/$site_name
	# restart nginx
	sudo systemctl restart nginx.service

	# remove from /etc/hosts line with sitename
	if [ "`grep -P "^\s*127\.0\.0\.1\s+\b$site_name\b\s*$" /etc/hosts`" != '' ]; then
		echo "row has been found"
		sudo sed -ri.bak "s/^\s*127\.0\.0\.1\s+\b$site_name\b\s*$//" /etc/hosts
	else
		echo "row has not been found"
	fi


	echo
	echo "site $site_name has been successfully removed"
}
