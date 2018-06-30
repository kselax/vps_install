#!/bin/bash




install_mail_certificate(){

	echo "function install_mail_certificate"
	
	#output vhosts
	echo
	ls /etc/apache2/sites-available
	echo

	
	#get vhost
	read -p "Input vhost for a mail server with generated certificate.
it shoudl be somethign liek mail.kselax.ru your MX: " vhost_name

	vhost_path=/etc/apache2/sites-available/${vhost_name}.conf
	
	echo "vhost_name=$vhost_name"
	echo "vhost_path=$vhost_path"


	if [ -f "/etc/apache2/sites-available/${vhost_path}.conf" ]; then
		echo "file is not exists
return back to menu"
		return
	fi

	echo "file is existed"

	#install get certificates from /etc/apache2/sites-available

	local ssl_file=$(sudo sed -rn "s/^SSLCertificateFile\s+(\S+)\s*$/\1/p" $vhost_path)
	local ssl_key_file=$(sudo sed -rn "s/^SSLCertificateKeyFile\s+(\S+)\s*$/\1/p" $vhost_path)
	
	echo "ssl_file=$ssl_file"
	echo "ssl_key_file=$ssl_key_file"
	ssl_file=$(echo $ssl_file | sed -r "s/\//\\\\\//g")
	ssl_key_file=$(echo $ssl_key_file | sed -r "s/\//\\\\\//g")
	echo "ssl_file=$ssl_file"
	echo "ssl_key_file=$ssl_key_file"
	
	#put certificate to postfix /etc/postfix/main.cf
	sudo sed -ri.bak "s/^(\s*smtpd_tls_cert_file\s*=\s*)(.*)$/\1$ssl_file/" /etc/postfix/main.cf	
	sudo sed -ri.bak "s/^(\s*smtpd_tls_key_file\s*=\s*)(.*)$/\1${ssl_key_file}/" /etc/postfix/main.cf

	

	#put certificate to dovecot /etc/dovecot/conf.d/10-ssl.conf
	sudo sed -ri.bak "s/^(\s*ssl_cert\s*=\s*<).*$/\1${ssl_file}/" /etc/dovecot/conf.d/10-ssl.conf
	sudo sed -ri.bak "s/^(\s*ssl_key\s*=\s*<).*$/\1${ssl_key_file}/" /etc/dovecot/conf.d/10-ssl.conf


	#reboot postfix and dovecot
	sudo systemctl restart postfix.service
	sudo systemctl restart dovecot.service
	
	echo
	echo "certificate has been successfully installed"

} #install_mail_certificate






