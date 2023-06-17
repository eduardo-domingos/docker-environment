# Descrição
Ambiente com foco em desenvolvimento Web com PHP

## Dockerfile e docker-compose
- Apache   2.4.5
- PHP      8.x (pode ser alterado no arquivo)
- Composer 2.5.7
- MariaDB  10.9
- Nodejs   18.x
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

* ./conf/php/php.ini:/etc/php/${php}/apache2/php.ini
    * é um arquivo de php.ini modificado

    #

* ./conf/ssl/localhost.key:/etc/ssl/ca/localhost.key
* ./conf/ssl/localhost.crt:/etc/ssl/ca/localhost.crt
    * arquivos para o SSL (certificado autoassinado), esse diretório é referenciado no arquivo de virtualhost.conf

    #

* ./conf/apache/virtualhost.conf:/etc/apache2/sites-enabled/000-default.conf
    * configuração do virtualhost (portas 80 e 443, SSL, reescrita de URL, .htaccess)

    #

* ./conf/db:/var/lib/mysql
   * persistência do dados do banco

   #

## Executar Ambiente Docker

- Quando for executar um projeto php, o mesmo precisa estar dentro da pasta www

- É necessário criar um .env dentro da pasta conf (siga o .env-example como exemplo) ali fica todas as variáveis de ambiente do projeto, seja do container de php e/ou do mysql/mariadb

- Todas as configurações dos containers estão centralizados no arquivo docker-compose.yml, assim só é necessário executar o comando abaixo:

~~~~
docker compose up -d
~~~~

- Caso a imagem do php precise de algum ajuste, basta editar o arquivo Dockerfile, para gerar uma nova imagem e executar o seguinte comando:

~~~
docker compose up -d --build
~~~