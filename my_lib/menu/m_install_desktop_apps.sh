#!/bin/bash




m_install_desktop_apps(){

	echo "function m_main"
	local option[1]="install apps (of/rep)"
  local option[2]="download Koala v2.3.0"
  local option[3]="install chrome"
	local option[4]="install tor-browser"
	local option[5]="vmware player"
	local option[6]="poedit"
	local option[7]="Teamviewer"
	local option[8]="freelancer-desktop-app"
  local option[9]="ADD settings to .vimrc file"
	local option[10]="return back"
	#echo "${option[@]}"

	echo "#######################################"
	echo "#### Script for Installing desktop ####"
	echo "#######################################"

	local PS3="Select app: "
	select var in "${option[@]}"
	do
	#	echo "$REPLY"
	#	echo "$var"
		case $REPLY in
		1)
			echo "install apps (of/rep)"
			install_apps
			;;
    2)
      echo "
go to this page http://koala-app.com/
"
      ;;
    3)
      echo "
page https://www.google.com/chrome/
"
      ;;
    4)
      echo "
page https://www.torproject.org/download/download-easy.html.en
"
      ;;
    5)
      echo "
page: https://my.vmware.com/en/web/vmware/free#desktop_end_user_computing/vmware_workstation_player/14_0
"
      ;;
    6)
      echo "
page: https://poedit.net/
"
      ;;
    7)
      echo "
page: https://www.teamviewer.com/en/download/linux/
"
      ;;
    8)
      echo "
page: https://www.freelancer.com/desktop-app/
"
      ;;
		9)
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

      ;;
    10)
			echo "exit"
			return
			;;
		*)
			echo "unknown option"
			;;
		esac
	done

} # m_install_desktop_apps
