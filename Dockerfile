FROM ubuntu:trusty
MAINTAINER Norbert Mozsar <mozsarn@5net.hu>

# apache
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    software-properties-common \
    python-software-properties \
    supervisor \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN LC_ALL=C.UTF-8 add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) multiverse"

# php
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    unzip \
    curl \
    apache2 \
    libapache2-mod-rpaf \
    libapache2-mod-fastcgi \
    php7.1-cli \
    php7.1-mbstring \
    php7.1-xml \
    php7.1-soap \
    php7.1-curl \
    php7.1-mcrypt \
    php7.1-gd \
    php7.1-bz2 \
    php7.1-zip \
    php7.1-mysql \
    php7.1-fpm \
    php-xdebug \
    php-redis \
    mysql-client \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite && \
    a2enmod rpaf && \
    a2enmod actions && \
    a2enmod fastcgi && \
    a2enmod headers && \
    a2enmod proxy_http && \
    a2disconf other-vhosts-access-log

RUN mkdir /project && \
    phpdismod opcache && \
    curl -o /usr/local/bin/composer https://getcomposer.org/composer.phar && \
    chmod +x /usr/local/bin/composer && \
    composer global require "hirak/prestissimo:^0.3" && \
    composer global require "laravel/installer"

COPY files/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY files/envvars /etc/apache2/envvars
COPY files/xdebug.ini /etc/php/7.1/mods-available/xdebug.ini
COPY files/start.sh /start.sh
COPY files/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /start.sh && \
    mkdir -p /run/php && \
    chmod 777 /run/php && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "include=/dev/shm/fpm-user.conf" >> /etc/php/7.1/fpm/pool.d/www.conf

EXPOSE 80

WORKDIR /project

CMD ["/usr/bin/supervisord"]
