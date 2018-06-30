#!/bin/bash

install_mysql(){
	echo "function install mysql"
	
	#install mysql
	sudo apt-get -y install mysql-server
	#turn on secure mysql plugin
	mysql_secure_installation

	
	echo
	echo "mysql has been successfuly installed"
}
