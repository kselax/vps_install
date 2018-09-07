#!/bin/bash

install_ng_varnish(){
  echo "function install_ng_varnish"

  # 1. add a new repository link
  sudo apt-get update
  sudo apt-get install curl gnupg apt-transport-https
  curl -L https://packagecloud.io/varnishcache/varnish60/gpgkey | sudo apt-key add -
  # create file sudo vim /etc/apt/sources.list.d/varnishcache_varnish60.list and put there
  sudo mkdir -p /etc/apt/sources.list.d/
  echo "deb https://packagecloud.io/varnishcache/varnish60/ubuntu xenial main
deb-src https://packagecloud.io/varnishcache/varnish60/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/varnishcache_varnish60.list

  # 2. install varnish
  sudo apt-get update
  sudo apt-get install varnish

  # create files
  sudo mkdir -p /etc/systemd/system/varnish.service.d/
  sudo touch /etc/systemd/system/varnish.service.d/customexec.conf
  # open the file sudo vim /etc/systemd/system/varnish.service.d/customexec.conf
  # and put there this rows
  echo "[Service]
ExecStart=
ExecStart=/usr/sbin/varnishd -a :80 -T localhost:6082 -f /etc/varnish/default.vcl -S /etc/varnish/secret -s default,256m" | sudo tee /etc/systemd/system/varnish.service.d/customexec.conf
  # then restart
  sudo systemctl daemon-reload

  # output the version
  echo
  varnishd -V
  echo

  # varnish status
  echo sudo systemctl status varnish


}
# install_ng_varnish
