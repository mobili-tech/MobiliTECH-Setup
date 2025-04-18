#!/bin/bash

echo "Iniciando configuração de ambiente..."

echo "Atualizando os pacotes do sistema"
sudo apt update && sudo apt upgrade -y


#configurando java
echo "Verificando Java..."

java -version #verifica versao atual do java

if [ $? = 0 ]; #se retorno for igual a 0
    
    then #entao,
        echo "Java instalado" #print no terminal

    else #se nao,
        echo "Java não instalado" #print no terminal
        echo "Gostaria de instalar o java? [s/n]" #print no terminal
        read get #variável que guarda resposta do usuário

        if [ "$get" = "s" ]; #se retorno for igual a s

            then #entao
            sudo apt install openjdk-21-jre-headless -y #executa instalacao do java

        fi #fecha o 2º if

fi #fecha o 1º if


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

#configurando mobilitech
echo "Clonando repositório..."
sudo docker pull moiseshbs/mobilitech:1.0

sudo docker run -d moiseshbs/mobilitech:1.0