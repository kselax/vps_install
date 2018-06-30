#!/bin/bash




remove_postfix(){

	echo "function remove_postfix"

	#close 587 port
	sudo ufw deny "Postfix Submission" 
	#close 25 port
	sudo ufw deny "Postfix"
	#see ufw status
	sudo ufw status

	
	#stop postfix
	sudo systemctl stop postfix.service
	#remove packages
	sudo apt-get -y purge postfix mailutils

	sudo apt-get -y autoremove
	sudo apt-get -y autoclean

	echo
	echo "postfix has been removed successfully"

} #remove_postfix




