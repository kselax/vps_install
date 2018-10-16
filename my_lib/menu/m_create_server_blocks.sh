#!/bin/bash

m_create_server_blocks(){
  echo "function m_create_server_blocks"

	local option[1]="Create a Server block"
  local option[2]="Create a Server block for wordpress"
	local option[3]="Remove a Server block"
	local option[4]="return back"

	local PS3="Select action: "

	select var in "${option[@]}"
	do
		case $REPLY in
			1)
				echo "Create a Server block"
				create_server_block
				;;
      2)
        echo "Create a Server block for wordpress"
        create_server_block_for_wordpress
        ;;
			3)
				echo "Remove a Server block"
				remove_server_block
				;;
			4)
				echo "return back"
				return
				;;
			*)
				echo "unknown option"
				;;
		esac
	done

}
