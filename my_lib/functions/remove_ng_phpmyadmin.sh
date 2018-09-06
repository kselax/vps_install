#!/bin/bash

remove_ng_phpmyadmin(){
  echo "function remove_ng_phpmyadmin"

  sudo apt-get -y purge phpmyadmin
	sudo apt-get purge -y phpmyadmin*

	sudo systemctl restart nginx.service

  # remove from /etc/nginx/sites-available/default
  if [ "`grep -P "###phpmyadmin-code###" /etc/nginx/sites-available/default`" != "" ];
  then

    sudo sed -ri ':a;N;$!ba s/###phpmyadmin-code###.*?###phpmyadmin-code###//' /etc/nginx/sites-available/default
    sudo systemctl restart nginx
  fi


	echo
	echo "phpMyAdmin has been successfully removed"
}
