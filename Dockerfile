# imagem base
FROM php:7.1.33-apache

ENV timezone=America/Sao_Paulo

# define o data/hora como São Paulo
RUN ln -snf /usr/share/zoneinfo/${timezone} /etc/localtime &&\
    echo ${timezone} > /etc/timezone

RUN apt-get update && apt-get install -y \ 
    libfreetype6-dev \
    libjpeg62-turbo-dev \ 
    libgd-dev \
    libzip-dev

RUN docker-php-ext-configure gd \ 
    --with-freetype-dir=/usr/include/ \ 
    --with-jpeg-dir=/usr/include/

RUN pecl install xdebug-2.9.8

RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    opcache \
    gd \
    zip

RUN docker-php-ext-enable \
    xdebug \
    mysqli \
    pdo \
    pdo_mysql \
    opcache \
    gd \
    zip \
    xdebug

# instalando coposer   
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php composer-setup.php &&\
    rm composer-setup.php &&\
    mv composer.phar /usr/local/bin/composer &&\
    chmod a+x /usr/local/bin/composer

# habilitando ssl/reescrita de url (url amigaveis)
RUN a2enmod rewrite &&\
    a2enmod ssl

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# expondo portas do docker para acesso a máquina fora do docker acessar
EXPOSE 80 443

# diretório a ser utilizado no docker
WORKDIR /var/www/html/