# Sobre o Projeto
A idea é ter um ambiente muito similar ao XAMPP para desenvolvimento web com php

## Tecnologias que estão na imagem
- Apache   2.4.5
- PHP      8.2.6
- Composer 2.5.7
- MariaDB  10.9
- Nodejs   18.16.0
- NPM      9.5.1

## Recursos da imagem/container
- SSL 
- Reescrita de URL
- Reconhece arquivos .htaccess
- Strict Mode para banco de dados Desabilitado
- Porta 80 sem SSL
- Porta 443 com SSL

## Volumes compartilhados docker-compose
* ./:/var/www/html 
    * tem relação com o WORKDIR do Dockerfile, será a pasta a onde ficarão os arquivos do projeto

    #

* ./docker-conf/php/php.ini:/etc/php/8.2/apache2/php.ini
    * é um arquivo de php.ini modificado

    #

* ./docker-conf/ssl/localhost.key:/etc/ssl/ca/localhost.key
* ./docker-conf/ssl/localhost.crt:/etc/ssl/ca/localhost.crt
    * arquivos para o SSL (certificado autoassinado), esse diretório é referenciado no arquivo de virtualhost.conf

    #

* ./docker-conf/apache/virtualhost.conf:/etc/apache2/sites-enabled/000-default.conf
    * configuração do virtualhost (porta 80, 443, SSL, reescrita de URL)

    #

* ./docker-conf/db:/var/lib/mysql
   * persistência do dados do banco

   #

- Todos esse arquivos de configurações ficam dentro da pasta docker-conf

## Executar projeto
Para construir a imagem
~~~
docker build -t seu-nome/nome-da-imagem:versao .
~~~

Para subir os containers
~~~
docker-compose up -d
~~~

