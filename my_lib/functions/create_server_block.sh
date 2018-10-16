#!/bin/bash

create_server_block(){
  echo "function create_server_block"

  echo "
ls /etc/nginx/sites-available:"
  echo $(ls /etc/nginx/sites-available)
  echo "
Input a sitename:"
  read site_name
  echo "site_name = $site_name"


  # create a directory
  sudo mkdir -p /var/www/$site_name
  # change ownership
  sudo chown -R $USER:$USER /var/www/$site_name
  # create a server block file
  # sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$site_name
  # open file sudo vim /etc/nginx/sites-available/test.com
  # and put there data

  echo "server {
  listen 80;
  listen [::]:80;

  # ssl
<<<<<<< HEAD
  listen 443 ssl;
  listen [::]:443 ssl;
=======
  listen 443 ssl default_server;
  listen [::]:443 ssl default_server;
>>>>>>> a15bd1e2a76339d3d6fb305e98437340a4bd732c
  include snippets/snakeoil.conf;

  root /var/www/$site_name;

  index index.php index.html index.htm index.nginx-debian.html;

  server_name $site_name www.$site_name;

  location / {
    try_files \$uri \$uri/ =404;
  }

  location ~ \.php$ {
      include snippets/fastcgi-php.conf;
      fastcgi_pass unix:/run/php/php7.0-fpm.sock;
  }

  location ~ /\.ht {
      deny all;
  }
}" | sudo tee /etc/nginx/sites-available/$site_name

  # enable your server blog and restart nginx
  sudo ln -s /etc/nginx/sites-available/$site_name /etc/nginx/sites-enabled/
  sudo systemctl restart nginx

  # add test.com to the sudo vim /etc/hosts and create a file in vim /var/www/test.com/info.php with code
  echo "<?php
  phpinfo();
  ?>" | tee /var/www/$site_name/info.php

  #put text to index.php
  echo "<h1> the site <b>'$site_name'</b> has been created</h1>" | tee /var/www/$site_name/index.php

  # add name to the /etc/hosts
  if [ "`grep -P $site_name /etc/hosts`" == "" ];
  then
    sudo sed -i.bak "$ a\127.0.0.1 $site_name" /etc/hosts
  fi

  # and go to http://test.com/info.php you’ll see info about php
  echo "the site $site_name is created http://$site_name/info.php"
}
