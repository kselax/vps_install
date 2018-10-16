#!/bin/bash

install_ng_lets_encript(){
  echo "function install_ng_lets_encript"

  sudo add-apt-repository -y ppa:certbot/certbot
  sudo apt-get -y update
  sudo apt-get -y install python-certbot-nginx

  echo "the sertbot has been installed
to obtaine the sertificate input
sudo certbot --nginx -d example.com -d www.example.com"
}
