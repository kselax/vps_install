#!/bin/bash


########################################################
#### main function
########################################################
install_ssh_key(){

	echo "function install_ssh_key"

	echo "
#################################################
# before you will be installing ssh-key
# you should create new user and do it
# from this new user, don't use root
#################################################
"

	local key_folder="$HOME/.ssh"
	local key_temp="$key_folder/temp"

	local option[1]="Connect by password (install new key)"
	local option[2]="Connect by ssh-key (reinstall key)"
	local option[3]="Enable password authentication"
	local option[4]="Disable password authentication"
	local option[5]="return back"

	local PS3="Chose action: "
	select var in "${option[@]}"
	do
		case $REPLY in


##########################################
#### Connect to server using password ####
##########################################
			1)
				echo "Install SSH-key on a new server without key"

				#initialization
				local answer=""
				while [ "$answer" != "y" ]
				do
					echo
					read -p "Input server_ip: " server_ip
					read -p "Input server_user: " server_user
					read -p "Input \$HOME/.ssh/[key_name]: " key_name

					echo "server_ip=$server_ip"
					echo "server_user=$server_user"
					echo "key_name=$key_name"

					echo
					read -p "all right? [y/n]: " answer
				done

				#generate key in temp files
				if [ -f "$key_temp" ]; then
					echo "file exists"
					printf "$key_temp\ny\n" | ssh-keygen -t rsa
				else
					echo "file doesn't exists"
					printf "$key_temp" | ssh-keygen -t rsa
				fi


				#get new generated key
				public_key=$(sudo cat ${key_temp}.pub)
				echo
				echo "$public_key"


				#connect to server and set up key
				echo
				echo "Input password for remote server"
				ssh -t "$server_user@$server_ip" "
#check whethere exists directory
if [ ! -d '.ssh' ]; then
	mkdir .ssh
fi

#check whether exists file
if [ ! -f '.ssh/authorized_keys' ]; then
	touch .ssh/authorized_keys
fi

echo directory and file are existed

echo
echo '1) add key to .ssh/authorized_keys and remove all others if they exists'
echo '2) append key'
read answer

if [ \"\$answer\" == \"1\" ]; then
	echo 'add key and remove existing keys'
	echo \"$public_key\" > .ssh/authorized_keys
	echo 'key has been set up'
elif [ \"\$answer\" == \"2\" ]; then
	echo 'add key without remove existing keys'
	echo \"$public_key\" >> .ssh/authorized_keys
	echo 'key has been set up'
else
	echo 'unknown command'
fi

#open port in firewall ufw
sudo ufw allow \"OpenSSH\"
sudo ufw status

exit
"

				#check ssh connection and if right move temp file to key_name
				ssh -i $key_temp "$server_user@$server_ip" "
pwd
"

				#if error = 0 than copy key from temp
				echo "error  $?"
				if [ "$?" == "0" ]; then
					key_const="$key_folder/$key_name"
					echo "key_const=$key_const"
					mv $key_temp $key_const
					mv "${key_temp}.pub" "${key_const}.pub"
					echo
					echo "ssh-key has successfully been installed"
				else
					echo
					echo "ssh-key couldn't have been installed, something went wrong..."
				fi
				#recopy ssh keys from temp files

				#output successful message

				;;


#######################################
### Connect to server using ssh-key ###
#######################################
			2)
				echo "Reinstall SSH key on a server with key"

				#initialization
				local answer=""
				local key_current=""
				while [ "$answer" != "y" ]
				do
					echo
					read -p "Input server_ip: " server_ip
					read -p "Input server_user: " server_user
					read -p "Input new \$HOME/.ssh/[new_key]: " new_key
					read -p "Input old_key \$HOME/.ssh/[old_key]: " old_key

					local new_key_path=${HOME}/.ssh/${new_key}
					local old_key_path=${HOME}/.ssh/${old_key}
					echo "server_ip=$server_ip"
					echo "server_user=$server_user"
					echo "new_key=$new_key"
					echo "old_key=$old_key"
					echo "new_key_path=$new_key_path"
					echo "old_key_path=$old_key_path"


					echo
					read -p "all right? [y/n]: " answer
				done

				#generate key in temp files
				if [ -f "$key_temp" ]; then
					echo "file exists"
					printf "$key_temp\ny\n" | ssh-keygen -t rsa
				else
					echo "file doesn't exists"
					printf "$key_temp" | ssh-keygen -t rsa
				fi

				#get new generated key
				public_key=$(sudo cat ${key_temp}.pub)
				echo
				echo "$pubic_key"

				#connect to server and set up key
				echo
				echo "old-key_path=$old_key_path"
				echo
				echo "Connect to a remote server"
				ssh -i "$old_key_path" "$server_user@$server_ip" "
#check whethere exists directory
if [ ! -d '.ssh' ]; then
	mkdir .ssh
fi

#check whether exists file
if [ ! -f '.ssh/authorized_keys' ]; then
	touch .ssh/authorized_keys
fi

echo directory and file are existed

echo 'add key without remove existing keys'
echo \"$public_key\" >> .ssh/authorized_keys
echo 'key has been set up'

exit
exit
echo
echo 'never run'
echo
"


				#check ssh connection and if right move temp file to key_name
				ssh -i $key_temp "$server_user@$server_ip" "
pwd
"

				#if error = 0 than copy key from temp
				echo "error  $?"
				if [ "$?" == "0" ]; then
					echo "new_key_path=$new_key_path"
					mv $key_temp $new_key_path
					mv "${key_temp}.pub" "${new_key_path}.pub"
					#remove from server old key
					echo "remove from a server an old key"
					ssh -i $new_key_path "$server_user@$server_ip" "
echo 'add key and remove existing keys'
echo \"$public_key\" > .ssh/authorized_keys
echo 'key has been set up'
"
				fi

				;;

######################################
### Enable password authentication ###
######################################
			3)
				echo
				echo "Enable password authentication"
				echo

				#initialization
				local answer=""
				while [ "$answer" != "y" ]
				do
					echo
					read -p "Input server_ip: " server_ip
					read -p "Input server_user: " server_user
					read -p "Input \$HOME/.ssh/[key]: " key

					local key_path=${HOME}/.ssh/${key}
					echo "server_ip=$server_ip"
					echo "server_user=$server_user"
					echo "key=$key"
					echo "key_path=${key_path}"

					echo
					read -p "all right? [y/n]: " answer
				done


				echo
				echo "connect to server..."
				echo
				#connect to a server and set up password
				ssh -t -i "$key_path" "$server_user@$server_ip" "
