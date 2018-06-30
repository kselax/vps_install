#!/bin/bash



install_roundcube(){

	echo "function install_roundcube"

	#show ls /etc/apache2/sites-available
	echo
	echo "ls /etc/apache2/sites-available"
	ls /etc/apache2/sites-available
	echo

	#input folder where we will place roundcube
	read -p "specify folder where you want to install roundcube /var/www/[your_path]: " answer

	local	site_name=$answer
	local site_path="/var/www/${site_name}"
	echo "site_path = $site_path"


	#check directory
	if [ -d "$site_path" ]; then

		echo "directory exists"
		read -p "do you want rewrite existing direcotyr $site_path?
All data will have been removed: [y/n]: " answer
		if [ "$answer" == "y" ]; then
			echo "yes, rewrite existing direcotory with its files"
			mkdir $site_path
		else
			echo "n, ok return to menu"
			return
		fi

	else

		echo "direcotyr doesn't exist"
		mkdir "$site_path"

	fi



	#install all needed libs for run roundcube
	sudo apt-get install -y php5.6-xml php5.6-mbstring php5.6-intl php5.6-zip php-pear zip unzip git composer
	#set up date.timezone ="Europe/Moscow" in php.ini
	sudo sed -ri.bak "s/^\s*;?(\s*date.timezone\s*=\s*).*\s*$/\1 \"Europe\/Moscow\"/" /etc/php/5.6/apache2/php.ini


	#dounload and untar roundcube from this link
	#https://github.com/roundcube/roundcubemail/releases/download/1.3.6/roundcubemail-1.3.6-complete.tar.gz

	URL="https://github.com/roundcube/roundcubemail/releases/download/1.3.6/roundcubemail-1.3.6-complete.tar.gz"

	local current_path=`pwd`

	cd $site_path
	#curl -O https://wordpress.org/latest.tar.gz
	curl -O -L $URL
	#curl -O -L "https://github.com/roundcube/roundcubemail/releases/download/1.3.6/roundcubemail-1.3.6-complete.tar.gz"
	#unzip wordpress roundcubemail-1.3.6-complete.tar.gz
	tar -zxf "roundcubemail-1.3.6-complete.tar.gz"
	#go to wordpress
	cd "roundcubemail-1.3.6"
	#copy files to parent directory
	rsync -av . ..
	#go to parent directory
	cd ..
	#remove wordpress and latest.tar.gz
	rm "roundcubemail-1.3.6-complete.tar.gz"
	rm -r "roundcubemail-1.3.6"


	#make directory writtable
	#ar/www/kselax.ru/roundcube/temp/
	#and
	#/var/www/kselax.ru/roundcube/logs/
	sudo chown $USER:$USER "$site_path/temp"
	sudo chown $USER:$USER "$site_path/logs"




	#input user data for MySQL
	echo "create file in $site_name/config/config.inc.php"

	answer="n"
	while [ "$answer" != "y" ]
	do

		#input db_user
		#read -p "input db_name: " db_name
		#read -p "input db_user: " db_user
		read -p "Input db_password for mysql database roundcube lenth at least 6 symbols: " db_pass
		local db_name="roundcube"
		local db_user="roundcube"

		echo
		echo "your db name = $db_name"
		echo "your db_user = $db_user"
		echo "your db_password = $db_pass"
		read -p "all right? [y/n]: " answer
	done

	# get debian credentials
	h_get_mysql_credentials
	echo "mysql_debian_user=$mysql_debian_user"
	echo "mysql-debian_pass=$mysql_debian_pass"

	#create database in MySQL
	mysql -u"$mysql_debian_user" -p"$mysql_debian_pass"  <<MYSQL_SCRIPT
show databases;
SET GLOBAL validate_password_length = 6;
SET GLOBAL validate_password_number_count = 0;
SET GLOBAL validate_password_mixed_case_count = 0;
SET GLOBAL validate_password_special_char_count = 0;
CREATE DATABASE IF NOT EXISTS $db_name;
CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
ALTER USER '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
show databases;
MYSQL_SCRIPT



	#create create file config/config.inc.php
	echo "<?php

/* Local configuration for Roundcube Webmail */

// ----------------------------------
// SQL DATABASE
// ----------------------------------
// Database connection string (DSN) for read+write operations
// Format (compatible with PEAR MDB2): db_provider://user:password@host/database
// Currently supported db_providers: mysql, pgsql, sqlite, mssql, sqlsrv, oracle
// For examples see http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
// NOTE: for SQLite use absolute path (Linux): 'sqlite:////full/path/to/sqlite.db?mode=0646'
//       or (Windows): 'sqlite:///C:/full/path/to/sqlite.db'
\$config['db_dsnw'] = 'mysql://$db_user:$db_pass@localhost/$db_name';

// ----------------------------------
// IMAP
// ----------------------------------
// The IMAP host chosen to perform the log-in.
// Leave blank to show a textbox at login, give a list of hosts
// to display a pulldown menu or set one host as string.
// To use SSL/TLS connection, enter hostname with prefix ssl:// or tls://
// Supported replacement variables:
// %n - hostname (\$_SERVER['SERVER_NAME'])
// %t - hostname without the first part
// %d - domain (http hostname \$_SERVER['HTTP_HOST'] without the first part)
// %s - domain name after the '@' from e-mail address provided at login screen
// For example %n = mail.domain.tld, %t = domain.tld
// WARNING: After hostname change update of mail_host column in users table is
//          required to match old user data records with the new host.
\$config['default_host'] = 'localhost';

// provide an URL where a user can get support for this Roundcube installation
// PLEASE DO NOT LINK TO THE ROUNDCUBE.NET WEBSITE HERE!
\$config['support_url'] = '';

// This key is used for encrypting purposes, like storing of imap password
// in the session. For historical reasons it's called DES_key, but it's used
// with any configured cipher_method (see below).
\$config['des_key'] = '6ob39aPrAk4gbLbRrQ6aLd1m';

// ----------------------------------
// PLUGINS
// ----------------------------------
// List of active plugins (in plugins/ directory)
\$config['plugins'] = array();
\$config['enable_installer'] = true;

" | tee config/config.inc.php

	echo
	echo "remove javascript-common"
	sudo apt-get -y remove javascript-common

	#restart apache2
	sudo systemctl restart apache2.service

	echo
	echo "pwd now:"
	cd $current_path
	pwd
	echo

	#disable installer option
	answer="n"
	while [ "${answer}" != "y" ]
	do
		echo "for initialize database go to this url
https://${site_name}/installer/index.php?_step=3o"
		read -p  "did you check your installer and we can disable it rihgt now? [y/n]: " answer
	done

	sed -ri.bak 's/^(\s*\$config\['\''enable_installer'\''\]\s*=\s*).+\s*$/\1false;/' ${site_path}/config/config.inc.php

	echo
	echo "go to roundcube https://${site_name}"
	echo
	echo "roundcube has been successfuly installed"



} #install_roundcube
