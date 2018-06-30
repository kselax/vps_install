#!/bin/bash



install_apps(){

  echo "function install_apps"


  ###################################
  # install utilities
  ###################################

  sudo apt-get -y install htop
  sudo apt-get -y install curl
  sudo apt-get -y install ssh
  sudo apt-get -y install ufw


  ###################################
  # install from official repository
  ###################################
	sudo apt-get -y install vim

  sudo apt-get -y install keepassx

  sudo apt-get -y install terminator

  sudo apt-get -y install filezilla

  sudo apt-get -y install unity-tweak-tool

  sudo apt-get -y install shutter

  sudo apt-get -y install diodon

  sudo apt-get -y install goldendict

  sudo apt-get -y install dia

  sudo apt-get -y install gimp

  sudo apt-get -y install inkscape

  sudo apt-get -y install kdenlive

  # ror reading epub files
  sudo apt-get -y install calibre

  # for reading .chm (in menu it wil have a name ebook reader)
  sudo apt-get -y install fbreader


  ##################################
  # install apps from snapd
  ##################################
  sudo apt-get -y install snapd

  sudo snap install atom --classic

  sudo snap install sublime-text --classic

  sudo snap install vscode --classic

  sudo snap install skype --classic

  sudo snap install obs-studio


} # install_apps
