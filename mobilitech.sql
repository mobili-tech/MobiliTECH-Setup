CREATE DATABASE IF NOT EXISTS dbMobilitech;
USE dbMobilitech;

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

-- Inserindo empresas
INSERT INTO empresa (cnpj, razaoSocial, nomeFantasia, email, senha)
SELECT * FROM (SELECT '12.345.678/0001-90', 'Transportes Urbanos SP Ltda', 'TransSP', 'contato@transsp.com', 'senha123') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM empresa WHERE email = 'contato@transsp.com');

INSERT INTO empresa (cnpj, razaoSocial, nomeFantasia, email, senha)
SELECT * FROM (SELECT '98.765.432/0001-10', 'Via Oeste Mobilidade', 'ViaOeste', 'suporte@viaoeste.com', 'senha456') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM empresa WHERE email = 'suporte@viaoeste.com');

-- Inserindo endereços
INSERT INTO endereco (idEndereco, Cep, Numero, Cidade, Estado, Logradouro, Complemento, fkEmpresa)
SELECT * FROM (SELECT 101, '01001-000', '1000', 'São Paulo', 'SP', 'Av. Paulista', '10º andar', 1) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM endereco WHERE idEndereco = 101);

INSERT INTO endereco (idEndereco, Cep, Numero, Cidade, Estado, Logradouro, Complemento, fkEmpresa)
SELECT * FROM (SELECT 102, '06233-000', '200', 'Osasco', 'SP', 'Rua das Rosas', 'Próximo ao terminal', 2) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM endereco WHERE idEndereco = 102);

-- Inserindo funcionários
INSERT INTO funcionarios (idFuncionario, nome, email, cargo, fkEmpresa)
SELECT * FROM (SELECT 301, 'João da Silva', 'joao@transsp.com', 'Gerente Operacional', 1) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM funcionarios WHERE idFuncionario = 301);

INSERT INTO funcionarios (idFuncionario, nome, email, cargo, fkEmpresa)
SELECT * FROM (SELECT 302, 'Maria Oliveira', 'maria@viaoeste.com', 'Coordenadora de Frota', 2) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM funcionarios WHERE idFuncionario = 302);

-- Inserindo linhas
INSERT INTO linha (idLinha, nome, num, qtdViagensIda, qtdViagensVolta, fkEmpresa)
SELECT * FROM (SELECT 401, 'Linha Centro-Bairro', 'C001', 12, 12, 1) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM linha WHERE idLinha = 401);

INSERT INTO linha (idLinha, nome, num, qtdViagensIda, qtdViagensVolta, fkEmpresa)
SELECT * FROM (SELECT 402, 'Linha Oeste-Leste', 'O123', 8, 8, 2) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM linha WHERE idLinha = 402);

-- Inserindo veículos
INSERT INTO veiculo (tipo, capacidade)
SELECT * FROM (SELECT 'Ônibus Articulado', 120) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM veiculo WHERE tipo = 'Ônibus Articulado');

INSERT INTO veiculo (tipo, capacidade)
SELECT * FROM (SELECT 'Micro-ônibus', 30) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM veiculo WHERE tipo = 'Micro-ônibus');

INSERT INTO veiculo (tipo, capacidade)
SELECT * FROM (SELECT 'Ônibus Convencional', 50) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM veiculo WHERE tipo = 'Ônibus Convencional');

-- Inserindo grupos (linha + veículo)
INSERT INTO grupo (fkLinha, fkVeiculo, tipo)
SELECT * FROM (SELECT 401, 1, 'Distribuição') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM grupo WHERE fkLinha = 401 AND fkVeiculo = 1);

INSERT INTO grupo (fkLinha, fkVeiculo, tipo)
SELECT * FROM (SELECT 401, 3, 'Distribuição') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM grupo WHERE fkLinha = 401 AND fkVeiculo = 3);

INSERT INTO grupo (fkLinha, fkVeiculo, tipo)
SELECT * FROM (SELECT 402, 2, 'Articulado') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM grupo WHERE fkLinha = 402 AND fkVeiculo = 2);

-- Inserindo registros de passageiros
INSERT INTO registro (idRegistro, fkLinha, fkEmpresa, dtRegistro, qtdPassageiros)
SELECT * FROM (SELECT 1000, 401, 1, '2025-04-14 08:00:00', 95) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM registro WHERE idRegistro = 1000);

INSERT INTO registro (idRegistro, fkLinha, fkEmpresa, dtRegistro, qtdPassageiros)
SELECT * FROM (SELECT 1001, 402, 2, '2025-04-14 08:30:00', 28) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM registro WHERE idRegistro = 1001);

INSERT INTO registro (idRegistro, fkLinha, fkEmpresa, dtRegistro, qtdPassageiros)
SELECT * FROM (SELECT 1002, 401, 1, '2025-04-14 12:00:00', 110) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM registro WHERE idRegistro = 1002);

INSERT INTO registro (idRegistro, fkLinha, fkEmpresa, dtRegistro, qtdPassageiros)
SELECT * FROM (SELECT 1003, 402, 2, '2025-04-14 17:45:00', 31) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM registro WHERE idRegistro = 1003);