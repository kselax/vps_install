#!/bin/bash



install_dovecot(){

	echo "function install_dovecot"

	#install dovecot
	sudo apt-get -y install dovecot-core dovecot-imapd
	


	#open 143 port in UFW
	sudo ufw allow "Dovecot IMAP"
	#show status
	sudo ufw status



	#editing dovecot config files
	#1. in file /etc/dovecot/conf.d/10-auth.conf set up these rows
	#set up 
	#disable_plaintext_auth = yes
	sudo sed -ri.bak 's/^#?\s*disable_plaintext_auth\s*=\s*.+\s*$/disable_plaintext_auth = yes/' /etc/dovecot/conf.d/10-auth.conf
	#auth_mechanisms = plain login
	sudo sed -ri.bak 's/^#?\s*auth_mechanisms\s*=\s*[a-z\s]+$/auth_mechanisms = plain login/' /etc/dovecot/conf.d/10-auth.conf
#exit		
	#in file /etc/dovecot/conf.d/10-ssl.conf set up these rows
	#ssl = required
	sudo sed -ri.bak 's/^\s*#?\s*ssl\s*=\s*.+\s*$/ssl = required/' /etc/dovecot/conf.d/10-ssl.conf
	#ssl_cert = </etc/ssl/certs/ssl-cert-snakeoil.pem
	#exit
	sudo sed -ri.bak 's/^\s*#?\s*ssl_cert\s*=\s*.+\s*$/ssl_cert = <\/etc\/ssl\/certs\/ssl-cert-snakeoil.pem/' /etc/dovecot/conf.d/10-ssl.conf
	#exit
	#ssl_key = </etc/ssl/private/ssl-cert-snakeoil.key
	sudo sed -ri.bak 's/^\s*#?\s*ssl_key\s*=\s*.+\s*$/ssl_key = <\/etc\/ssl\/private\/ssl-cert-snakeoil.key/' /etc/dovecot/conf.d/10-ssl.conf
	#exit
	#in file /etc/dovecot/conf.d/10-mail.conf
	#mail_location = maildir:~/Maildir
	sudo sed -ri.bak 's/^mail_location\s*=\s*.+\s*$/mail_location = maildir:~\/Maildir/' /etc/dovecot/conf.d/10-mail.conf
	#exit
	#namespace inbox {
	#	...
	#	inbox = yes
	#	...
	#}
	#this is set up by default in yes


	#//in file /etc/dovecot/conf.d/10-master.conf
	#service auth {
	#	…
	#	unix_listener /var/spool/postfix/private/auth {
	#		mode = 0660
	#		# Assuming the default Postfix user and group
	#		user = postfix
	#		group = postfix
	#	}
	#	...
	#}
	if [ ! "`grep -P \"^\s*user\s*=\s*postfix\s*$\" /etc/dovecot/conf.d/10-master.conf`" ]; then
		text="\n  # Postfix smtp-auth\n  unix_listener \/var\/spool\/postfix\/private\/auth \{\n    mode = 0660\n    # Assuming the default Postfix user and group\n    user = postfix\n    group = postfix\n  \}\n"

		sudo sed -ri.bak "
		:a;
		N;
		\$!ba;
		s/# Postfix smtp-auth.*#\}/$text/
		" /etc/dovecot/conf.d/10-master.conf
	fi
	#exit


	
	###########################################
	## edit postfix files
	#################################

	if [ ! "`grep -P \"#====== Dovecot SASL and Maildir store ======#\" /etc/postfix/main.cf`" ]; then
		# add some seting to /etc/postfix/main.cf
		echo "

#=====Dovecot=====#
home_mailbox = Maildir/

smtpd_sasl_type = dovecot

# Can be an absolute path, or relative to \$queue_directory
# Debian/Ubuntu users: Postfix is setup by default to run chrooted, so it is best to leave it as-is below
smtpd_sasl_path = private/auth

# On Debian Wheezy path must be relative and queue_directory defined
#queue_directory = /var/spool/postfix

# and the common settings to enable SASL:
smtpd_sasl_auth_enable = yes
# With Postfix version before 2.10, use smtpd_recipient_restrictions
#smtpd_relay_restrictions = permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination
#=====Dovecot=====#

" | sudo tee -a /etc/postfix/main.cf
#exit
	fi

	
	#edit file /etc/postfix/master.cf
	#uncomment line #  -o smtpd_sasl_auth_enable=yes
	sudo sed -ri.bak "
	:a;
	N;
	\$!ba;
	s/\n(.*-o smtpd_tls_security_level=encrypt\s*\n*\s*)#(  -o smtpd_sasl_auth_enable=yes\s*\n)/\1\2/
	" /etc/postfix/master.cf
#exit



	#retart dovecot and postfix
	sudo systemctl restart postfix.service
	sudo systemctl restart dovecot.service

echo
echo "dovecot has been successfully installed"

} #install_dovecot















