# imagem base
FROM ubuntu:latest

# variáveis de ambiente, vem de forma dinâmica, o docker-compose.yml carrega as variáveis do .env e chega no Dockerfile
ARG TIMEZONE
ARG PHP_VERSION
ENV timezone=${TIMEZONE}
ENV php_version=${PHP_VERSION}

# define o data/hora como São Paulo
RUN ln -snf /usr/share/zoneinfo/${timezone} /etc/localtime && echo ${timezone} > /etc/timezone

# instala as atualizações
RUN apt update && apt upgrade -y

# pacotes essenciais 
RUN apt install -y software-properties-common 
RUN apt install -y zip 
RUN apt install -y unzip 
RUN apt install -y apt-transport-https 
RUN apt install -y ca-certificates 
RUN apt install -y curl

# repositório com php (5.6 até 8.x)
RUN add-apt-repository ppa:ondrej/php && apt-get update
    
# instala os pacotes necessários para trabalhar com php-apache 
RUN apt install -y apache2 
RUN apt install -y libapache2-mod-php${php_version} 
RUN apt install -y php${php_version} 
RUN apt install -y php${php_version}-opcache 
RUN apt install -y php${php_version}-cli 
RUN apt install -y php${php_version}-xdebug 
RUN apt install -y php${php_version}-mysql 
RUN apt install -y php${php_version}-zip 
RUN apt install -y php${php_version}-curl 
RUN apt install -y php${php_version}-gd 
RUN apt install -y php${php_version}-xml 
RUN apt install -y php${php_version}-mbstring 
RUN apt install -y php${php_version}-fpm 
RUN apt install -y php${php_version}-ftp 
RUN apt install -y php${php_version}-common 
    
# instalando coposer   
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" 
RUN php composer-setup.php
RUN rm composer-setup.php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod a+x /usr/local/bin/composer

# habilitando ssl/reescrita de url (url amigaveis)
RUN a2enmod expires
RUN a2enmod rewrite
RUN a2enmod ssl

# expondo portas do docker para acesso a máquina fora do docker acessar
EXPOSE 80
EXPOSE 443

# diretório a ser utilizado no docker
WORKDIR /var/www/html

# executa ao inicar o container
ENTRYPOINT /etc/init.d/apache2 start && /bin/bash

CMD ["true"]