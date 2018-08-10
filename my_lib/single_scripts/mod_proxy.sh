#!/bin/bash

# install all needed modules
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_ajp
sudo a2enmod rewrite
sudo a2enmod deflate
sudo a2enmod headers
sudo a2enmod proxy_balancer
sudo a2enmod proxy_connect
sudo a2enmod proxy_html

# The Load balancing scheduler algorithm is not provided by this module but from other ones such as:
sudo a2enmod lbmethod_byrequests
sudo a2enmod lbmethod_bytraffic
sudo a2enmod lbmethod_bybusyness
sudo a2enmod lbmethod_heartbeat


sudo systemctl restart apache2.service
