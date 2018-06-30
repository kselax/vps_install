#!/bin/bash


remove_apache2(){
	echo "function remove_apache2"
	
	#stop apache2
	sudo systemctl stop apache2.service
	#remove packages
	sudo apt-get -y purge apache2
	sudo apt-get -y purge apache2*
	
	#remove directory
	sudo rm -r /etc/apache2

	sudo apt-get -y autoremove
	sudo apt-get -y autoclean


	echo
	echo "Apache2 has been successfuly removed"
}
