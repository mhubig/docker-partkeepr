#!/bin/sh
exec /sbin/setuser mysql /usr/bin/mysqld_safe >>/var/log/mysql.log 2>&1
