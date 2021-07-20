FROM php:7.3-cli

RUN apt update && apt -y install unzip wget git nano supervisor mariadb-client \
                      libc-client-dev libkrb5-dev libzip-dev zlib1g-dev \
                      libldb-dev libldap2-dev libxml2-dev libpng-dev \
                      libjpeg-dev libjpeg62-turbo-dev && \
                      rm -r /var/lib/apt/lists/*
                      
RUN echo "max_execution_time = 300" > /usr/local/etc/php/php.ini

RUN echo "upload_max_filesize = 100M" >> /usr/local/etc/php/php.ini

RUN echo "post_max_size = 100M" >> /usr/local/etc/php/php.ini

RUN docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr

RUN docker-php-ext-install pdo_mysql zip mysqli bcmath ldap soap gd pcntl

RUN pecl install redis && docker-php-ext-enable redis

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap

RUN cd /tmp && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
     && tar -xvzf ioncube.tar.gz \
     && mv ioncube/ioncube_loader_lin_7.3.so /usr/local/lib/php/extensions/* \
     && rm -rf ioncube ioncube.tar.gz \
     && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20180731/ioncube_loader_lin_7.3.so" > /usr/local/etc/php/conf.d/docker-php-ext-ioncube.ini

COPY supervisord.conf /etc/supervisor/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
