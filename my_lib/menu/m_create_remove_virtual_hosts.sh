#!/bin/bash



m_create_remove_virtual_hosts(){

	echo "function m_create_remove_virtual_hosts"
	local option[1]="create virtual host"
	local option[2]="remove vritual host"
	local option[3]="show existing hosts"
	local option[4]="return back"
	local PS3="4Select action: "

	select var in "${option[@]}"	
	do
		echo "$REPLY"
		echo "$var"

		case $REPLY in
		1)
			echo "create virtual host"
			create_virtual_host
			;;
		2)
			echo "remove virtual host"
			remove_virtual_host
			;;
		3)
			echo "show existing hosts"
			show_existing_hosts
			;;
		4)
			return
			;;
		*)
			echo "not correct input"
			;;
		esac

	done

} #m_create_remove_virtual_hosts




