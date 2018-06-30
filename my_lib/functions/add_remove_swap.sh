#!/bin/bash




add_remove_swap(){

  echo "function add_remove_swap"
  echo
  local option[1]="add swap"
  local option[2]="remoove swap"
  local option[3]="return back"

  local PS3="Chose action: "
  select var in "${option[@]}"
  do
    case $REPLY in
    1)
      echo "add swap"

      #input sise of swap
      echo "sudo fallocate -l 1G /mnt/1GB.swap"
      read -p "input size of swap_size (Gigabyte): " swap_size

      # 1. Create the file to be used for swap.
      sudo fallocate -l ${swap_size}G /mnt/${swap_size}GB.swap

      # 2. Format the file for swap.
      sudo mkswap /mnt/${swap_size}GB.swap

      # 3. Add the file to the system as a swap file.
      sudo swapon /mnt/${swap_size}GB.swap

      # 4. Add this line to the end of /etc/fstab to make the change permanent.
      # /mnt/1GB.swap  none  swap  sw 0  0
      echo "#===swap===#
/mnt/${swap_size}GB.swap  none  swap  sw 0  0
#===swap===#" | sudo tee -a /etc/fstab

      # 5. To change the swappiness value edit /etc/sysctl.conf and add the following line.
      # vm.swappiness=10
      echo "#===swap===#
vm.swappiness=10
#===swap===#" | sudo tee -a /etc/sysctl.conf

      # 6. Check that the swap file was created.
      sudo swapon -s

      # 7. set up permissions to the swap file
      sudo chmod 600 /mnt/${swap_size}GB.swap

      echo
      echo "swap has successfully created"
      ;;
    2)
      echo "remove swap"

      # input sise of swap
      echo
      echo "ls /mnt"
      ls /mnt
      echo
      read -p "input size of swap_size (Gigabyte): " swap_size

      # off swap
      sudo swapoff /mnt/${swap_size}GB.swap

      # remove swap from /mnt folder
      sudo rm /mnt/*.swap

      # remove entry from  /etc/fstab
      sudo sed -ri.bak ':a;N;$!ba;s/#===swap===#.+#===swap===#//' /etc/fstab

      # remove entry from  /etc/sysctl.conf
      sudo sed -ri.bak ':a;N;$!ba;s/#===swap===#.+#===swap===#//' /etc/sysctl.conf

      echo
      echo "swap has successfully removed"
      ;;
    3)
      echo "return back"
      return
      ;;
    *)
      echo "unknown input"
      ;;
    esac
  done
} #add_remove_swap
