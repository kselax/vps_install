#!/bin/bash






install_wordpress(){

	echo "function install_wordpress"

	#variables
	local url="https://wordpress.org/latest.tar.gz"
	local cur_dir=$(pwd)


	local option[1]="Install a wordpress site"
	local option[2]="Remove a wordpress site"
	local option[3]="Make backup of a wordpress site"
	local option[4]="Install a wordpress site from a backup"
	local option[5]="return back"

	local PS3="Make your choice: "

	select var in "${option[@]}"
	do

		case $REPLY in
################################
### Install a wordpress site ###
################################
			1)
				echo "Install a wordpress site"
				echo
				# get debian credentials
				h_get_mysql_credentials
				echo "mysql_debian_user=$mysql_debian_user"
				echo "mysql-debian_pass=$mysql_debian_pass"


				#input sites in /var/www
				answer=""
				#site_path=/var/www/wp.test2
				#site_name=wp.test2
				#db_name=wp_test
				#db_user=wp_test
				#db_pass=ninja234
				while [ "$answer" != "y" ]
				do
					echo
					echo "/var/www/:"
					ls /var/www
					echo

					read -p "input site name /var/www/[site_name]: " site_name
					read -p "Input a db_name (don't use .): " db_name
					read -p "Input a db_user (don't use .): " db_user
					read -p "input a db_pass (at least 6 symbols): " db_pass
					site_path=/var/www/$site_name
					echo "site_name=$site_name"
					echo "site_path=$site_path"
					echo "db_name=$db_name"
					echo "db_user=$db_user"
					echo "db_pass=$db_pass"
					echo
					read -p "is everything right? [y/n]: " answer
				done

				echo
				echo "Start copy wordpress from $url"
				echo

				cd $site_path
				#curl -O https://wordpress.org/latest.tar.gz
				curl -O -L $url
				#unzip wordpress
				tar -zxf latest.tar.gz
				#go to wordpress
				cd wordpress
				#copy files to parent directory
				rsync -av . ..
				#go to parent directory
				cd ..
				#remove wordpress and latest.tar.gz
				rm latest.tar.gz
				rm -r wordpress

				echo
				echo "wordpress has been copied successfully"
				echo

				echo
				echo "start creating mysql database"
				echo

				#create database in MySQL
				#read -p "input a MySQL root password: " root_password
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

				echo
				echo "mysql has been created successfully"
				echo

				echo
				echo "start to create wp-config.php file"
				echo
				#convert file to unix
				dos2unix wp-config-sample.php
				wp_config_sample=$(cat wp-config-sample.php)

				echo "$wp_config_sample"
				solt=$(curl https://api.wordpress.org/secret-key/1.1/salt/)
				echo
				echo "solt=$solt"
				echo
				#escape /
				solt=$(echo "$solt" | sed -r 's/\//\\\//g')
				#escape &
				solt=$(echo "$solt" | sed -r 's/&/\\&/g')
				#escape '
				#solt=$(echo "$solt" | sed -r 's/'\''/'\''\\'\'''\''/g')
				#escape \n
				solt=$(echo "$solt" | sed -r ':a;N;$!ba;s/\n/\\n/g')
				echo
				echo "$solt"
				echo
				wp_config_sample=$(echo "$wp_config_sample" | sed -r ':a;N;$!ba;s/\n[^\n]*AUTH_KEY.*NONCE_SALT[^\n]*\n/\n\'"$solt"'\n/')
				#add database data
				wp_config_sample=$(echo "$wp_config_sample" | sed -r 's/^(.*DB_NAME.*'\'').*('\''.*)$/\1'"${db_name}"'\2/')
				wp_config_sample=$(echo "$wp_config_sample" | sed -r 's/^(.*DB_USER.*'\'').*('\''.*)$/\1'"${db_user}"'\2/')
				wp_config_sample=$(echo "$wp_config_sample" | sed -r 's/^(.*DB_PASSWORD.*'\'').*('\''.*)$/\n\1'"${db_pass}"'\2/')

				#create wp-config.php
				echo "$wp_config_sample" > wp-config.php

				echo
				echo "wp-config.php file has successfully been created"
				echo

				#set up current dir
				cd $cur_dir
				echo
				pwd
				echo
				echo "url http://$site_name"
				echo
				echo "wordpress has been installed successfully"

				;;
### Install a wordpress site ###

###############################
### Remove a wordpress site ###
###############################
			2)
				echo "Remove a wordpress site"
				echo

				# create a database
				h_get_mysql_credentials
				echo "mysql_debian_user=$mysql_debian_user"
				echo "mysql-debian_pass=$mysql_debian_pass"

				#input site name
				answer=""
				while [ "$answer" != "y" ]
				do
					echo
					echo "/var/www/:"
					ls /var/www
					echo

					read -p "input site name /var/www/[site_name]: " site_name
					site_path=/var/www/${site_name}

					echo "site_name=$site_name"
					echo "site_path=$site_path"
					echo
					read -p "is everyghin right? [y/n]: " answer

				done

				echo
				echo "get mysql data from wp-config.php"
				echo

				cd $site_path
				db_name=$(sed -rn "s/^.*'DB_NAME'.+'(.+)'.*$/\1/p" wp-config.php)
				db_user=$(sed -rn "s/^.*'DB_USER'.+'(.+)'.*$/\1/p" wp-config.php)
				db_pass=$(sed -rn "s/^.*'DB_PASSWORD'.+'(.+)'.*$/\1/p" wp-config.php)
				echo
				echo "db_name=$db_name"
				echo "db_user=$db_user"
				echo "db_pass=$db_pass"


					#remove mysql

				#read -p "Input your MySQL root password: " root_pass
				mysql -u"$mysql_debian_user" -p"$mysql_debian_pass" <<MYSQL_SCRIPT
show databases;
DROP DATABASE IF EXISTS ${db_name};
DROP USER IF EXISTS '${db_user}'@'localhost';
MYSQL_SCRIPT
				#remove files from directory

				rm -r "$site_path"
				mkdir "$site_path"
				cd "$cur_dir"

				echo
				echo "site '$site_name' has been removed successfully"
				;;
### Remove a wordpress site ###

#######################################
### Make backup of a wordpress site ###
#######################################
			3)
				echo "Make backup of a wordpress site"
				echo

				# get credentials
				h_get_mysql_credentials
				echo "mysql_debian_user=$mysql_debian_user"
				echo "mysql-debian_pass=$mysql_debian_pass"

				#input data
				answer=""
				while [ "$answer" != "y" ]
				do
					echo
					echo "/var/www/:"
					ls /var/www
					echo
					read -p "Input /var/www/[site_name]: " site_name
					site_path=/var/www/"$site_name"
					echo "site_name=${site_name}"
					echo "site_path=${site_path}"

					read -p "Is everything right? [y/n]: " answer
				done

				backup_folder=$HOME/backups
				#create folder $HOME/backups
				if [ ! -d "$backup_folder" ]; then
					echo "directory $backup_folder doesn't exist, create folder"
					mkdir $backup_folder
				fi

				###############

				# copy /var/www site to current folder
				rsync -a /var/www/"$site_name"/ site

				#create mysqldump.sql file
				db_name=$(sed -rn "s/^.*'DB_NAME'.+'(.+)'.*$/\1/p" "$site_path"/wp-config.php)
				sudo mysqldump -u"$mysql_debian_user" -p"$mysql_debian_pass" "$db_name"  > site/mysqldump.sql

				#make archive from site
				backup_name="$site_name".$(date +%Y-%m-%d.%H-%M-%S).tar.gz
				tar -czf "$(pwd)/$backup_name" "site"

				# move backup archive to backup_folder folder
				mv "$backup_name" "$backup_folder"

				# remove left garbage
				echo '$backup_name'
				#rm "$backup_name"
				rm -r site

				echo
				echo "Backup has successfully been created"

				;;
