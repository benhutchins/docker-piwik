FROM php:5.6-apache
MAINTAINER Jonas Renggli <jonas.renggli@swisscom.com>

# Install general utilities
RUN apt-get update \
	&& apt-get install -y \
		vim \
		net-tools \
		procps \
		telnet \
		netcat \
	&& rm -r /var/lib/apt/lists/*

# Install utilities used by TYPO3 CMS / Flow / Neos
RUN apt-get update \
	&& apt-get install -y \
		imagemagick \
		graphicsmagick \
		zip \
		unzip \
		wget \
		curl \
		git \
		mysql-client \
		moreutils \
		dnsutils \
	&& rm -rf /var/lib/apt/lists/*



# gd
RUN buildRequirements="libpng12-dev libjpeg-dev libfreetype6-dev" \
	&& apt-get update && apt-get install -y ${buildRequirements} \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/lib \
	&& docker-php-ext-install gd \
	&& apt-get purge -y ${buildRequirements} \
	&& rm -rf /var/lib/apt/lists/*

# pdo_mysql
RUN docker-php-ext-install pdo_mysql

# mbstring
RUN docker-php-ext-install mbstring

# opcache
RUN docker-php-ext-install opcache

# geoip
RUN runtimeRequirements="libgeoip-dev" \
	&& apt-get update && apt-get install -y ${runtimeRequirements} \
	&& pecl install geoip \
	&& echo "extension=geoip.so" > /usr/local/etc/php/conf.d/ext-geoip.ini \
	&& rm -rf /var/lib/apt/lists/*

ADD assets/php.ini /usr/local/etc/php/conf.d/php.ini



# locales
ADD assets/locale.gen /etc/locale.gen
RUN apt-get update \
	&& apt-get install -y locales \
	&& rm -r /var/lib/apt/lists/* \
	&& locale-gen



# Activate login for user www-data
RUN chsh www-data -s /bin/bash

# new home folder for user
RUN usermod -d /var/www/html www-data



# SSMTP
RUN apt-get update \
	&& apt-get install -y ssmtp \
	&& rm -rf /var/lib/apt/lists/*
ADD assets/ssmtp.conf /opt/docker/ssmtp.conf



# Cron
RUN apt-get update \
	&& apt-get install -y cron \
	&& rm -rf /var/lib/apt/lists/*



# Piwik
ENV PIWIK_VERSION 2.14.3

RUN cd /var/www/html && \
	curl -L -O http://builds.piwik.org/piwik-${PIWIK_VERSION}.tar.gz && \
	tar --strip 1 -xzf piwik-${PIWIK_VERSION}.tar.gz && \
	rm piwik-${PIWIK_VERSION}.tar.gz && \
	chown -R www-data:www-data tmp config

RUN wget -O misc/GeoIPCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz && \
	gunzip misc/GeoIPCity.dat.gz

ADD assets/config.ini.php.docker /var/www/html/config/config.ini.php.docker

# Plugin WebsiteGroups
RUN mkdir -p /var/www/html/plugins/WebsiteGroups && \
	cd /var/www/html/plugins/WebsiteGroups && \
	wget -O WebsiteGroups.tar.gz https://github.com/PiwikPRO/plugin-WebsiteGroups/archive/0.1.4.tar.gz && \
	tar xzf WebsiteGroups.tar.gz --strip 1 && \
	rm -f WebsiteGroups.tar.gz



ADD assets/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
