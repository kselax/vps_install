#!/bin/bash



install_squirrelmail(){

	echo "function install_squirrelmail"

	#input folder where we will place roundcube
	read -p "specify folder where you want to install squirrelmail /var/www/[your_path]: " site_name

	local site_path="/var/www/$site_name"
	echo "site_path = $site_path"


	#check directory
	if [ -d "$site_path" ]; then
		
		echo "directory exists"
		read -p "do you want rewrite existing directory $site_path? All data will have been removed: [y/n]: " answer
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
	


	#install all needed dependencies, php libs, etc



	#dounload and untar roundcube from this link
	#https://github.com/roundcube/roundcubemail/releases/download/1.3.6/roundcubemail-1.3.6-complete.tar.gz

	local URL="https://squirrelmail.org/countdl.php?fileurl=http%3A%2F%2Fprdownloads.sourceforge.net%2Fsquirrelmail%2Fsquirrelmail-webmail-1.4.22.tar.gz"

	#save current directory
	local cur_dir="`pwd`"

	cd $site_path
	#curl -O https://wordpress.org/latest.tar.gz
	curl -O -L $URL
	
	#curl -O -L "https://github.com/roundcube/roundcubemail/releases/download/1.3.6/roundcubemail-1.3.6-complete.tar.gz"
	#unzip wordpress roundcubemail-1.3.6-complete.tar.gz
	tar -zxvf "countdl.php?fileurl=http%3A%2F%2Fprdownloads.sourceforge.net%2Fsquirrelmail%2Fsquirrelmail-webmail-1.4.22.tar.gz" 
	

	#go to wordpress
	cd "squirrelmail-webmail-1.4.22"
	#copy files to parent directory
	rsync -av . ..
	#go to parent directory 
	cd ..
	#remove wordpress and latest.tar.gz
	rm "countdl.php?fileurl=http%3A%2F%2Fprdownloads.sourceforge.net%2Fsquirrelmail%2Fsquirrelmail-webmail-1.4.22.tar.gz"
	rm -r "squirrelmail-webmail-1.4.22"


	#ERROR: Data dir (/var/local/squirrelmail/data/) does not exist!
	#create directory and put owner our curent user
	sudo mkdir -p /var/local/squirrelmail/data/
	sudo chown $USER:$USER /var/local/squirrelmail/data/
	#create this folder /var/local/squirrelmail/attach/
	sudo mkdir -p /var/local/squirrelmail/attach/
	sudo chown $USER:$USER /var/local/squirrelmail/attach/ 
	#allow shorttags in php short_open_tag=off
	#file /etc/php/5.6/apache2/php.ini
	sudo sed -ri.bak 's/^(\s*;?\s*short_open_tag\s*=\s*).+(\s*)$/[&]\1On\2/' /etc/php/5.6/apache2/php.ini

	#restart apache2
	sudo systemctl restart apache2


	
	#add config file to /var/www/kselax.ru/roundcube/config/
	pwd
	echo "cur_dir=$cur_dir"
	cd "$cur_dir"
	pwd
	cp my_lib/files/squirrelmail/config.php "$site_path/config"
	
	echo
	echo "###############################"
	echo "- Browse to https://${site_name}/src/configtest.php
Log in https://${site_name}
to test your configuration for common errors."
	echo "###############################"

	echo 
	echo "squirrelmail has been successfuly installed"

} #install_squirrelmail





