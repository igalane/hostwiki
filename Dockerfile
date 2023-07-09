FROM php:8.3-rc-apache

ENV MEDIAWIKI_VERSION 1.40
ENV MEDIAWIKI_FULL_VERSION 1.40.0

RUN apt-get update && apt-get upgrade -y \
    libicu-dev \
    libonig-dev 
RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-enable mysqli \
    && rm -rf /var/lib/apt/lists/*

RUN MEDIAWIKI_DOWNLOAD_URL="https://releases.wikimedia.org/mediawiki/$MEDIAWIKI_VERSION/mediawiki-$MEDIAWIKI_FULL_VERSION.tar.gz"; \
    set -x; \
    mkdir -p /usr/src/mediawiki \
    && curl -fSL "$MEDIAWIKI_DOWNLOAD_URL" -o mediawiki.tar.gz \
    && tar -xf mediawiki.tar.gz -C /var/www/html/ --strip-components=1
#COPY LocalSettings.php /var/www/html/
RUN a2enmod rewrite

EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