pwd
ls
#PasswordAuthentication yes
sudo sed -ri.bak 's/^\s*#?\s*PasswordAuthentication\s+.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config

#PubkeyAuthentication yes
sudo sed -ri.bak 's/^\s*#?\s*PubkeyAuthentication\s+.*$/PubkeyAuthentication yes/' /etc/ssh/sshd_config

#ChallengeResponseAuthentication no
sudo sed -ri.bak 's/^\s*#?\s*ChallengeResponseAuthentication\s+.*$/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config

#reload server
echo
echo 'restart ssh...'
echo
sudo systemctl restart ssh.service
"

			echo
			echo "Password has been enabled"

			;;

#######################################
### Disable password authentication ###
#######################################
			4)
				echo
				echo "Disable password authentication"
				echo

				#initialization
				local answer=""
				while [ "$answer" != "y" ]
				do
					echo
					read -p "Input server_ip: " server_ip
					read -p "Input server_user: " server_user
					read -p "Input \$HOME/.ssh/[key]: " key

					local key_path=${HOME}/.ssh/${key}
					echo "server_ip=$server_ip"
					echo "server_user=$server_user"
					echo "key=$key"
					echo "key_path=${key_path}"

					echo
					read -p "all right? [y/n]: " answer
				done


				echo
				echo "connect to server..."
				echo
				#connect to a server and set up password
				ssh -t -i "$key_path" "$server_user@$server_ip" "
pwd
ls
#PasswordAuthentication no
sudo sed -ri.bak 's/^\s*#?\s*PasswordAuthentication\s+.*$/PasswordAuthentication no/' /etc/ssh/sshd_config

#PubkeyAuthentication yes
sudo sed -ri.bak 's/^\s*#?\s*PubkeyAuthentication\s+.*$/PubkeyAuthentication yes/' /etc/ssh/sshd_config

#ChallengeResponseAuthentication no
sudo sed -ri.bak 's/^\s*#?\s*ChallengeResponseAuthentication\s+.*$/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config

#reload server
echo
echo 'restart ssh...'
echo
sudo systemctl restart ssh.service
"

			echo
			echo "Password has been disabled"

			;;

###########################
### Return back to menu ###
###########################
			5)
				echo "return back"
				return
				;;
			*)
				echo "unknown input"
				;;
		esac
	done

} #install_ssh_key
