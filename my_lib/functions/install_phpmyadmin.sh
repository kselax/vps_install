#!/bin/bash

install_phpmyadmin(){
	echo "function install_phpmyadmin"
	


	#install phpmyadmin from officcial repository 
	sudo apt-get -y install phpmyadmin php-mbstring php-gettext
	#install additional libs
	sudo apt install -y  php5.6-mcrypt  
	sudo apt install -y php5.6-mbstring 
	sudo phpenmod mcrypt 
	sudo phpenmod mbstring 
	
	#change permission to config file
	sudo chown -R $USER:$USER /usr/share/phpmyadmin
	sudo chown -R $USER:$USER /var/lib/phpmyadmin
	sudo chown -R $USER:$USER /etc/phpmyadmin

	#restart apache2
	sudo systemctl restart apache2.service

	
	##############################
	### secure your phpmyadmin ###
	##############################
	
	#configure apache to allow .htaccess
	#in this file /etc/apache2/conf-available/phpmyadmin.conf
	#add to this file AllowOverride All within <Directory /usr/share/phpmyadmin>
	#AllowOverride All
	sudo sed -ri.bak '
	:a;
	N;
	$!ba
	s/(<Directory \/usr\/share\/phpmyadmin>.*DirectoryIndex index.php\s*\n)(\s*AllowOverride All\s*)*(\n\s+<IfModule mod_php.c>)/\n\1AllowOverride All\3\n/g
	' /etc/apache2/conf-available/phpmyadmin.conf
	#restart apache2
	sudo systemctl restart apache2.service

	#create an .htaccess file 
	sudo touch /usr/share/phpmyadmin/.htaccess
	#put theres text
	echo "AuthType Basic
AuthName \"Restricted Files\"
AuthUserFile /etc/phpmyadmin/.htpasswd
Require valid-user" | sudo tee /usr/share/phpmyadmin/.htaccess


	#sometimes it can't be removed automatically
	#remove javascript-common
	sudo apt-get remove -y javascript-common


	#create an .htpasswd file for authentication
	#set an additional package 
	sudo apt-get install -y  apache2-utils
	#creating password file
	read -p "input username for addtitional protection: " name
	sudo htpasswd -c /etc/phpmyadmin/.htpasswd "$name"

	
	echo
	echo "phMyAdmin has been successfully installed"

}




