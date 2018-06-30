#!/bin/bash

update_system(){
	echo "function update_sytem"

	# update ubuntu
	sudo apt-get -y update
	# upgrade ubuntu
	sudo apt-get -y upgrade

	# before installing aplications
	# we should install needed applications

	sudo apt-get -y install curl
	sudo apt-get -y install ufw
	sudo apt-get -y install ssh
	sudo apt-get -y install htop
	sudo apt-get -y install host
	sudo apt-get -y install telnet
	sudo apt-get -y install dos2unix

	# it needs for apt-get
	sudo apt-get -y install software-properties-common





###################################################
#### install .vimrc
###################################################
	echo "
######################################
#### install .vimrc
######################################
"
	data="
\"===vimrc===
\"set number panels (by default it wasn't set)
set number

\"set tab to 2 character (by default was 8)
set tabstop=2

\"this turn on autoindentation
set autoindent

\"it will indentation when you press shift + >>/<<
set shiftwidth=2

\"set status, it will show pannel in bottom
set laststatus=2

ab imrc Internationa Materials Research Center

\"colorsheme
\"colorscheme desert
\"===vimrc==="

	if [ "$( grep '\"===vimrc===' $HOME/.vimrc)" == "" ]; then
		echo "#######################################"
		echo "$data" | tee -a "$HOME"/.vimrc
		echo "#######################################"
	else
		echo "file '$HOME/.vimrc' had already been installed"
	fi

	if [ "$( sudo grep '\"===vimrc===' /root/.vimrc)" == "" ]; then
		echo "#######################################"
		echo "$data" | sudo tee -a /root/.vimrc
		echo "#######################################"
	else
		echo "file '/root/.vimrc' has already been installed"
	fi

} # update_system
