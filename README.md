# Sobre o Projeto
A idea é ter um ambiente muito similar ao XAMPP para desenvolvimento web com php

## Tecnologias que estão na imagem
- Apache   2.4.x
- PHP      8.2.6
- Composer 2.5.7
- MariaDB  10.9
- Nodejs   12.22.9
- npm      8.5.1

## Recursos da imagem/container
- SSL 
- Reescrita de URL
- Reconhece arquivos .htaccess
- Strict Mode para banco de dados Desabilitado
- É feita a instalação do SASS de forma global
- Porta 80 sem SSL
- Porta 443 com SSL

## Volumes compartilhados docker-compose
* ./:/var/www/html 
    * tem relação com o WORKDIR do Dockerfile, será a pasta a onde ficarão os arquivos do projeto

* ./docker-conf/php/php.ini:/etc/php/8.2/apache2/php.ini
    * é um arquivo de php.ini modificado

* ./docker-conf/ssl/localhost.key:/etc/ssl/ca/localhost.key
* ./docker-conf/ssl/localhost.crt:/etc/ssl/ca/localhost.crt
    * arquivos para o SSL (certificado autoassinado)

* ./docker-conf/apache/virtualhost.conf:/etc/apache2/sites-enabled/000-default.conf
    * configuração do virtualhost (porta 80, 443, SSL, reescrita de URL)
