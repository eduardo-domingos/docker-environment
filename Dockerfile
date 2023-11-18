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
    libzip-dev &&\
    docker-php-ext-configure gd \ 
        --with-freetype-dir=/usr/include/ \ 
        --with-jpeg-dir=/usr/include/ &&\
    docker-php-ext-install gd

RUN pecl install xdebug-2.9.8 \
    && docker-php-ext-enable xdebug

RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    opcache \
    zip

# arquivos de configurações
COPY ./conf/php/form.ini "${PHP_INI_DIR}/conf.d/form.ini"
COPY ./conf/php/errors.ini "${PHP_INI_DIR}/conf.d/errors.ini"
COPY ./conf/php/timezone.ini "${PHP_INI_DIR}/conf.d/timezone.ini"
COPY ./conf/php/memory.ini "${PHP_INI_DIR}/conf.d/memory.ini"
COPY ./conf/php/xdebug.ini "${PHP_INI_DIR}/conf.d/xdebug.ini"
COPY ./conf/ssl/localhost.crt /etc/ssl/certs/localhost.crt
COPY ./conf/ssl/localhost.key /etc/ssl/private/localhost.key
COPY ./conf/apache/virtualhost.conf /etc/apache2/sites-available/000-default.conf

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