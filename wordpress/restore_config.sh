#!/bin/bash

mkdir /var/run/nginx-cache
chown nginx:nginx /var/run/nginx-cache

mkdir -p /var/lib/php/session
chown nginx:nginx /var/lib/php/session

mkdir /var/log/php-fpm

# Backup current config
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
cp /etc/php5/fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf.orig

# Extract configuration
cd /
tar xf /tmp/backup/docker_svc-cfg_backup.tar
rm -f /etc/nginx/sites-enabled/default 
tar zxf /tmp/backup/docker_blog_backup.tar.gz
tar xf /tmp/backup/docker_backup_scripts.tar
echo "0 1 * * Mon /usr/sbin/blog-backup" > /var/spool/cron/crontabs/root
