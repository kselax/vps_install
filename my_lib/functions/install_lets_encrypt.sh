#!/bin/bash



install_lets_encrypt(){

	echo "function install_lets_encrypt"
	
	#add repository
	sudo add-apt-repository -y ppa:certbot/certbot

	#update 
	sudo apt-get -y update

	#install bot
	sudo apt-get -y install python-certbot-apache

	
	echo "
Select what do you whant to do
1 create a certificate for a one domain
2 cteate a one certificate with multible domain
3 return back
"
	local answer=""
	read -p "make your choice: " answer
	
	local domain_name=""
	if [ "$answer" == "1" ]; then
		echo "certificate for one domain"
		
		#output vhosts
		echo
		ls /etc/apache2/sites-available/
		echo

		local domain_name=""
		read -p "input domain name " domain_name
		echo "doname_name=$domain_name"
		
		#generate certificate
		sudo certbot --apache -d $domain_name

	elif [ "$answer" == "2" ]; then
		echo "certificate for multiple domain"

		#output  vhosts
		echo
		ls /etc/apache2/sites-available/
		echo

		echo "list of domains separated by space"
		local IN
		read IN
		echo "IN = $IN"
		#IN="kselax.ru test.kselax.ru  mail.kselax.ru"
		IN=$(echo $IN | sed -r 's/^\s+//') #remove space in the begining
		IN=$(echo $IN | sed -r 's/\s+$//') #remove space in the end
		IN=$(echo $IN | sed -r 's/\s+/ -d /g')
		IN=" -d $IN"
		echo $IN
		sudo certbot --apache ${IN}
	else
		echo "return back"
		return
	fi

	#restart apache2
	sudo systemctl restart apache2.service


} #install_lets_encrypt





