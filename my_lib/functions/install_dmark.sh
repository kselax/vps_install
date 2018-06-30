#!/bin/bash


install_dmark(){

	echo "function install demark"

	echo "DMARK generator"
	echo
	read -p "Input site name (domain): " site_name
	echo
	echo "
install it manually, for do this we have to create two records
first record with
name:_dmarc.${site_name}
and 
text: v=DMARC1; p=none; sp=none; fo=; ri=3600; rua=mailto:neo@${site_name}; ruf=mailto:neo@${site_name}

second record with 
name: ${site_name}._report._dmarc.${site_name}
and 
text: v=DMARC1
"

} #install_dmark






