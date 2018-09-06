#!/bin/bash

install_ng_php(){
  echo "function install_ng_php"

  sudo apt-get -y install php-fpm php-mysql
  # go to php.ini sudo vim /etc/php/7.0/fpm/php.ini
  # and uncommente the line (change meaning to 0)
  # cgi.fix_pathinfo=0
  sudo sed -ri.bak s/\;?cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g /etc/php/7.0/fpm/php.ini

  # edit nginx to work with php

  # index index.php index.html index.htm index.nginx-debian.html;
  sudo sed -ri.bak 's/index index.html/index index.php index.html/g' /etc/nginx/sites-available/default

  # server_name server_domain_or_IP;
  sudo sed -ri.bak 's/^\s*server_name.*$/server_name '"`hostname -I`"';/g' /etc/nginx/sites-available/default

  # sudo vim /etc/nginx/sites-available/default
  if [ "`grep -P "###php-code###" /etc/nginx/sites-available/default`" == "" ]; then
    echo "==add php to /etc/nginx/sites-available/default==";
    sudo sed -ri.bak ':a;N;$!ba s/\n\s*location \/\s*\{[^}]*?}/&\n###php-code###\nlocation ~ \\.php\$ {\n\tinclude snippets\/fastcgi-php.conf;\n\tfastcgi_pass unix:\/run\/php\/php7.0-fpm.sock;\n}\n\nlocation ~ \/\\.ht {\n\tdeny all;\n} \n###php-code### /g' /etc/nginx/sites-available/default
  fi

  # create /var/www/html/info.php file
  echo "<?php
phpinfo();
?>" > /var/www/html/info.php
  # restart php7.0-fpm
  sudo systemctl restart php7.0-fpm
  # restart nginx
  sudo systemctl restart nginx
}
