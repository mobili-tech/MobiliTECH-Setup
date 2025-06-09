#!/bin/bash

#variaveis apachepoi.jar
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
export DB_HOST="jdbc:mysql://127.0.0.1:3306/dbMobilitech"
export DB_PSWD="urubu100"
export DB_USER="root"

#variaveis DBcontainer
export ROOT_PASSWORD="urubu100"

echo "Iniciando configuração de ambiente..."

if [ "$(sudo docker ps -f name=mobilitechapachepoi)" ]; then
    sudo docker rm mobilitechapachepoi
fi

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

sudo docker network create rede-mobilitech

# Configurando banco de dados
echo "Configurando banco de dados..."
if [ "$(sudo docker ps -a -q -f name=ContainerDB)" ]; then

    echo "Container já existe. Iniciando..."
    sudo docker start ContainerDB

else

    echo "Criando novo container MySQL..."
    sudo docker pull mysql
    sudo docker run -d -p 3306:3306 --name ContainerDB --network rede-mobilitech -e MYSQL_DATABASE=dbMobilitech -e MYSQL_ROOT_PASSWORD="$ROOT_PASSWORD" mysql

    # Aguardando MySQL subir
    until sudo docker exec ContainerDB mysqladmin ping -h "127.0.0.1" -u root -p"$ROOT_PASSWORD" --silent; do
        echo "Aguardando MySQL subir..."
        sleep 3
    done

    # Copiando e executando script SQL
    echo "Copiando script SQL para o container..."
    sudo docker cp mobilitech.sql ContainerDB:/tmp/mobilitech.sql

    echo "Executando script SQL..."
    sudo docker exec ContainerDB \
        sh -c "mysql -h "localhost" -u root -p$ROOT_PASSWORD dbMobilitech < /tmp/mobilitech.sql"

fi


#configurando mobilitech
echo "Clonando repositório..."
if [ "$(sudo docker ps -a -q -f name=mobilitech)" ]; then

    echo "Container já existe. Iniciando..."
    sudo docker start mobilitech

else

    echo "Criando um novo container MobiliTECH..."
    sudo docker pull moiseshbs/mobilitech:latest
    sudo docker pull calace/mobilitechapachepoi:latest
    sudo docker run -d --name mobilitech -p 3333:3333 moiseshbs/mobilitech:latest

fi

#Configurando o ApachePOI.jar
java --version #verifica versao atual do docker

if [ $? = 0 ]; #se retorno for igual a 0
    
    then #entao,
        echo "Java instalado" #print no terminal

    else #se nao,
        echo "Java não instalado" #print no terminal
        echo "Gostaria de instalar o Java? [s/n]" #print no terminal
        read get #variável que guarda resposta do usuário

        if [ "$get" = "s" ]; #se retorno for igual a s

            then #entao
            sudo apt install openjdk-21-jdk -y #executa instalacao do java

        fi #fecha o 2º if

fi #fecha o 1º if
sudo docker run --name mobilitechapachepoi --network rede-mobilitech -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" -e AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN" calace/mobilitechapachepoi:latest
