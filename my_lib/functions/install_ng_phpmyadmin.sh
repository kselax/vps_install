#!/bin/bash


install_ng_phpmyadmin(){
  # pass="hello"
  #
  # echo "pass = $pass";
  # return;
# sudo sed -rn ':a;N;$!ba s/d/&/gp' /etc/nginx/sites-available/default
# return;
#\n###phpmyadmin-code###\nlocation \/newphpmyadmin {\n\tauth_basic "Admin Login";\n\tauth_basic_user_file \/etc\/nginx\/pma_pass;\n}\n###phpmyadmin-code###
  echo "function install_ng_phpmyadmin"
  sudo apt-get -y update
  sudo apt-get -y install phpmyadmin
  # we’ll need to create a symbolic link from the installation files to our Nginx document root directory
  sudo ln -s /usr/share/phpmyadmin /var/www/html
  # Finally, we need to enable the mcrypt PHP module, which phpMyAdmin relies on. This was installed with phpMyAdmin, so we’ll toggle it on and restart our PHP processor
  sudo phpenmod mcrypt
  sudo systemctl restart php7.0-fpm



  if [ "`grep -P "###phpmyadmin-code###" /etc/nginx/sites-available/default`" == "" ];
  then
    # create password
    echo "to protect PhpMyAdmin Enter the username"
    read name
    echo "Enter the password"
    pass=$(openssl passwd)
    echo "name = $name pass = $pass"
    echo "$name:$pass" | sudo tee /etc/nginx/pma_pass
    sudo sed -ri ':a;N;$!ba s/\n\s*location \/\s*\{[^}]*?}/&\n###phpmyadmin-code###\nlocation \/phpmyadmin {\n\tauth_basic "Admin Login";\n\tauth_basic_user_file \/etc\/nginx\/pma_pass;\n}\n###phpmyadmin-code###/' /etc/nginx/sites-available/default
    sudo systemctl restart nginx
  fi

}
# install_ng_phpmyadmin;
