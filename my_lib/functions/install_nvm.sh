#!/bin/bash

install_nvm(){
	echo "function install_nvm"

	#put down the nvm installation script
	curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh -o install_nvm.sh

	#run the script with bash
	bash install_nvm.sh
	#source the profile file
	source ~/.profile


	echo "for start using nvm you need reopen terminal"
	echo "you can open in new tab new terminal and follow command bellow"
	echo "set up needed node.js version"
	echo "//to find out versions node.js that are available" 
	echo "nvm ls-remote"
	echo "//you can install version by typing"
	echo "nvm install 6.0.0"
	echo "//tell nvm to use this version"
	echo "nvm use 6.0.0"
	echo "//check version by the shell by typing"
	echo "node -v"
	
	echo
	echo "nvm has been successfuly installed"
}





