#!/bin/bash


#backup wordpress site and save to /var/backups
# /home/neo/vps_install/my_lib/single_scripts/wp_crontab_backup.sh wp.test2 /home/neo/backups

site_name=$1
site_path=/var/www/"$site_name"
save_path=$2


echo "site_name=$site_name"
echo "site_path=$site_path"
echo "save_path=$save_path"



#get credentials for mysql
debian_cnf=$(sudo cat /etc/mysql/debian.cnf)
mysql_debian_user=$(sudo sed -rn '/user/{s/user\s*=\s*(.*)\s*$/\1/p;q}' /etc/mysql/debian.cnf)
mysql_debian_pass=$(sudo sed -rn '/password/{s/password\s*=\s*(.*)\s*$/\1/p;q}' /etc/mysql/debian.cnf)
echo "$debian_cnf"
echo "mysql_debian_user=$mysql_debian_user"
echo "mysql-debian_pass=$mysql_debian_pass"



#check folder /var/backups
if [ ! -d "$save_path" ]; then
  echo "directory $save_path doesn't exist, create folder"
  sudo mkdir -p $save_path
fi

cd $save_path

#get db_name
db_name=$(sed -rn "s/^.*'DB_NAME'.+'(.+)'.*$/\1/p" "$site_path"/wp-config.php)
echo 
backup_name=$save_path/$site_name.$(date +%Y-%m-%d.%H:%M:%S).tar.gz

mysqldump -u"$mysql_debian_user" -p"$mysql_debian_pass" "$db_name"  > $site_path/$site_name.sql
tar -czvf "$backup_name" "$site_path"

#remove sql from site folder
rm $site_path/$site_name.sql


echo 
echo "check this folder $backup_name"
echo
echo "Backup has been created successfully"


