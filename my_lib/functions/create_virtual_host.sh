#!/bin/bash


#function that create virtual host
create_virtual_host(){
	echo "function create_virtual_host"
	
	#output hosts
	echo
	ls /etc/apache2/sites-available
	echo

	#input site name
	read -p "Input site name /var/www/[site_name]: " site_name

	#global variables
	site_path="/var/www/$site_name"
	echo "$site_name"
	echo "$site_path"


	#we should check whether direcotry exists
	if [ -d "$site_path" ]; then
		echo "direcotry $site_path exists"
		read -p "do you want to remove existing directory?
if you chose 'y' we will exchange that directory
with all existing files
if you chsoe 'n' we will stop working our sckript [y/n]: " answer
		if [ $answer == "n" ]; then
			echo "ok, we can't continue script and have finished working"
			return
		fi
	fi


	#create folder
	mkdir $site_path
	echo "directory has been created"

	#create demopage 
	touch $site_path/index.php
	#put text to index.php
	echo "<h1> the site <b>'$site_name'</b> has been created</h1>" | tee $site_path/index.php

	
	#create config files site.con.conf
	sudo touch "/etc/apache2/sites-available/$site_name.conf"



	#put data to this file
	echo "<VirtualHost *:80>
	ServerAdmin admin@$site_name
	ServerName $site_name
	ServerAlias www.$site_name
	
	<Directory $site_path>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Require all granted
	</Directory>
	
	DocumentRoot $site_path
	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

#with ssl
<VirtualHost *:443>
	ServerAdmin admin@$site_name
	ServerName $site_name
	ServerAlias www.$site_name

	<Directory $site_path>
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Require all granted
	</Directory>
	
	DocumentRoot $site_path


	ErrorLog \${APACHE_LOG_DIR}/error.log
	CustomLog \${APACHE_LOG_DIR}/access.log combined
	SSLEngine on
	SSLCertificateFile  /etc/ssl/certs/ssl-cert-snakeoil.pem
  SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

#	SSLCertificateFile /etc/apache2/ssl/kselax.ru.crt
#	SSLCertificateKeyFile /etc/apache2/ssl/kselax.ru.key
#	SSLCertificateChainFile /etc/apache2/ssl/kselax.ru.crt

	<FilesMatch \"\.(cgi|shtml|phtml|php)$\">
	  SSLOptions +StdEnvVars
  </FilesMatch>
  <Directory /usr/lib/cgi-bin>
	  SSLOptions +StdEnvVars
  </Directory>

</VirtualHost>
" | sudo tee "/etc/apache2/sites-available/$site_name.conf"



#enable site
sudo a2ensite "$site_name.conf"
#enable moderewrite
sudo a2enmod rewrite
#enable ssl
sudo a2enmod ssl
#restart apache2
sudo systemctl restart apache2.service



#add name to /etc/hosts
if [ "`grep -P "^\s*127\.0\.0\.1\s+\b$site_name\b\s*$" /etc/hosts`" != '' ] ; then
	echo "row exists"
else
	echo "add new row"
	sudo sed -i.bak "$ a\127.0.0.1 $site_name" /etc/hosts
fi

#disable by default two sites
#sudo a2dissite 000-default.conf
#sudo a2dissite default-ssl.conf
sudo systemctl restart apache2.service

echo
echo "the virtual host $site_name has been successfully created"


} #create_virtual_host




