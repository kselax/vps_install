#!/bin/bash


# include mysql
# h_get_mysql_credentials
# echo "mysql_debian_user=$mysql_debian_user"
# echo "mysql-debian_pass=$mysql_debian_pass"



h_get_mysql_credentials(){
  #get credentials for mysql
  debian_cnf=$(sudo cat /etc/mysql/debian.cnf)
  mysql_debian_user=$(sudo sed -rn '/user/{s/user\s*=\s*(.*)\s*$/\1/p;q}' /etc/mysql/debian.cnf)
  mysql_debian_pass=$(sudo sed -rn '/password/{s/password\s*=\s*(.*)\s*$/\1/p;q}' /etc/mysql/debian.cnf)
  # echo "$debian_cnf"
} #h_get_mysql_credentials
