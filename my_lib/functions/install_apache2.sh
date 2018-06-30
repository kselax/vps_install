#!/bin/bash

#function that instals apache2 to the server
install_apache2(){
	echo "function install_apache2"

	#install apache2
	sudo apt-get -y install apache2
	ip="`hostname -I`"


	#put Servername ip to file /etc/apache2/apache2.conf
	if [ "`grep -P \"^#?\s*ServerName\s+.+\s*$\" /etc/apache2/apache2.conf`" != "" ]; then
		echo "ServerName is found"
		sudo sed -ri.bak "s/^#?\s*ServerName\s+.+\s*$/ServerName $ip/" /etc/apache2/apache2.conf
	else
		echo "Servername isn't found"
		echo "ServerName $ip" | sudo tee -a /etc/apache2/apache2.conf
	fi


	#change www-data to current user
	sudo sed -ri.bak "s/^#?\s*export APACHE_RUN_USER=.*\s*$/export APACHE_RUN_USER=$USER/" /etc/apache2/envvars
	sudo sed -ri.bak "s/^#?\s*export APACHE_RUN_GROUP=.*\s*$/export APACHE_RUN_GROUP=$USER/" /etc/apache2/envvars


	#install permission on folder and set up to current user
	sudo find /var/www -type d -exec chmod 775 {} \;
	sudo find /var/www -type f -exec chmod 664 {} \;
	sudo chown -R $USER:$USER /var/www


	#enable moduls and default ssh site
	sudo a2ensite default-ssl.conf

	#enuble moduls
	sudo a2enmod ssl
	sudo a2enmod rewrite
	sudo a2enmod expires



	#restart apache2.service
	sudo systemctl restart apache2.service
	#enable ufw
	sudo ufw enable
	#alloa apache in ufw
	sudo ufw allow in "Apache Full"
	#show status ufw
	sudo ufw status



	echo
	echo "apache2 has been successfully installed"

} #install_apache2
