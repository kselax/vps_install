#!/bin/bash


remove_mysql(){
	echo "function remove_mysql"

	#stop mysql.service
	sudo systemctl stop mysql.service

	#remove packages
	sudo apt-get -y purge mysql-server
	sudo apt-get -y purge mysql*
	sudo apt-get --yes autoremove --purge
	sudo apt-get autoclean
	sudo deluser --remove-home mysql
	sudo delgroup mysql
	sudo rm -rf /etc/apparmor.d/abstractions/mysql /etc/apparmor.d/cache/usr.sbin.mysqld /etc/mysql /var/lib/mysql /var/log/mysql* /var/log/upstart/mysql.log* /var/run/mysqld
	updatedb
	sudo rm -r /usr/bin/mysql
	sudo apt-get autoremove
	sudo apt-get autoclean
	
	#restart apache2
	sudo systemctl restart apache2.service

	echo
	echo "mysql has been successfully removed"

} #remove_mysql



