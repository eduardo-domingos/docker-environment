# Descrição
Ambiente com foco em desenvolvimento Web com PHP e Nodejs

## Dockerfile e docker-compose
- Apache   2.4.5
- PHP      8.2.6
- Composer 2.5.7
- MariaDB  10.9
- Nodejs   18.16.0
- NPM      9.5.1

## Recursos
- SSL 
- Reescrita de URL
- .htaccess
- Strict Mode para banco de dados Desabilitado
- Porta 443 com SSL
- Porta 80 sem SSL

## Volumes compartilhados docker-compose

- Todos os arquivos de configurações (php.ini, certificado etc..) ficam dentro da pasta docker-conf

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

## Executar Ambiente Docker

- É necessário criar um .env dentro da pasta docker-xampp (siga o .env-example como exemplo) ali fica todas as variáveis de ambiente do projeto, seja do container de php e/ou do mysql/mariadb

- Caso a imagem do php precise de algum ajuste, basta editar o arquivo Dockerfile, para gerar uma nova imagem e executar o seguinte comando:

~~~
docker compose up -d --build
~~~

- Todas as configurações dos containers estão centralizados no arquivo docker-compose.yml, assim só é necessário executar o comando abaixo:

~~~~
docker compose up -d
~~~~

- Quando for executar um projeto php com esse docker a pasta do mesmo projeto precisa ficar dentro da pasta docker-xampp