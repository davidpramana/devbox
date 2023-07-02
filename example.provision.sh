#!/bin/bash

# This function is called at the very bottom of the file
main() {
	update_go
	locale_go
	common_go
	npm_go
	php_go
	redis_go
	# codeception_go
	composer_go
	# apigen_go
	nginx_go
	postgresql_go
	# mysql_go
	# oci8_go
	varnish_go
	autoremove_go
	complete_go
}

# GO MODULES

update_go() {
	# Update the server
	apt-get update
}

locale_go() {
	# Set TimeZone
	timedatectl set-timezone Asia/Jakarta

	# install language pack english base
	apt-get -y install language-pack-en-base
	# set locale
	if grep -Fxq "LC_ALL=en_US.UTF-8" /etc/default/locale; then
		# code if found : ignore
		echo 'ignore'
	else
		# code if not found : append file
		sed -i -e "s/LC_ALL=/LC_ALL=en_US.UTF-8/g" /etc/default/locale
	fi

	# set language
	if grep -Fxq "LANG=en_US.UTF-8" /etc/default/locale; then
		# code if found : ignore
		echo 'ignore'
	else
		# code if not found : append file
		sed -i -e "s/LANG=/LANG=en_US.UTF-8/g" /etc/default/locale
	fi

	# reconfigure locales
	export LC_ALL=en_US.UTF-8
	export LANG=en_US.UTF-8
	dpkg-reconfigure locales
}

common_go() {
	# Install common softwares
	apt-get -y install mcrypt git curl build-essential zip software-properties-common gcc g++ make libpng-dev unzip
}

npm_go() {
	curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
	apt-get -y install nodejs
	npm install -g gulp-cli gulp pm2 cross-env
}

autoremove_go() {
	apt-get -y autoremove
}

