#!/bin/bash

echo "Iniciando configuração de ambiente..."

echo "Atualizando os pacotes do sistema"
sudo apt update && sudo apt upgrade -y

#configurando docker
echo "Verificando Docker..."

docker -v #verifica versao atual do docker

if [ $? = 0 ]; #se retorno for igual a 0
    
    then #entao,
        echo "Docker instalado" #print no terminal

    else #se nao,
        echo "Docker não instalado" #print no terminal
        echo "Gostaria de instalar o Docker? [s/n]" #print no terminal
        read get #variável que guarda resposta do usuário

        if [ "$get" = "s" ]; #se retorno for igual a s

            then #entao
            sudo apt install docker.io -y #executa instalacao do java

        fi #fecha o 2º if

fi #fecha o 1º if


#ativando servico do docker no s.o
sudo systemctl start docker

#habilitando docker para iniciar junto ao sistema
sudo systemctl enable docker

# Configurando banco de dados
echo "Configurando banco de dados..."
if [ "$(sudo docker ps -a -q -f name=ContainerDB)" ]; then

    echo "Container já existe. Iniciando..."
    sudo docker start ContainerDB

else

    echo "Criando novo container MySQL..."
    sudo docker pull mysql
    sudo docker run -d -p 3306:3306 --name ContainerDB -e "MYSQL_DATABASE=dbMobilitech" -e "MYSQL_ROOT_PASSWORD=urubu100" mysql

fi

# Aguardando MySQL subir
until sudo docker exec ContainerDB mysqladmin ping -h "localhost" -u root -purubu100 --silent; do
    echo "Aguardando MySQL subir..."
    sleep 3
done

# Copiando e executando script SQL
echo "Copiando script SQL para o container..."
sudo docker cp mobilitech.sql ContainerDB:/tmp/mobilitech.sql

echo "Executando script SQL..."
sudo docker exec ContainerDB \
    sh -c "mysql -u root -purubu100 dbMobilitech < /tmp/mobilitech.sql"

#configurando mobilitech
echo "Clonando repositório..."
sudo docker pull moiseshbs/mobilitech:1.0

sudo docker run -d -p 3333:3333 moiseshbs/mobilitech:1.0