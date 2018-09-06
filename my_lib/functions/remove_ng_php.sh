#!/bin/bash

remove_ng_php(){
  echo "function remove_ng_php"

  sudo apt-get -y purge *php*


  # remove from the /etc/nginx/sites-available/default
  if [ "`grep -P "###php-code###" /etc/nginx/sites-available/default`" != "" ]; then
    echo "==remove php from the /etc/nginx/sites-available/default==";
    sudo sed -ri.bak ':a;N;$!ba s/###php-code###.*?###php-code###//g' /etc/nginx/sites-available/default
  fi

  #restart apache2
	sudo systemctl restart nginx.service

	sudo apt-get -y autoremove
	sudo apt-get -y autoclean
  
	echo
	echo "php has been successfuly removed"
}
