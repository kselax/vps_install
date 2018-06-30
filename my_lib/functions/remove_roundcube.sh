#!/bin/bash



remove_roundcube(){

	echo "function remove_roundcube"

	echo "Do you want to remove roundcube? [y/n]: "
	read answer

	if [ "${answer}" != "y" ]; then
		echo "return back"
		return
	fi

	answer="n"
	while [ "${answer}" != "y" ]; do

		#show ls /etc/apache2/sites-available
		echo
		echo "ls /etc/apache2/sites-available"
		ls /etc/apache2/sites-available
		echo

		read -p "Input direcotry where placed roundcube /var/www/[your_directory]: " site_name
		echo "site_name=${site_name}"
		site_path=/var/www/${site_name}
		echo "site_path=${site_path}"
		read -p "use this data? [y/n]: " answer
	done


	#remove folder
	sudo rm -r ${site_path}


	# remove user and database
	echo
	echo "do you want to remove roundcube user and roundcube database from MySQL?"
	read -p "[y/n]: " answer

	if [ "$answer" == "y" ]; then

		# get debian credentials
		h_get_mysql_credentials
		echo "mysql_debian_user=$mysql_debian_user"
		echo "mysql-debian_pass=$mysql_debian_pass"

		# remove database
		mysql -u"$mysql_debian_user" -p"$mysql_debian_pass" <<MYSQL_SCRIPT
show databases;
DROP DATABASE IF EXISTS roundcube;
DROP USER IF EXISTS 'roundcube'@'localhost';
MYSQL_SCRIPT
	fi

	echo
	echo "Roundcube has been successfully removed"


} #remove_roundcube
