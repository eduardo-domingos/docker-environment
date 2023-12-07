# Descrição
Ambiente com foco em desenvolvimento Web com PHP

## Dockerfile e docker-compose
- Apache   2.4.5
- PHP      7.1
- Composer 2.5.7
- MariaDB  10.4

## Recursos
- SSL 
- Reescrita de URL
- .htaccess
- Strict Mode para banco de dados Desabilitado
- Porta 443 com SSL
- Porta 80 sem SSL

## Limitar uso de memória ram e processador
Na raiz do projeto possuí um arquivo chamado ".wslconfig"
basta mover esse arquivo para a pasta de C:\users\SeuUsuario\
e reiniciar a máquina