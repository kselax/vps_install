#!/bin/bash

install_nginx(){
  echo "function install_nginx"

  sudo apt-get -y update
  sudo apt-get -y install nginx

  # adjust a firewall
  sudo ufw allow 'Nginx HTTP'
  sudo ufw status

  echo "nginx has been installed successfully!"
}
