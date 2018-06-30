#!/bin/bash


remove_phpmyadmin(){
	echo "function remove_phpmyadmin"

	sudo apt-get -y purge phpmyadmin
	sudo apt-get purge -y phpmyadmin*

	sudo systemctl restart apache2.service

	echo
	echo "phpMyAdmin has been successfully removed"

} #remove_phpmyadmin




