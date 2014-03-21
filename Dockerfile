# start from phusion/baseimage
FROM phusion/baseimage:0.9.8
MAINTAINER  Markus Hubig <mhubig@imko.de>

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Regenerate SSH host keys.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# expose HTTP port
EXPOSE 80

# Update apt cache & install software
RUN apt-get update && apt-get install -y \
    mysql-server \
    nginx \
    php5-fpm \
    php5-common \
    php-pear \
    php-apc \
    php5-mysql \
    php5-imagick \
    php5-curl \
    php5-cli \
    php5-gd \
    php5-json

# add ssh keys
RUN curl https://github.com/mhubig.keys >> /root/.ssh/authorized_keys

# nginx configuration
RUN mkdir /srv/www && ln -s /srv/www /var/www
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/default /etc/nginx/sites-available/default

# PHP5 & PHP-FPM configuration
ADD php-fpm/php-fpm.conf /etc/php5/fpm/php-fpm.conf
ADD php-fpm/fpm-www.conf /etc/php5/fpm/pool.d/www.conf
ADD php-fpm/php.ini /etc/php5/fpm/php.ini

RUN pear channel-discover pear.symfony.com
RUN pear channel-discover pear.doctrine-project.org
RUN pear channel-discover pear.twig-project.org
RUN pear install pear.doctrine-project.org/DoctrineORM
RUN pear install pear.doctrine-project.org/DoctrineSymfonyYaml
RUN pear install pear.doctrine-project.org/DoctrineSymfonyConsole
RUN pear install twig/Twig

# download partkeepr
RUN cd /srv/www && curl http://partkeepr.org/downloads/partkeepr-0.1.9.tbz2 |tar xj
RUN cd /srv/www && mv partkeepr-0.1.9 partkeepr

# config partkeepr
ADD partkeepr/config.php /srv/www/partkeepr/config.php
ADD partkeepr/config.sql /srv/www/partkeepr/config.sql
ADD partkeepr/SetupDatabase.php /srv/www/partkeepr/testing/SetupDatabase.php
ADD partkeepr/cronjobs /etc/cron.d/partkeepr

# fix permissions
RUN chown -R root:root /srv/www/partkeepr
RUN chown -R www-data:www-data /srv/www/partkeepr/data

# setup mysql db
RUN /usr/sbin/mysqld & sleep 10s && \
    cd /srv/www/partkeepr && \
    mysql < config.sql
RUN /usr/sbin/mysqld & sleep 10s &&  \
    cd /srv/www/partkeepr/testing && \
    php SetupDatabase.php --yes

# register the nginx service
RUN mkdir /etc/service/nginx
ADD nginx/nginx.sh /etc/service/nginx/run

# register the php-fpm service
RUN mkdir /etc/service/php-fpm
ADD php-fpm/php-fpm.sh /etc/service/php-fpm/run

# Register the MySQL service
RUN mkdir /etc/service/mysql
ADD mysql/mysql.sh /etc/service/mysql/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
