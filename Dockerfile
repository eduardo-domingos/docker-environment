# imagem base
FROM php:8.3.6-apache

# execução do composer como root
ENV COMPOSER_ALLOW_SUPERUSER 1

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
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# habilitando ssl/reescrita de url (url amigaveis)
RUN a2enmod rewrite &&\
    a2enmod ssl

# copia o projeto para dentro do container
COPY ./www /var/www/html

# instala as dependências do projeto
RUN cd /var/www/html/fsphp/project && composer install

# expondo portas do docker para acesso a máquina fora do docker acessar
EXPOSE 80 443

# diretório a ser utilizado no docker
WORKDIR /var/www/html/