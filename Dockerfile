# imagem base
FROM php:8.1.6-apache

# define o data/hora como São Paulo
RUN  echo "America/Sao_Paulo" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y \
    zip \
    unzip \ 
    libzip-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \ 
    libgd-dev

RUN pecl install xdebug-3.3.1 \
    && docker-php-ext-enable xdebug

RUN docker-php-ext-configure gd \ 
    --with-freetype=/usr/include/ \ 
    --with-jpeg=/usr/include/

RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    opcache \
    zip \
    gd \
    exif

# arquivos de configurações
COPY ./conf/php/form.ini "${PHP_INI_DIR}/conf.d/form.ini"
COPY ./conf/php/errors.ini "${PHP_INI_DIR}/conf.d/errors.ini"
COPY ./conf/php/timezone.ini "${PHP_INI_DIR}/conf.d/timezone.ini"
COPY ./conf/php/memory.ini "${PHP_INI_DIR}/conf.d/memory.ini"
COPY ./conf/ssl/localhost.crt /etc/ssl/certs/localhost.crt
COPY ./conf/ssl/localhost.key /etc/ssl/private/localhost.key
COPY ./conf/apache/virtualhost.conf /etc/apache2/sites-available/000-default.conf

# instalando coposer   
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&\
    php composer-setup.php &&\
    php -r "unlink('composer-setup.php');" &&\
    mv composer.phar /usr/local/bin/composer

# habilitando ssl/reescrita de url (url amigaveis)
RUN a2enmod rewrite &&\
    a2enmod ssl

# expondo portas do docker para acesso a máquina fora do docker acessar
EXPOSE 80 443

# diretório a ser utilizado no docker
WORKDIR /var/www/html/