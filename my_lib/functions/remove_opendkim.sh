#!/bin/bash




remove_opendkim(){

	echo "function remove_opendkim"

	sudo systemctl stop opendkim.service

	#purge OpenDKIM
	sudo apt-get -y purge opendkim opendkim-tools

 	#remove from postfix /etc/postfix/main.cf
	sudo sed -ri.bak ':a;N;$!ba;s/#=====OpenDKIM=====#.+#=====OpenDKIM=====#//' /etc/postfix/main.cf
	#remove from postfix /etc/postfix/master.cf
	sudo sed -ri.bak ':a;N;$!ba;s/#=====DKIM=====#.+#=====DKIM=====#\s*\n//' /etc/postfix/master.cf	

	#remove directory /etc/opendkim
	sudo rm -r /etc/opendkim

	
	sudo apt-get -y autoremove
	sudo apt-get -y autoclean

	#restart postfix
	sudo systemctl restart postfix.service

	echo
	echo "OOpenDKIM has been removed"


} #remove_opendkim




