#!/bin/bash




m_mail_server(){

	echo "function m_mail_server"
	local option[1]="update system mail"
	local option[2]="install Postfix"
	local option[3]="install Dovecot"
	local option[4]="install SpamAssassin"
	local option[5]="install Roundcube"
	local option[6]="install SquirrelMail"
	local option[7]="install OpenDKIM"
	local option[8]="install SPF"
	local option[9]="install DMARK"
	local option[10]="install mail certificate"
	local option[11]="remove mail apps"
	local option[12]="return back"

	local PS3="Select action: "

	select var in "${option[@]}"
	do
		case $REPLY in
			1)
				echo "update system mail"
				update_system_mail
				;;
			2)
				echo "install Postfix"
				install_postfix
				;;
			3)
				echo "install Dovecot"
				install_dovecot
				;;
			4)
				echo "install SpamAssassin"
				install_spamassassin
				;;
			5)
				echo "install Roundcube"
				install_roundcube
				;;
			6)
				echo "install SquirrelMail"
				install_squirrelmail
				;;
			7)
				echo "install OpenDKIM"
				install_opendkim
				;;
			8)
				echo "install SPF"
				install_spf
				;;
			9)
				echo "install DMARK"
				install_dmark
				;;
			10)
				echo "install mail certificate"
				install_mail_certificate
				;;
			11)
				echo "remove mail apps"
				m_remove_mail_apps
				;;
			12)
				echo "return back"
				return
				;;

			*)
				echo "unknown option"
				;;
		esac
	done

} #m_mail_server
