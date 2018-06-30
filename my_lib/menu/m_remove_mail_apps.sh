#!/bin/bash



m_remove_mail_apps(){

	echo "function m_remove_mail_apps"
	local option[1]="remove Postfix"
	local option[2]="remove Dovecot"
	local option[3]="remove SpamAssassin"
	local option[4]="remove Roundcube"
	local option[5]="remove Squirrelmail"
	local option[6]="remove OpenDKIM"
	local option[7]="return back"

	local PS3="Select action: "
	
	select var in "${option[@]}"
	do
		case $REPLY in
			1)
				echo "remove Postfix"
				remove_postfix
				;;
			2)
				echo "remove Dovecot"
				remove_dovecot
				;;
			3)
				echo "remove SpamAssassin"
				remove_spamassassin
				;;
			4)
				echo "remove Roundcube"
				remove_roundcube
				;;
			5)
				echo "remove Squirrelmail"
				remove_squirrelmail
				;;
			6)
				echo "remove OpenDKIM"
				remove_opendkim
				;;
			7)
				echo "return back"
				return
				;;
			*)
				echo "unknown command"
				;;
		esac
	done

} #m_remove_mail_apps





