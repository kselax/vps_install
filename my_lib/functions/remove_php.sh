#!/bin/bash


remove_php(){
	echo "function remove_php"

	sudo apt-get -y purge php*
	#restart apache2
	sudo systemctl restart apache2.service
	
	sudo apt-get -y autoremove
	sudo apt-get -y autoclean


	echo 
	echo "php has been successfuly removed"

} #remove_php





