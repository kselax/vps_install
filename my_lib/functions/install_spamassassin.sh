#!/bin/bash



install_spamassassin(){

	echo "function install_spamassassin"

	#install spamassassin
	sudo apt-get -y install spamassassin spamc

	#add spamassassin user
	printf "" |  sudo adduser spamd --disabled-login

	echo
	#show user
	id spamd

	echo
	#remove user
	#sudo deluser spamd
	

	#//Edit the configuration settings at /etc/default/spamassassin
	#ENABLED=0
	sudo sed -ri.bak 's/^ENABLED=.*$/ENABLED=0/' /etc/default/spamassassin
	#OPTIONS="--create-prefs --max-children 5 --username spamd --helper-home-dir /home/spamd/ -s /home/spamd/spamd.log"
	sudo sed -ri.bak 's/^OPTIONS=.*$/OPTIONS="--create-prefs --max-children 5 --username spamd --helper-home-dir \/home\/spamd\/ -s \/home\/spamd\/spamd.log"/' /etc/default/spamassassin
	#CRON=1
	sudo sed -ri.bak 's/^CRON=.*$/CRON=1/' /etc/default/spamassassin



	
	#//Now we will edit /etc/spamassassin/local.cf to set up some anti-spam rules.
	if [ "`grep -P \"my_set_up\" /etc/spamassassin/local.cf`" == "" ]; then

	echo "
#=====SpamAssassin=====#
rewrite_header Subject ***** SPAM _SCORE_ *****
report_safe             0
required_score          5.0
use_bayes               1
use_bayes_rules         1
bayes_auto_learn        1
skip_rbl_checks         0
use_razor2              0
use_dcc                 0
use_pyzor               0
#=====SpamAssassin=====#
" | sudo tee -a /etc/spamassassin/local.cf

	fi




	#change y to -
	sudo sed -ri.bak 's/^(\s*smtp\s*inet\s*.\s*.\s*)y(.*smtpd\s*)$/\1-\2/' /etc/postfix/master.cf

	#//Edit /etc/postfix/master.cf and add a content filter to your SMTP server.
	#smtp      inet  n       -       -       -       -       smtpd
  #  -o content_filter=spamassassin
	#spamassassin unix -     n       n       -       -       pipe
	#	user=spamd argv=/usr/bin/spamc -f -e  
	#	/usr/sbin/sendmail -oi -f ${sender} ${recipient}
	if [ "`grep -P \"#=====SpamAssassin=====#\" /etc/postfix/master.cf`" == "" ]; then
		sudo sed -ri.bak 's/^\s*smtp\s+inet.+$/&\n#=====SpamAssassin=====#\n  -o content_filter=spamassassin\nspamassassin unix -     n       n       -       -       pipe\n  user=spamd argv=\/usr\/bin\/spamc -f -e\n  \/usr\/sbin\/sendmail -oi -f ${sender} ${recipient}\n#=====SpamAssassin=====#/' /etc/postfix/master.cf
	fi



	#//For the changes to take effect, restart Postfix.
	sudo systemctl restart postfix.service
	sudo systemctl enable spamassassin.service
	sudo systemctl start spamassassin.service



	echo
	echo "spamassassin has been successfully installed"



} #install_spamassassin





