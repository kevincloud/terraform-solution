#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt update
apt upgrade -y
apt install -y nginx
apt install -y php php-fpm php-common php-cli
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
cp ./web_server /etc/nginx/sites-available/
cp ./index.php /var/www/html/
chown -R www-data:www-data /var/www/html
ln -s /etc/nginx/sites-available/web_server /etc/nginx/sites-enabled/web_server
sed -i -e 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.2/fpm/php.ini
systemctl restart php7.2-fpm
systemctl restart nginx
