#!/bin/bash

install_ng_mysql(){
  echo "function install_ng_mysql"
  sudo apt-get -y install mysql-server
  # install a security plagin
  mysql_secure_installation
}
