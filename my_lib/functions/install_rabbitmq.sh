#!/bin/bash

install_rabbitmq(){
  echo "function install_rabbitmq"

  # update the system
  sudo apt-get -y update
  sudo apt-get -y upgrade

  # add singing key
  sudo wget -O - 'https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc' | sudo apt-key add -


  # add to sudo vim /etc/apt/preferences.d/erlang
  echo "# /etc/apt/preferences.d/erlang
  Package: erlang*
  Pin: release o=Bintray
  Pin-Priority: 1000" | sudo tee /etc/apt/preferences.d/erlang

  # add to sudo vim /etc/apt/sources.list.d/bintray.erlang.list
  # deb https://dl.bintray.com/rabbitmq/debian xenial erlang
  echo "deb https://dl.bintray.com/rabbitmq/debian xenial erlang" | sudo tee /etc/apt/sources.list.d/bintray.erlang.list


  # add to sudo vim /etc/apt/sources.list.d/bintray.rabbitmq.list
  # deb https://dl.bintray.com/rabbitmq/debian xenial main
  echo "deb https://dl.bintray.com/rabbitmq/debian xenial main" | sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list


  # update and install apps
  sudo apt-get -y update
  sudo apt-get -y install erlang-nox
  sudo apt-get -y install rabbitmq-server

  echo
  echo "to test erlang type erl"
  echo

  # to start rabbitmq-server type
  sudo systemctl start rabbitmq-server
  sudo systemctl status rabbitmq-server

  sudo rabbitmq-plugins enable rabbitmq_management
  sudo chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/

  # set up a password
  sudo rabbitmqctl add_user adminmq adminmq
  sudo rabbitmqctl set_user_tags adminmq administrator
  sudo rabbitmqctl set_permissions -p / adminmq ".*" ".*" ".*"

  echo
  echo access http://localhost:15672, login and password are guest or http://`hostname -I`:15672, login and password are adminmq
}
