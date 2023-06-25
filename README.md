# Vagrant Developer Box

| Category           | Name   |
| ------------------ | ------ |
| Operating System   | Linux Ubuntu Server 22.04 64 bit Long Term Support |
| Web Server   | Nginx 1.18.0   |
| Programming Language   | PHP 8.2	|
| Relational Database   | PostgreSQL 10.12   |
| Relational Database Alternative   | MySQL 8.0.19   |
| HTTP Cache        | Varnish 6.0 |
| In-memory Database   | Redis 6.0.6   |
| Javascript Runtime Environment   | NodeJS 18.X   |
| Javascript Package Manager   | NPM 6.14.10   |
| Version Control System   | Git 2.25.1   |
| PHP Dependency Manager   | Composer latest   |
| APIGen   | APIGen latest   |
| Testing Framework   | Codeception latest   |

## Installation

```bash
vagrant up // start the server
vagrant ssh // go inside the server
vagrant halt // shutdown the server
```

## Virtual Host

For each application that you want to host, you have to create a virtual host.

You can create (copy from the example) in ``sites-available`` folder.

Then, you will have to let vagrant reload and run provisioning process again.

``vagrant provision``


# Database

You have default PostgreSQL use as follow:

* Username : devbox
* Password : secret

You have default MySQL use as follow:

* Username : root
* Password : root

You can connect for example via PGAdmin / Toad with the following information:

* Host : 192.168.33.10
* Port : 5432 (PostgreSQL)
* Port : 3306 (MySQL)

or (using SSH)

* Host : 127.0.0.1
* Port : 5433 (PostgreSQL)
* Port : 3307 (MySQL)

Please note that only in development we can connect to our virtual server from any (*) host.

## OCI8

You can also connect to Oracle database using oci8.

## Laravel

Execute this script to complete Laravel instalation. Make sure the following things:

1. PostgreSQL Database : laravel exists.
2. Redis Server service started.

```bash
composer install
composer require predis/predis
cp .env.example .env
php artisan key:generate
nano .env
	DB_CONNECTION=pgsql
	DB_PORT=5432
	DB_DATABASE=laravel
	DB_USERNAME=devbox
	DB_PASSWORD=secret

	CACHE_DRIVER=redis
	SESSION_DRIVER=redis
php artisan migrate
php artisan db:seed

# Below are optional

# Unix
npm install
# Windows
npm install --no-bin-links
npm run dev
```

## Login

Username (email) : check laravel database on table users.
Password : password

## Theme

SBAdmin 2

Check https://github.com/davidpramana/laravel8-sbadmin2

## Provision.sh

This is the default ``provision.sh``

```bash
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
```

Please change the ``main()`` function to the following after provisioning for the first time:


```bash
main() {
	# update_go
	# locale_go
	# common_go
	# npm_go
	# php_go
	# redis_go
	# codeception_go
	# composer_go
	# apigen_go
	nginx_go
	# postgresql_go
	# mysql_go
	# oci8_go
	# varnish_go
	# autoremove_go
	# complete_go
}
```

Basically only set nginx for daily development.