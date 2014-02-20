#!/bin/sh
cd /
umask 077

MYSQLADMIN='/usr/bin/mysqladmin --defaults-extra-file=/etc/mysql/debian.cnf'

trap "$MYSQLADMIN shutdown" 0
trap 'exit 2' 1 2 3 15

/usr/bin/mysqld_safe & wait
