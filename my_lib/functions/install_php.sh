#!/bin/bash

install_php(){
	echo "function install_php"
	#at first install default debian package php 
	#it has current php version 7.0
	#remove ppa
	sudo add-apt-repository -y --remove ppa:ondrej/php
	sudo apt-get -y update
	
	#install php
	sudo apt-get -y install php libapache2-mod-php php-mcrypt php-mysql


	#//put index.php first in this file
	#sudo nano /etc/apache2/mods-enabled/dir.conf
	sudo sed -ri.bak 's/index.pl index.php index.xhtml/index.pl index.xhtml/' /etc/apache2/mods-enabled/dir.conf
	sudo sed -ri.bak 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf


	#restart apache2.service
	sudo systemctl restart apache2.service

	
	###################################################
	### install php5.6 from not official repository ###
	###################################################
	sudo add-apt-repository -y ppa:ondrej/php
	sudo apt-get -y update

	sudo apt-get -y install php7.0 php5.6 php5.6-mysql php-gettext php5.6-mbstring php-mbstring php7.0-mbstring php-xdebug libapache2-mod-php5.6 libapache2-mod-php7.0 php7.0-zip 

	# my addition
	sudo apt-get -y install php5-dom
	# for installing zip archive
	sudo apt-get install php5.6-zip

	# set up php5.6
	sudo a2dismod php7.0  
	sudo a2enmod php5.6  
	sudo service apache2 restart 
	sudo update-alternatives --set php /usr/bin/php5.6


	# edit php.ini
	# on error log
	if [ "`grep -P \";#===error_log===#\" /etc/php/5.6/apache2/php.ini`" == "" ]; then
		sudo sed -ri.bak 's/^;error_log\s*=\s*php_errors.log\s*$/&\n;#===error_log===#\nerror_log = \/var\/log\/apache2\/error.log\n;#===error_log===#/' /etc/php/5.6/apache2/php.ini
	fi

	#restart apache2
	sudo systemctl restart apache2.service

	
	#add test file to directory
	#if dirrectory exists /var/www/html put there file info.php with phpinfo() finction
	if [ -d "/var/www/html" ]; then
		echo "<?php 
phpinfo();
?>" | tee /var/www/html/info.php
	fi


	#output php version
	php -v

	echo
	echo "php7.0 and php5.6 have been successfully installed"

} #install_php






