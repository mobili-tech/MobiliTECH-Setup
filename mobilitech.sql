CREATE DATABASE IF NOT EXISTS dbMobilitech;
USE dbMobilitech;

CREATE TABLE IF NOT EXISTS transporte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data DATE,
    grupo TEXT,
    lote CHAR(3),
    empresa TEXT,
    linha VARCHAR(255),
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
    codVerificacao VARCHAR(5),
    cnpj CHAR(18),
    razaoSocial VARCHAR(45),
	nomeFantasia VARCHAR(45),
	email VARCHAR(45),
	senha VARCHAR(25)
);

CREATE TABLE IF NOT EXISTS endereco (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
	cep CHAR(9),
	numero CHAR(5),
	cidade VARCHAR(45),
	estado VARCHAR(45),
	logradouro VARCHAR(45),
	complemento VARCHAR(45),
	fkEmpresa INT,
	CONSTRAINT fkEndEmp FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
) AUTO_INCREMENT = 101;

CREATE TABLE IF NOT EXISTS funcionarios (
	idFuncionario INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(45),
	email VARCHAR(100),
	cargo VARCHAR(45),
	fkEmpresa INT,
	CONSTRAINT fkEmpFunc FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
) AUTO_INCREMENT = 301;

CREATE TABLE IF NOT EXISTS veiculo (
	idVeiculo INT PRIMARY KEY AUTO_INCREMENT,
	tipo VARCHAR(45),
	capacidade INT
);

CREATE TABLE IF NOT EXISTS grupo (
	idGrupo INT PRIMARY KEY AUTO_INCREMENT,
	tipo VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS veiculoEmpresa(
	fkGrupo INT,
    fkVeiculo INT,
    fkEmpresa INT,
	CONSTRAINT fkGrupoVeiculo FOREIGN KEY (fkGrupo) REFERENCES grupo(idGrupo),
    CONSTRAINT fkVeiculoVeiculo FOREIGN KEY (fkVeiculo) REFERENCES veiculo(idVeiculo),
    CONSTRAINT fkEmpresaVeiculo FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa),
    PRIMARY KEY (fkGrupo, fkVeiculo, fkEmpresa)
);

CREATE TABLE IF NOT EXISTS linha (
	idLinha INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(45),
	qtdViagensIda INT,
	qtdViagensVolta INT,
	fkEmpresa INT,
    fkGrupo INT,
	CONSTRAINT fkGrupoLinha FOREIGN KEY (fkGrupo) REFERENCES grupo(idGrupo),
	CONSTRAINT fkEmpLinha FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE IF NOT EXISTS registro (
	idRegistro INT PRIMARY KEY auto_increment,
	fkLinha INT,
	fkEmpresa INT,
	dtRegistro DATETIME DEFAULT CURRENT_TIMESTAMP,
	qtdPassageiros INT DEFAULT 0,
	CONSTRAINT fkRegEmpresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa),
	CONSTRAINT fkRegLinha FOREIGN KEY (fkLinha) REFERENCES linha(idLinha)
);

