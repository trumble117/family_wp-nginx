#!/bin/sh

WP_PASS=besA4aBr
mysql --protocol=tcp -u wp_dbadmin --password=$WP_PASS wordpress_nginx < wpdb_backup.sql
