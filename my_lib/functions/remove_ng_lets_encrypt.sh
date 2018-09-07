#!/bin/bash

remove_ng_lets_encrypt(){
  echo "function remove_ng_lets_encrypt"

  sudo add-apt-repository -y --remove ppa:certbot/certbot
  sudo apt-get -y purge *python-certbot-nginx*

  echo "the sertbot has been installed
to obtaine the sertificate input
sudo certbot --nginx -d example.com -d www.example.com"
}
