#!/bin/bash

db_name="db_name"
db_user="db_user"
db_pass="password"
read -p "input root password " root_password
mysql -uroot -p"$root_password"  <<MYSQL_SCRIPT
show databases;
SET GLOBAL validate_password_length = 6;
SET GLOBAL validate_password_number_count = 0;
SET GLOBAL validate_password_mixed_case_count = 0;
SET GLOBAL validate_password_special_char_count = 0;
CREATE DATABASE IF NOT EXISTS $db_name;
CREATE USER IF NOT EXISTS '$db_user'@'localhost' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'localhost';
FLUSH PRIVILEGES;
show databases;
MYSQL_SCRIPT

echo
echo "the end"





