#!/bin/bash



#### helper functions

show_key(){

	#get key
	key=$(sudo sed -rn 's/^.*p=(.+)".*$/\1/p' $1)
	echo ${key}

	#output key
	echo "
Name: mail._domainkey.${site_name}.
Text: \"v=DKIM1; k=rsa; p=${key}\"
"
} #show_key

#### end helper functions




#### main function
install_opendkim(){


	#get site mane	
	answer="n"
	site_name=""
	while [ ${answer} != "y" ]
	do
		read -p "Input your site name for mail.kselax.ru it should be kselax.ru: " site_name 
		echo "your site name: ${site_name}"
		read -p "All right? [y/n]: " answer
	done



	#check wheter exists key
	path_to_key=/etc/opendkim/keys/${site_name}/mail.txt 
	if [ -f ${path_to_key} ]; then
		echo "key for ${site_name} have already been created"
		echo
		echo "1 - show key"
		echo "2 - recreate key"
		read answer
		if [ "${answer}" == "1" ]; then
			echo "show key"
			show_key ${path_to_key}  
			return
		fi
	else
		echo "key for ${site_name} havent beend created"
	fi




	#installing OpenDKIM and generate the key


	echo "function install_opendkim"
	#//update and upgrade system
	sudo apt-get -y update
	sudo apt-get -y dist-upgrade

	#//install OpenDKIM and its dependencies
	sudo apt-get -y  install opendkim opendkim-tools
	
	#//edit main configuration file /etc/opendkim.conf
	if [ "`grep -P \"#=====OpenDKIM=====#\" /etc/opendkim.conf`" == "" ]; then

		echo "
#=====OpenDKIM=====#
AutoRestart             Yes
AutoRestartRate         10/1h
UMask                   002
Syslog                  yes
SyslogSuccess           Yes
LogWhy                  Yes

Canonicalization        relaxed/simple

ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts
InternalHosts           refile:/etc/opendkim/TrustedHosts
KeyTable                refile:/etc/opendkim/KeyTable
SigningTable            refile:/etc/opendkim/SigningTable

Mode                    sv
PidFile                 /var/run/opendkim/opendkim.pid
SignatureAlgorithm      rsa-sha256

UserID                  opendkim:opendkim

Socket                  inet:12301@localhost
#=====OpenDKIM=====#

" | sudo tee -a /etc/opendkim.conf

	fi



	#/connect the milter to postfix /etc/default/opendkim
	#SOCKET="inet:12301@localhost"
	sudo sed -ri.bak 's/^SOCKET=.*$/SOCKET="inet:12301@localhost"/' /etc/default/opendkim
	


	#/Configure postfix to use this milter: /etc/postfix/main.cf
	if [ "`grep -P \"#=====OpenDKIM=====#\" /etc/postfix/main.cf`" == "" ]; then

		echo "
#=====OpenDKIM=====#
milter_protocol = 2
milter_default_action = accept

smtpd_milters = inet:localhost:12301
non_smtpd_milters = inet:localhost:12301
#=====OpenDKIM=====#
" | sudo tee -a /etc/postfix/main.cf

	fi


	#change y on -
	sudo sed -ri.bak 's/^(\s*smtp\s*inet\s*.\s*.\s*)y(.*smtpd\s*)$/\1-\2/' /etc/postfix/master.cf
	#postfix add row to allow webmail send message without singing twice
	#/etc/postfix/master.cf
	if [ "`grep -P \"#=====DKIM=====#\" /etc/postfix/master.cf`" == "" ]; then
		sudo sed -ri.bak 's/^\s*smtp\s+inet.+$/&\n#=====DKIM=====#\n  -o smtpd_milters=\n#=====DKIM=====#/' /etc/postfix/master.cf
	fi


	#//Create a directory structure that will hold the trusted hosts, key tables, 
	#//signing tables and crypto keys:
	sudo mkdir -p /etc/opendkim/keys

	#//Specify trusted hosts in file /etc/opendkim/TrustedHosts
	echo "
127.0.0.1
localhost
192.168.0.1/24

*.${site_name}

#*.example.net
#*.example.org
" | sudo tee /etc/opendkim/TrustedHosts

	#//Create a key table /etc/opendkim/KeyTable
	echo "
mail._domainkey.${site_name} ${site_name}:mail:/etc/opendkim/keys/${site_name}/mail.private

#mail._domainkey.example.net example.net:mail:/etc/opendkim/keys/example.net/mail.private
#mail._domainkey.example.org example.org:mail:/etc/opendkim/keys/example.org/mail.private
" | sudo tee /etc/opendkim/KeyTable

	#//Create a signing table: /etc/opendkim/SigningTable
	echo "
*@${site_name} mail._domainkey.${site_name}

#*@example.net mail._domainkey.example.net
#*@example.org mail._domainkey.example.org
" | sudo tee /etc/opendkim/SigningTable

	
	#//Change to the keys directory:
	cd /etc/opendkim/keys
	#//Create a separate folder for the domain to hold the keys:
	sudo mkdir ${site_name}
	cd ${site_name}
	#//Generate the keys:
	sudo opendkim-genkey -s mail -d ${site_name}
	#//Change the owner of the private key to opendkim:
	sudo chown opendkim:opendkim mail.private
	
	#show key
  sudo cat mail.txt

	
	#//Restart Postfix and OpenDKIM:
	sudo systemctl restart postfix.service
	sudo systemctl restart opendkim.service

	
	#output key
	echo "show key"
	show_key ${path_to_key} 


	#for to test DKIm send message
	echo
	echo "for to test DKIM send empty message to this mail:"
	echo "check-auth@verifier.port25.com"
	
	echo
	echo "openDKIM has been successfully installed"

} #install_opendkim






