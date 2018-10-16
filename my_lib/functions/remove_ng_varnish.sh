#!/bin/bash

remove_ng_varnish(){
  echo "function remove_ng_varnish"
  sudo systemctl stop varnish.service
  sudo apt-get -y purge *varnish*
  sudo apt-get -y autoremove
	sudo apt-get -y autoclean
}
