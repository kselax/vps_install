#!/bin/bash




remove_spamassassin(){

	echo "function remove_spamassassin"
	
	#stop service
	sudo systemctl stop spamassassin.service

	#remove packages
	sudo apt-get -y purge spamassassin spamc

	#remove user
	sudo deluser spamd

	#remove from postfix
	sudo sed -ri.bak ':a;N;$!ba;s/#=====SpamAssassin=====#.+#=====SpamAssassin=====#\n//' /etc/postfix/master.cf

	#remove dependencies
	sudo apt-get -y autoremove
	sudo apt-get -y autoclean

	#restart postfix
	sudo systemctl restart postfix.service

	echo
	echo "SpamAssassin has been removed successfully"

} #remove_spamassassin




