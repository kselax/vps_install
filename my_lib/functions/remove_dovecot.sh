#!/bin/bash



remove_dovecot(){

	echo "function remove_dovecot"
	
	#close port in UFW 
	sudo ufw deny "Dovecot IMAP"
	#show status
	sudo ufw status


	#stop dovecot
	sudo systemctl stop dovecot.service

	#remove packages
	sudo apt-get -y purge dovecot-core dovecot-imapd

	#autoremove
	sudo apt-get -y autoremove
	sudo apt-get -y autoclean

	#remove folder
	sudo rm -r /etc/dovecot

	#remove dovecot form postfix /etc/postfix/main.cf
	sudo sed -ri.bak ':a;N;$!ba;s/#=====Dovecot=====#.+#=====Dovecot=====#\n//' /etc/postfix/main.cf

	#commented row in /etc/postfix/master.cf
	sudo sed -ri.bak ':a;N;$!ba;s/(smtpd_tls_security_level.*\n)(\s*-o\ssmtpd_sasl_auth_enable=yes)/\1#\2/' /etc/postfix/master.cf

	
	#restart postfix
	sudo systemctl restart postfix.service


	echo
	echo "dovecot has been successfuly removed"

} #remove_dovecot





