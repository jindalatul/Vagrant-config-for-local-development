# Shell Script named bootstrap.sh

#!/usr/bin/env bash

#assure that your system is updated

#Add Proxy for temprary automation

#mysql Password is F24WE234

export http_proxy=http://domain.com:port
export https_proxy=https://domain.com:port

apt-get -y update 
# install LAMP Stack
apt-get install -y apache2
apt-get install -y php5

#install required PHP modules
apt-get install -y libapache2-mod-php5 php5-mcrypt php5-mysql 
apt-get install -y php5-curl php5-gd php5-imagick php5-memcache
apt-get install -y php5-pspell php5-recode  php5-xmlrpc php5-xsl 

apt-get install -y unzip
apt-get install -y gunzip
apt-get install -y git

export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "mariadb-server mysql-server/root_password password 123456"
debconf-set-selections <<< "mariadb-server mysql-server/root_password_again password 123456" 

apt-get install -y mariadb-server mariadb-client 

a2enmod rewrite

echo "<?php phpinfo();?>" >> /var/www/html/info.php

mkdir /etc/apache2/ssl
cd /etc/apache2/ssl

openssl genrsa -out stage-iot.dev.key 2048
openssl req -new -x509 -key domain.key -out domain.cer -days 3650 -subj /CN=domain.com

a2enmod ssl

service apache2 restart

sudo cp /vagrant/provision/apache2/default.conf /etc/apache2/sites-available/default.conf
sudo chmod 644 /etc/apache2/sites-available/default.conf
sudo ln -s /etc/apache2/sites-available/site.conf /etc/apache2/sites-enabled/default.conf

echo "Sucessfully installed - open your browser and type ip address of this machine and locate info.php";

