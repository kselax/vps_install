#!/bin/bash

remove_nginx(){
  echo "function remove_nginx"
  sudo systemctl stop nginx.service
  sudo apt-get -y purge *nginx*
  sudo apt-get -y autoremove
	sudo apt-get -y autoclean
}