nginx_go() {
	# Install Nginx
	apt-get -y install nginx

	# Remove default site
	rm -f /etc/nginx/sites-available/default
	rm -f /etc/nginx/sites-enabled/default

	# Remove existing virtual hosts
	rm -f /etc/nginx/sites-enabled/*.conf

	# Server Block / Virtual Host
	for site in ./sites-available/*
	do
		echo 'Processing ' $(basename $site) ' file...'
		cp /vagrant/sites-available/$(basename $site) /etc/nginx/sites-available
		rm -f /etc/nginx/sites-enabled/$(basename $site)
		ln -s /etc/nginx/sites-available/$(basename $site) /etc/nginx/sites-enabled/
	done

	nginx_handler
}

php_go() {
	# Add PHP Repository
	add-apt-repository ppa:ondrej/php

	# Update Repository
	apt-get update

	# Install PHP 8
	apt-get install -y php8.2 php8.2-bcmath php8.2-bz2 php8.2-cgi php8.2-cli php8.2-common php8.2-curl php8.2-dba php8.2-enchant php8.2-fpm php8.2-gd php8.2-gmp php8.2-imap php8.2-interbase php8.2-intl php8.2-ldap php8.2-mbstring php8.2-mysql php8.2-odbc php8.2-opcache php8.2-pgsql php8.2-phpdbg php8.2-pspell php8.2-readline php8.2-snmp php8.2-soap php8.2-sqlite3 php8.2-sybase php8.2-tidy php8.2-xml php8.2-xmlrpc php8.2-xsl php8.2-zip php8.2-redis

	# Modify PHP FPM Config
	sed -i -e "s/pm = dynamic/pm = static/g" /etc/php/8.2/fpm/pool.d/www.conf
	sed -i -e "s/pm.max_children = 5/pm.max_children = 44/g" /etc/php/8.2/fpm/pool.d/www.conf
	sed -i -e "s/pm.start_servers = 2/pm.start_servers = 11/g" /etc/php/8.2/fpm/pool.d/www.conf
	sed -i -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 11/g" /etc/php/8.2/fpm/pool.d/www.conf
	sed -i -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 33/g" /etc/php/8.2/fpm/pool.d/www.conf

	nginx_handler
}

redis_go() {
	# Add Redis PPA
	add-apt-repository ppa:redislabs/redis

	# Update Repository
	apt-get update

	# Install Redis Server
	apt-get -y install redis-server

	# Install as Service
	sed -i "s/supervised no/supervised systemd/g" /etc/redis/redis.conf
	service redis-server restart
}

codeception_go() {
	# Install Codeception globally
	if [ ! -f "/usr/local/bin/phpunit" ]; then
		curl -O -L http://codeception.com/codecept.phar
		chmod +x codecept.phar
		mv codecept.phar /usr/local/bin/codecept
	fi
}

composer_go() {
	# Install latest version of Composer globally
	if [ ! -f "/usr/local/bin/composer" ]; then
		curl -O -L https://getcomposer.org/composer.phar
		chmod +x composer.phar
		mv composer.phar /usr/local/bin/composer
	fi
}

apigen_go() {
	# Install APIGen
	if [ ! -f "/usr/local/bin/apigen" ]; then
		curl -O -L http://apigen.org/apigen.phar
		chmod +x apigen.phar
		mv apigen.phar /usr/local/bin/apigen
	fi
}

postgresql_go() {

	# Get PostgreSQL key
	wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | sudo apt-key add -

	# Add the repository to the apt sources
	echo "deb http://apt.postgresql.org/pub/repos/apt/ jammy-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list

	# Update apt
	apt-get update

	# Install PostgreSQL
	apt-get -y install postgresql-15 #python-psycopg2

	# create pg cluster
	pg_createcluster 15 main --start

	# Allow access from Host
	echo "host all all all password" >> /etc/postgresql/15/main/pg_hba.conf
	sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/15/main/postgresql.conf

	# run
	service postgresql start

	# create default user
	sudo -u postgres bash -c "psql -c \"create user devbox with password 'secret' CREATEDB;\""

	# Add Custom PostgreSQL Config
	cp -f ./postgresql-custom.conf /etc/postgresql/15/main/conf.d/custom.conf

	# Remove PostgreSQL Custom Config Templates
	rm /home/vagrant/postgresql-custom.conf

	# PostgreSQL Handler
	postgresql_handler
}

mysql_go() {
	# Set Default root Password
	echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
	echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections

	# Install MySQL
	apt-get -y install mysql-server

	# Download MySQL Tuner
	wget http://mysqltuner.pl/ -O /home/vagrant/mysqltuner.pl
	wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O basic_passwords.txt
	wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O vulnerabilities.csv
	chmod +x /home/vagrant/mysqltuner.pl

	# run
	service mysql start
}

oci8_go() {
	# install OCI8
	apt-get -y install libaio1 build-essential php-pear php8.2-dev

	# Set executable
	chmod +x *.deb

	# install oracle instant client12.1 basic
	dpkg -i ./oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb

	# install oracle instant client12.1 dev
	dpkg -i ./oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb

	# install pecl oci8 (and ignore error when installing twice)
	yes 'instantclient,/usr/lib/oracle/12.1/client64/lib' | pecl install oci8 || true

	# add oci8 extension to php.ini (CLI)
	if grep -Fxq "extension=oci8.so" /etc/php/8.2/cli/php.ini; then
		# code if found : ignore
		echo 'extension oci8 already exists in cli'
	else
		# code if not found : append file
		echo 'extension=oci8.so' >> /etc/php/8.2/cli/php.ini
	fi

	# add oci8 extension to php.ini (FPM)
	if grep -Fxq "extension=oci8.so" /etc/php/8.2/fpm/php.ini; then
		# code if found : ignore
		echo 'extension oci8 already exists in fpm'
	else
		# code if not found : append file
		echo 'extension=oci8.so' >> /etc/php/8.2/fpm/php.ini
	fi
}

varnish_go() {
	# install apt https
	apt-get -y install curl gnupg apt-transport-https

	# Get Varnish key & repository source
	curl -s https://packagecloud.io/install/repositories/varnishcache/varnish60lts/script.deb.sh | sudo bash

	# Update apt
	apt-get update

	# Install Varnish
	apt-get -y install varnish

	# Modify Varnish port
	cp -f ./varnish /etc/default/varnish

	# Modify Varnish VCL
	cp -f ./varnish.vcl /etc/varnish/default.vcl

	# Modify Varnish service
	cp -f ./varnish.service /lib/systemd/system/varnish.service
	systemctl daemon-reload

	# Remove Varnish File Templates
	rm /home/vagrant/varnish
	rm /home/vagrant/varnish.service
	rm /home/vagrant/varnish.vcl

	# Ensure Varnish is started
	varnish_handler

	# restart nginx
	nginx_handler
}

complete_go() {
	# upgrade packages
	apt-get -y upgrade

	# Set TimeZone
	timedatectl set-timezone Asia/Jakarta

	# restart nginx
	nginx_handler

	# Ensure Varnish is started
	varnish_handler

	# Change .config folder ownership
	chown -R vagrant:vagrant /home/vagrant/.config

	# Add Vagrant to www-data Nginx
	usermod -a -G www-data vagrant

	# Remove Varnish File Templates
	rm /home/vagrant/varnish
	rm /home/vagrant/varnish.service
	rm /home/vagrant/varnish.vcl

	# Remove PostgreSQL Custom Config Templates
	rm /home/vagrant/postgresql-custom.conf
}

# HANDLER

nginx_handler() {
	service nginx restart
	service php8.2-fpm restart
}

varnish_handler() {
	service varnish restart
}

postgresql_handler() {
	service postgresql restart
}

main
exit 0