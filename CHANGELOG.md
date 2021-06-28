# CHANGELOG

## 0.5.0

- MODIFIED; OS to Ubuntu 20.04 LTS (Focal)
- MODIFIED; OCI8 PHP 7.3 to 8.0
- ADDED; Support for Windows and Unix VM synced folder
- MODIFIED; README.md for current technology stack & version

## 0.4.1

- MODIFIED; Redis Server installed as service

## 0.4.0

- MODIFIED; default example-web.conf nginx
- ADDED; Timezone to Asia/Jakarta
- ADDED; complete_go function to upgrade and make sure varnish & nginx works
- MODIFIED; nginx_go to remove default site
- ADDED; Remove varnish template files on complete_go
- MODIFIED; Change NodeJS version from 10 to 14 LTS
- ADDED; php-redis for PHP
- MODIFIED; Shared Folder type to NFS with options (nolock)
- ADDED; Redis Server installed as service
- MODIFIED; Change PHP 7.3 to 8.0

## 0.3.0

- ADDED; php7.3-redis for Laravel >= 6
- ADDED; unzip for common packages
- ADDED; redis-server start on startup
- ADDED; webpack-cli and yarn for npm global packages
- MODIFIED; NPM 10 to 14 LTS
- ADDED; Set timezone to Asia/Jakarta

## 0.2.1

- MODIFIED; Steps to install PosgreSQL
- REMOVED; Packages python-psycopg2 from PostgreSQL

## 0.2.0

- ADDED; Locale english base
- ADDED; zip and software-properties-common for common module
- REMOVED; NPM Strongloop, Lodash, Graceful FS and Sails as default node modules
- MODIFIED; module call priorities
- MODIFIED; Seperate composer, codeception, and apigen module
- MODIFIED; Remove existing nginx site available in guest before mimicing host sites available
- ADDED; OCI8 for PHP and Oracle Client 12.1 (basic and development)
- MODIFIED; Nginx server block from using php5-fpm to php7.0-fpm
- MODIFIED; Nginx server port from 80 to 8080 because of Varnish
- ADDED; Varnish as HTTP Cache
- MODIFIED; Vagrant file ports
- MODIFIED; README.md
- ADDED; CHANGELOG.md and CONTRIBUTORS.md

## 0.1.0

- Initial release