# imagem base
FROM ubuntu:latest

# variáveis de ambiente
ENV timezone=America/Sao_Paulo
ENV php=php8.2

# instala as atualizações
RUN apt-get update && apt-get upgrade -y

# define o data/hora como São Paulo
RUN ln -snf /usr/share/zoneinfo/${timezone} /etc/localtime && echo ${timezone} > /etc/timezone

# adicionar repositório para externo do php (5.6 até 8.2)
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ondrej/php 
RUN apt-get update
    
# instala os pacotes necessários para trabalhar com php-apache 
RUN apt-get install -y apache2 
RUN apt-get install -y libapache2-mod-php 
RUN apt-get install -y ${php} 
RUN apt-get install -y ${php}-opcache 
RUN apt-get install -y ${php}-cli
RUN apt-get install -y ${php}-xdebug 
RUN apt-get install -y ${php}-mysql 
RUN apt-get install -y ${php}-zip
RUN apt-get install -y ${php}-curl
RUN apt-get install -y ${php}-gd
RUN apt-get install -y ${php}-xml
RUN apt-get install -y ${php}-mbstring
RUN apt-get install -y ${php}-fpm
RUN apt-get install -y ${php}-ftp
    
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
RUN mkdir /etc/ssl/ca

# instalação do NodeJs
RUN apt-get install -y curl
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - 
RUN apt-get install -y nodejs
#RUN npm install -g sass

# expondo portas do docker para acesso a máquina fora do docker acessar
EXPOSE 80
EXPOSE 443

# diretório a ser utilizado no docker
WORKDIR /var/www/html

# executa ao inicar o container
ENTRYPOINT /etc/init.d/apache2 start && /bin/bash

CMD ["true"]