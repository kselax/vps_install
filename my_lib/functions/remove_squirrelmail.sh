#!/bin/bash




remove_squirrelmail(){

	echo "function remove_squirrelmail"
	
	echo "Do you want to remove squirrelmail? [y/n]:"
	read answer

	if [ "${answer}" != "y" ]; then
		echo "return back"
		return
	fi
	
	answer="n"
	while [ "${answer}" != "y" ]; do
		read -p "Input directory where placed squirrelmail /var/www/[your_directory]: " site_name
		echo "site_name=${site_name}"
		site_path=/var/www/${site_name}
		echo "site_path=${site_path}"
		read -p "use this data? [y/n]: " answer
	done
	
	
	#remove folder
	sudo rm -r ${site_path}

	
	#remove squirrelmail data /var/local/squirrelmail/data/ and /var/local/squirrelmail/attach/
	echo
	echo "do you want to remove squirrelmaill data direcories:"
	echo "/var/local/squirrelmail/data/"
	echo "and"
	echo "/var/local/squirrelmail/attach/"
	read -p "? [y/n]: " answer

	if [ "$answer" == "y" ]; then
		sudo rm -r /var/local/squirrelmail
	fi



	echo
	echo "squirrelmail has been removed successfully"

} #remove_squirrelmail




