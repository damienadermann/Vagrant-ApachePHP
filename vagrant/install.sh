#!/usr/bin/env bash

echo "Setting up..."
LOG=/vagrant/vagrant/install.log

echo "Updating packages list"
apt-get update >> $LOG 2>&1

echo "Updating packages"
apt-get update >> $LOG 2>&1

echo "Installing python-software-properties"
apt-get install -y python-software-properties >> $LOG 2>&1

echo "Updating packages list"
apt-get update >> $LOG 2>&1

echo "Adding PPAs..."
echo " - PHP 5"
add-apt-repository -y ppa:ondrej/php5 >> $LOG 2>&1

echo " - node.js"
add-apt-repository -y ppa:chris-lea/node.js >> $LOG 2>&1

echo "Updating packages list"
apt-get update >> $LOG 2>&1

echo "Installing packages..."
for package in vim curl python g++ make git
do
	echo " - $package"
	apt-get install -y $package >> $LOG 2>&1
done

echo "Preconfiguring debconf for MySql installation"
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

echo "Installing PHP-specific packages..."
for package in php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysqlnd php5-sqlite php5-xdebug
do
	echo " - $package"
	apt-get install -y $package >> $LOG 2>&1
done

echo "Configuring Xdebug"
cat << EOF | tee -a /etc/php5/mods-available/xdebug.ini
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "Enabling mod-rewrite"
a2enmod rewrite >> $LOG 2>&1

echo "Setting document root"
rm -rf /var/www >> $LOG 2>&1
ln -fs /vagrant/public /var/www >> $LOG 2>&1

echo "Enabling PHP error reporting"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sed -i 's/html//' /etc/apache2/sites-available/000-default.conf

echo "Restarting Apache"
service apache2 restart >> $LOG 2>&1

echo "set up databases"
mysql -uroot -proot < /vagrant/vagrant/setupEnvironmentDbs.sql

echo "Linking project directory"
ln -fs /vagrant /home/vagrant/project

echo "Moving to project directory"
cd /vagrant

echo "Running composer"
composer install >> $LOG 2>&1

echo "Complete"
