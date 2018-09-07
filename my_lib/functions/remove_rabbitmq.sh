#!/bin/bash

remove_rabbitmq(){
  echo "function remove_rabbitmq"

  sudo systemctl stop rabbitmq-server

  sudo apt-get -y purge *erlang-nox*
  sudo apt-get -y purge *rabbitmq-server*

  sudo rm /etc/apt/sources.list.d/bintray.rabbitmq.list
  sudo rm /etc/apt/sources.list.d/bintray.erlang.list
  sudo rm /etc/apt/preferences.d/erlang

  sudo apt-get -y autoremove
  sudo apt-get -y autoclean

  # to start rabbitmq-server type
  # sudo systemctl start rabbitmq-server
  # sudo systemctl status rabbitmq-server
}
