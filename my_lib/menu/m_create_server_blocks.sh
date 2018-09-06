#!/bin/bash

m_create_server_blocks(){
  echo "function m_create_server_blocks"

	local option[1]="Create a Server block"
	local option[2]="Remove a Server block"
	local option[3]="return back"

	local PS3="Select action: "

	select var in "${option[@]}"
	do
		case $REPLY in
			1)
				echo "Create a Server block"
				create_server_block
				;;
			2)
				echo "Remove a Server block"
				remove_server_block
				;;
			3)
				echo "return back"
				return
				;;
			*)
				echo "unknown option"
				;;
		esac
	done

}
