#!/bin/bash



install_postfix(){

	echo "function install_postfix"


	#ask user about hostname and hostname -f
	echo
	echo "
####################################################
####################################################
### Before install postfix you should install:
### hostname to kselax.ru
### hostname -f to mail.kselax.ru
### to set up hostname to kselax.ru type next
### \$ hostname kselax.ru
### for set up hostname -f you should add line
### to /etc/hosts with next text
### your_host_id mail.kselax.ru kselax.ru
### your hostname `hostname`
### your hostname -f `hostname -f`
######################################################
"

	echo
	read -p "Have you already done it? [y/n]: " answer

	if [ "$answer" != "y" ]; then
		echo "returned back to installetion menu"
		return;
	fi



	#install postfix
	sudo apt-get install -y postfix
	#install utils
	sudo apt-get install -y mailutils



	#open ports 25 and 587 in your firewall, my firewall is UFW, I will use this commands
	sudo ufw allow "Postfix Submission"	#this open 587
	sudo ufw allow "Postfix" 						# this open 25 port
	#see ufw status
	sudo ufw status



	#force postfix use 587 port we need editing file /etc/postfix/master.cf
	#and uncommenting #submission inet n - n - - smtpd
	sudo sed -ri.bak 's/^(#submission inet)(\s+.\s+.\s+)(.)(.+)/submission inet\2n\4/' /etc/postfix/master.cf


	#add hostname to destination
	#if [ "`grep -P \"mydestination\s*=\s*\\\\$\\myhostname\\,\s*\\\\$\\mydomain" /etc/postfix/main.cf`" == "" ]; then
	#	sudo sed -ri.bak "s/mydestination\s+=\s+\\\$myhostname,/& \\\$mydomain,/" /etc/postfix/main.cf
	#fi



	#remove weak ciphers editing file /etc/postfix/main.cf
	if [ ! "` grep -P \"#remove weak cipher\" /etc/postfix/main.cf`" ]; then

	echo "

#=====remove weak cipher=====#
#this is force to use TLS
smtp_tls_security_level = encrypt
# TLS Server
smtpd_tls_exclude_ciphers = RC4, aNULL
# TLS Client
smtp_tls_exclude_ciphers = RC4, aNULL
#=====remove weak cipher=====#
" | sudo tee -a /etc/postfix/main.cf

	fi



	#add restrictions to postfix
	if [ "`grep \"#=====Postfix restrictions=====#\" /etc/postfix/main.cf`" == "" ]; then
		echo "

#=====Postfix restrictions=====#
smtpd_helo_required = yes
disable_vrfy_command = yes

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
smtpd_recipient_restrictions = 	reject_non_fqdn_sender,
				#reject_non_fqdn_hostname,
				#reject_invalid_hostname,
				reject_non_fqdn_recipient,
				reject_unknown_sender_domain,
				reject_unknown_recipient_domain,
				reject_unauth_pipelining,
				#permit_mynetworks,
				#reject_unauth_destination
smtpd_client_message_rate_limit = 25
#=====Postfix restrictions=====#

" | sudo tee -a /etc/postfix/main.cf
	fi




	#restart postfix
	sudo systemctl restart postfix.service

	echo
	echo "check your /etc/postfix/main.cf file"
	echo "\$myhostname should be mail.kselax.ru"
	echo "it assume that \$mydomain will be automaticaly kselax.ru"
	echo "and check \$myorigin it shoudl be kselax.ru"
	echo
	echo "postfix has been succeessfully installed"


} #install_postfix
