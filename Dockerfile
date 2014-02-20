# start from phusion/baseimage
FROM phusion/baseimage:0.9.6
MAINTAINER  Markus Hubig <mhubig@imko.de>

# Set correct environment variables.
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Regenerate SSH host keys.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# expose HTTP & MySQL Port
EXPOSE 80

# Update apt stuff
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:ufirst/php5
RUN apt-get update

# Install software
RUN apt-get install -y -q --no-install-recommends nginx
RUN apt-get install -y -q --no-install-recommends mysql-server
RUN apt-get install -y -q --no-install-recommends php5-fpm
RUN apt-get install -y -q --no-install-recommends php5-common
RUN apt-get install -y -q --no-install-recommends php-pear
RUN apt-get install -y -q --no-install-recommends php-apc
RUN apt-get install -y -q --no-install-recommends php5-mysql
RUN apt-get install -y -q --no-install-recommends php5-imagick
RUN apt-get install -y -q --no-install-recommends php5-curl
RUN apt-get install -y -q --no-install-recommends php5-cli
RUN apt-get install -y -q --no-install-recommends php5-gd
RUN apt-get install -y -q --no-install-recommends php5-json

# nginx configuration
RUN mkdir /srv/www && ln -s /srv/www /var/www
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/default /etc/nginx/sites-available/default

# register the nginx service
RUN mkdir /etc/service/nginx
ADD nginx/nginx.sh /etc/service/nginx/run

# PHP5 configuration
RUN mv /etc/php5/conf.d/*.ini /etc/php5/fpm/conf.d/
RUN echo "<?php phpinfo(); ?>" > /srv/www/phpinfo.php

# register the php5-fpm service

# mysql configuration
ADD mysql/my.cnf /etc/mysql/my.cnf
RUN /usr/sbin/mysqld & \
    sleep 10s && \
    echo "GRANT ALL ON *.* TO admin@'%' IDENTIFIED BY 'changeme' WITH GRANT OPTION; FLUSH PRIVILEGES" \
    | mysql

# Register the MySQL service
RUN mkdir /etc/service/mysql
ADD mysql/mysql.sh /etc/service/mysql/run

# Download and unpack partkeepr v0.1.9
RUN cd /srv/www && curl https://codeload.github.com/partkeepr/PartKeepr/tar.gz/0.1.9 |tar zx
RUN cd /srv/www && ln -s PartKeepr-0.1.9 partkeepr

# Clean up APT when done.
#RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
