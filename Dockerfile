# imagem base
FROM ubuntu:latest

# variáveis de ambiente, vem de forma dinâmica, o docker-compose.yml carrega as variáveis do .env e chega no Dockerfile
ARG TIMEZONE PHP_VERSION
ENV timezone=${TIMEZONE} php_version=${PHP_VERSION}

# define o data/hora como São Paulo
RUN ln -snf /usr/share/zoneinfo/${timezone} /etc/localtime &&\
    echo ${timezone} > /etc/timezone

# instala as atualizações
RUN apt update && apt upgrade -y

# pacotes essenciais 
RUN apt install -y \
    software-properties-common \ 
    zip  \ 
    unzip \
    apt-transport-https \
    ca-certificates \
    curl \
    bash-completion

# repositório com php (5.6 até 8.x)
RUN add-apt-repository ppa:ondrej/php \
    && apt-get update
    
# instala os pacotes necessários para trabalhar com php-apache 
RUN apt install -y \
    apache2 \
    libapache2-mod-php${php_version} \
    php${php_version} \
    php${php_version}-opcache \
    php${php_version}-cli \
    php${php_version}-xdebug \
    php${php_version}-mysql \
    php${php_version}-zip \
    php${php_version}-curl \
    php${php_version}-gd \
    php${php_version}-xml \
    php${php_version}-mbstring \
    php${php_version}-fpm \
    php${php_version}-ftp \
    php${php_version}-common 
    
# instalando coposer   
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&\
    php composer-setup.php &&\
    rm composer-setup.php &&\
    mv composer.phar /usr/local/bin/composer &&\
    chmod a+x /usr/local/bin/composer

# habilitando ssl/reescrita de url (url amigaveis)
RUN a2enmod expires &&\
    a2enmod rewrite &&\
    a2enmod ssl

# expondo portas do docker para acesso a máquina fora do docker acessar
EXPOSE 80 443

# diretório a ser utilizado no docker
WORKDIR /var/www/html

# executa ao inicar o container
ENTRYPOINT /etc/init.d/apache2 start && /bin/bash

CMD ["true"]