### Make backup of a wordpress site ###

##############################################
### Install a wordpress site from a backup ###
##############################################
			4)
				echo "Install a wordpress site from a backup"

				#initialization of all needed variables
				answer=""
				while [ "$answer" != "y" ]
				do
					read -p "Input path to tar archive with wp: " path_to_tar

					#check existance of path_to_tar
					if [ ! -f "$path_to_tar" ]; then
						echo "file '$path_to_tar' doesn't exists"
						continue;
					fi

					echo "ls /etc/apache2/sites-available"
					ls /etc/apache2/sites-available
					read -p "Input /var/www/[site_name]: " site_name

					read -p "
do not use 'dot' symbol!
Input db_name: " db_name
					read -p "
Do now use 'dot' symbol!
Input db_user: " db_user
					read -p "
lenth at least 6 symbols
Input db_pass: " db_pass

					#offer user to check all variables
					echo "path_to_tar=$path_to_tar"
					echo "site_name=$site_name"
					echo "db_name=$db_name"
					echo "db_user=$db_user"
					echo "db_pass=$db_pass"

					read -p "Do everything right? [y/n]: " answer
				done

				# echo "exit"
				# exit

				#dummy data
				# path_to_tar=/home/neo/backups/test.tar.gz
				# site_name="test"
				# db_name="test_name"
				# db_user="test_user"
				# db_pass="test_pass"

				# copy tar bar to current dirrectory
				rsync -a "$path_to_tar" "wp.tar.gz"

				# untare file
				tar -xzf wp.tar.gz

				# convert wp-config.php
				dos2unix site/wp-config.php

				# set up inputed credentials to site/wp-config.php
				sed -ri.bak "s/^(.+DB_NAME\s*'\s*,.*')(.+)('.*)$/\1${db_name}\3/" site/wp-config.php
				sed -ri.bak "s/^(.+DB_USER\s*'\s*,.*')(.+)('.*)$/\1${db_user}\3/" site/wp-config.php
				sed -ri.bak "s/^(.+DB_PASSWORD\s*'\s*,.*')(.+)('.*)$/\1${db_pass}\3/" site/wp-config.php

				# create a database
				h_get_mysql_credentials
				echo "mysql_debian_user=$mysql_debian_user"
				echo "mysql-debian_pass=$mysql_debian_pass"

				#read -p "input a MySQL root password: " root_password
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

				#import mysqldump
				mysql -u"$mysql_debian_user" -p"$mysql_debian_pass" "$db_name" < site/mysqldump.sql

				# remove site/mysqldump.sql
				rm site/mysqldump.sql

				# copy site to /var/www[site_name]
				rm -r /var/www/"$site_name"
				mv site/ /var/www/"$site_name/"

				#remove archive from current folder
				rm wp.tar.gz

				echo
				echo "Backup  has successfully been imported"
				;;
### Install a wordpress site from a backup ###

################################
### Return back to main menu ###
#########################	######
			5)
				echo
				echo "return back..."
				echo
				return
				;;
			*)
				echo
				echo "unknown input"
				;;
		esac

	done

} #install_wordpress

# echo "here we are"
# exit
