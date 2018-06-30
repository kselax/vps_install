#!/bin/bash



remove_lets_encrypt(){

	echo "functon remove_lets_encrypt"


	#remove lets encrypt
	sudo apt-get -y purge python-certbot-apache
	
	#remove folder
	sudo rm -r /usr/bin/certbot

	sudo apt-get -y autoremove
	sudo apt-get -y autoclean

	#ask user about removing folder /etc/letsencrypt/
	echo "
Do you want to remove folder /etc/letsencrypt/ where placed all your certificates.
If you remove this folder, your hosts won't work properly with TLS/SSL because
you need rewrite pathes that will linked to this foler. 
Do not remove folder!(Recomended)
"

	local answer=""
	read -p "remove folder /etc/letsencrypt/? [y/n]: " answer
	if [ "$answer" == "y" ]; then
		sudo rm -r /etc/letsencrypt/

		#put self singed sertificat instead letsencript
		#SSLCertificateFile  /etc/ssl/certs/ssl-cert-snakeoil.pem
		#SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
		#if we dont do this apache won't start

		#get list of files
		for entry in /etc/apache2/sites-available/*
		do
			if [ "$entry" == "/etc/apache2/sites-available/000-default.conf" ]; then
				continue
			elif [ "$entry" == "/etc/apache2/sites-available/default-ssl.conf"  ]; then
				continue
			fi
			
			echo "$entry"
			
			#add certificates to each entry it there letsencrypt
			sudo sed -ri 's/^(\s*SSLCertificateFile\s+)\/etc\/letsencrypt.+$/\1\/etc\/ssl\/certs\/ssl-cert-snakeoil.pem/' $entry	
			sudo sed -ri 's/^(\s*SSLCertificateKeyFile\s+)\/etc\/letsencrypt.+$/\1\/etc\/ssl\/private\/ssl-cert-snakeoil.key/' $entry
			sudo sed -ri 's/^\s*Include\s*\/etc\/letsencrypt\/options-ssl-apache.conf\s*$//' $entry
			
		done
	fi
	
	#restart apache2
	sudo systemctl restart apache2.service


	echo
	echo "Let's encrypt has been successfuly removed"

} #remove_lets_encrypt





