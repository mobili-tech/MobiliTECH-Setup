CREATE DATABASE IF NOT EXISTS dbMobilitech;
USE dbMobilitech;

CREATE TABLE IF NOT EXISTS transporte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data DATE,
    grupo TEXT,
    lote CHAR(3),
    empresa TEXT,
    linha VARCHAR(255),
    
    passageiros_dinheiro INT,
    passageiros_comum_vt INT,
    passageiros_comum_m INT,
    passageiros_estudante INT,
    passageiros_estudante_mensal INT,
    passageiros_vt_mensal INT,
    passageiros_pagantes INT,
    passageiros_integracao INT,
    passageiros_gratuidade INT,
    passageiros_total INT,
    
    partidas_ponto_inicial INT,
    partidas_ponto_final INT
);
CREATE TABLE IF NOT EXISTS log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,       -- Tipo de log: INFO, ERROR, WARNING, etc.
    informacao VARCHAR(255) NOT NULL, -- Informações gerais do log
    descricao TEXT NOT NULL,          -- Descrição detalhada do log
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- A data e hora em que o log foi registrado
);

CREATE TABLE IF NOT EXISTS empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    cnpj CHAR(18),
    razaoSocial VARCHAR(45),
	nomeFantasia VARCHAR(45),
	email VARCHAR(45),
	senha VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS endereco (
	idEndereco INT PRIMARY KEY,
	Cep CHAR(9),
	Numero CHAR(5),
	Cidade VARCHAR(45),
	Estado VARCHAR(45),
	Logradouro VARCHAR(45),
	Complemento VARCHAR(45),
	fkEmpresa INT UNIQUE,
	CONSTRAINT fkEndEmp FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
) AUTO_INCREMENT = 101;

CREATE TABLE IF NOT EXISTS funcionarios (
	idFuncionario INT PRIMARY KEY,
	nome VARCHAR(45),
	email VARCHAR(100),
	cargo VARCHAR(45),
	fkEmpresa INT UNIQUE,
	CONSTRAINT fkEmpFunc FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
) AUTO_INCREMENT = 301;

CREATE TABLE IF NOT EXISTS linha (
	idLinha INT PRIMARY KEY,
	nome VARCHAR(45),
	num VARCHAR(7),
	qtdViagensIda INT,
	qtdViagensVolta INT,
	fkEmpresa INT UNIQUE,
	CONSTRAINT fkEmpLinha FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
) AUTO_INCREMENT = 401;

CREATE TABLE IF NOT EXISTS veiculo (
	idVeiculo INT PRIMARY KEY AUTO_INCREMENT,
	tipo VARCHAR(45),
	capacidade INT
);

CREATE TABLE IF NOT EXISTS grupo (
	idGrupo INT PRIMARY KEY AUTO_INCREMENT,
	fkLinha INT,
	fkVeiculo INT,
	tipo VARCHAR(45),
	CONSTRAINT fkGrupoLinha FOREIGN KEY (fkLinha) REFERENCES linha(idLinha),
	CONSTRAINT fkGrupoVeiculo FOREIGN KEY (fkVeiculo) REFERENCES veiculo(idVeiculo)
);

CREATE TABLE IF NOT EXISTS registro (
	idRegistro INT PRIMARY KEY,
	fkLinha INT,
	fkEmpresa INT,
	dtRegistro DATETIME,
	qtdPassageiros INT,
	CONSTRAINT fkRegEmpresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa),
	CONSTRAINT fkRegLinha FOREIGN KEY (fkLinha) REFERENCES linha(idLinha)
) AUTO_INCREMENT = 1000;