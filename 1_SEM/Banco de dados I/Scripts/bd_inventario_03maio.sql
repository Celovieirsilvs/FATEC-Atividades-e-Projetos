/**** Esquema de relações - Inventario de equipamentos e software - Postgresql
Empresa (cod_empresa(PK), rz_social, end_empresa, fone_empresa , cnpj, email, contato,tipo_empresa [fab/forn], situacao_empresa)
Fabricante (cod_fabr (PK)(FK), tipo_fabr [HW/SW], nacionalidade)
Fornecedor (cod_forn (PK)(FK))
Departamento (cod_depto(PK), nome_depto, ramal_depto, localizacao_depto, centro_custo)
Equipamento (num_patrimonio(PK), modelo_eqpto, num_serie_epto, dt_aquisicao_eqpto, 
   nota_fiscal_eqpto, valor_aquisicao_eqpto, tempo_garantia, tipo_eqpto, cod_fabr(FK)NN, cod_forn(FK)NN)
Computador (num_patr_comp(PK)(FK), tipo_processador, velocidade_processador, capacidade_armazenamento, 
            memoria_comp, tipo_computador)
Periferico (num_patr_perif(PK)(FK), tipo_perif, caracteristicas_perif)
Software (cod_softw(PK), nome_softw, versao_softw, tipo_softw, cod_fabr(FK)NN)
Instalacao_softw ( cod_softw(PK)(FK), num_patrimonio_comp(PK)(FK), dt_hora_instalacao(PK), dt_hora_desinstalacao, num_licenca)
Instalacao_perif (num_patrimonio_comp(PK)(FK), num_patrimonio_perif(PK)(FK), dt_hora_inst_perif(PK), dt_hora_retirada_perif)
Alocacao_eqpto ( num_patrimonio(PK)(FK), cod_depto(PK)(FK), dt_ini_alocacao(PK), dt_termino_alocacao)
******/
-- configurando o formato da data
SET DATESTYLE TO POSTGRES, DMY ;  
-- tabela departamento
DROP TABLE IF EXISTS departamento CASCADE; 
CREATE TABLE departamento (cod_depto SMALLINT PRIMARY KEY,
nome_depto CHAR(20) NOT NULL,
ramal_depto SMALLINT,
localizacao_depto VARCHAR(30) NOT NULL,
centro_custo CHAR(10) );
-- populando departamento
INSERT INTO departamento VALUES (1, 'Recursos Humanos', null, 'Sala 20', '10.5.2' );
SELECT * FROM departamento ;
INSERT INTO departamento VALUES (2, 'Administração', null, null, '11.1.1' );
-- atualizando a localização do depto 2
UPDATE departamento
       SET localizacao_depto = 'Sala 21'
	   WHERE cod_depto = 2 ;
-- tabela empresa
DROP TABLE IF EXISTS empresa CASCADE;
CREATE TABLE empresa (
cod_empresa SMALLSERIAL,
rz_social VARCHAR(50) NOT NULL,
end_empresa VARCHAR(100) NOT NULL,
fone_empresa NUMERIC(11) NOT NULL,
cnpj NUMERIC(14) NOT NULL,
email VARCHAR(32) NOT NULL,
contato VARCHAR(10), 
tipo_empresa CHAR(10) NOT NULL CHECK (tipo_empresa IN ('FABRICANTE', 'FORNECEDOR')), -- restrição de verificação
situacao_empresa CHAR(8) NOT NULL CHECK ( situacao_empresa IN ('ATIVA', 'INATIVA', 'SUSPENSA')),
PRIMARY KEY (cod_empresa),
UNIQUE(cnpj)) ;

-- alterar a estrutura da tabela
-- ALTER TABLE empresa ADD PRIMARY KEY (cod_empresa) ;


NUMERIC(p,s	   )
NUMERIC(6,2) 9999.99
NUMERIC(8,4) 9999.9999
NUMERIC(10) -> NUMERIC(10,0) -> 9999999999

desc departamento;
show table departamento ;

DROP TABLE IF EXITS Fabricante CASCADE;
CREATE TABLE fabricante (
cod_fabr SMALLINT NOT NULL,
tipo_fabr CHAR(4) NOT NULL,
nacionalidade VARCHAR(15)NOT NULL,
PRIMARY KEY(cod_fabr),
FOREIGN KEY(cod_fabr) REFERENCES empresa(cod_empresa)
   ON DELETE CASCADE ON UPDATE CASCADE);
-- reiniciar a sequencia a partir de 1
ALTER SEQUENCE empresa_cod_empresa_seq RESTART WITH 1;
-- testando as ações referenciais
INSERT INTO empresa VALUES (default, 'HP do Brasil Ltda', 'Av.Interlagos, 1000-Santo Amaro', 1198763432, 12345, 'hpbrasil@hpbrasil.com.br', 'Tenorio', 'FABRICANTE', 'ATIVA');
INSERT INTO empresa VALUES (default, 'ABC Equipamentos SA', 'Av.Nazare, 1500-Ipiranga', 11998877665, 'abcr@abc.com.br', null, 'FORNECEDOR', 'ATIVA') ;
--DELETE FROM fabricante WHERE cod_fabr = 100;
--DELETE FROM empresa WHERE cod_empresa = 2 OR cod_empresa = 3;

--populando fabricante
INSERT INTO fabricante(nacionalidade, cod_fabr, tipo_fabr)
VALUES('EUA', 3, 'HW');
--testar as ações referenciais em cascata
UPDATE empresa
   SET cod_empresa = 3
   WHERE cod_empresa = 1;
SELECT * FROM empresa;
SELECT * FROM fabricante;
-- excluir a HP
DELETE FROM empresa WHERE cod_empresa = 30;

-- tabela equipamento
DROP TABLE IF EXITS equipamento CASCADE;
CREATE TABLE Equipamento (
   num_patrimonio SERIAL PRIMARY KEY, 
modelo_eqpto VARCHAR(30) NOT NULL, 
num_serie_epto VARCHAR(20) NOT NULL, 
dt_aquisicao_eqpto DATE NOT NULL,  
   nota_fiscal_eqpto CHAR(10), 
   valor_aquisicao_eqpto NUMERIC(6,2), --NNN.NN
   tempo_garantia SMALLINT, 
   tipo_eqpto CHAR(10) NOT NULL, 
   cod_fabr SMALLINT REFERENCES fabricante(cod_fabr)
      ON DELETE SET NULL ON UPDATE CASCADE, 
   cod_forn SMALLINT REFERENCES empresa(cod_empresa)
         ON DELETE SET NULL ON UPDATE CASCADE) ;

--tabela computador
DROP TABLE IF EXIST Computador CASCADE;
CREATE TABLE Computador (
num_patr_comp INTEGER PRIMARY KEY REFERENCES equipamento(num_patrimonio)
    ON DELETE CASCADE ON UPDATE CASCADE, 
tipo_processador CHAR(10) NOT NULL,
velocidade_processador NUMERIC(3,1) , --3.6 2.8
capacidade_armazenamento_GB NUMERIC(7,1) NOT NULL,  
memoria_comp SMALLINT NOT NULL, 
tipo_computador CHAR(12) NOT NULL) ;
--definindo uma restrição de verificação para o tipo do computador
ALTER TABLE Computador ADD CHECK (tipo_computador IN ('NOTEBOOK', 'DESKTOP', 'SERVER', 'TABLET'));
-- populando equipamento e computador
ALTER TABLE equipamento ADD CHECK (tipo_eqpto IN ('COMPUTADOR', 'PERIFÉRICO'));
ALTER SEQUENCE equipamento_num_patrimonio_seq RESTART WITH 2022 ;
-- equipamento
INSERT INTO equipamento VALUES (default, 'Inspiron 5500', 'DLL12345', '10/01/2022', 'XYZ123', null, 24, 'COMPUTADOR', 1, 2);
INSERT INTO equipamento VALUES (default, 'Inspiron 5600', 'DLL98765', '20/02/2022', '123XYZ', null, 24, 'COMPUTADOR', 1, 2);
SELECT * FROM equipamento 
-- computador 
INSERT INTO compuatador VALUES (2022, 'I5', 3.4, 1000, 16, 'NOTEBOOK');
INSERT INTO compuatador VALUES (2022, 'I3', 3.6, 1000, 8, 'DESKTOP');
--verificando
SELECT * FROM equipamento;
SELECT * FROM Computador;

SELECT e.*, c.*
FROM equipamento e JOIN compuatador c
ON (e.num_patrimonio = c.num_patr_comp)
ORDER BY 1 ; 
-- tabela software
DROP TABLE IF EXISTS software CASCADE;
CREATE TABLE software (
cod_softw CHAR(6) PRIMARY KEY,
nome_softw VARCHAR(30) NOT NULL,
versao_softw CHAR(12),
tipo_softw VARCHAR(20) NOT NULL,
cod_fabr_softw INTEGER,
FOREIGN KEY (cod_fabr_softw) REFERENCES fabricante
ON DELETE SET NULL ON UPDATE CASCADE ) ;
-- tabela instalação do software no computador - relacionamento N:N
DROP TABLE IF EXISTS instalação_software CASCADE ;
CREATE TABLE instalação_software (
cod_softw CHAR(6) NOT NULL,
num_patr_comp INTEGER NOT NULL,
dt_hora_instalacao TIMESTAMP NOT NULL,
dt_hora_desinstalacao TIMESTAMP,
num_licenca CHAR(20) NOT NULL ) ;
/* ALTER TABLE - altera a estrutura das tabelas
renomear tabela, coluna. adicionar coluna, adicionar CHECK, adicionar PK e FK,
alterar tipo de dado, tamanho de coluna, nulo ou não, valor padrão(default) ****/
-- renomeando tabela
ALTER TABLE instalação_software RENAME TO instalacao_softw ;
-- renomeando coluna
ALTER TABLE instalacao_softw RENAME COLUMN dt_hora_instalacao TO dthora_inst ;
ALTER TABLE instalacao_softw RENAME COLUMN dt_hora_desinstalacao TO dthora_desinst ;
-- mudando de nulo para not null
ALTER TABLE software ALTER COLUMN versao_softw SET NOT NULL ;
-- mudando de not null para null
ALTER TABLE software ALTER COLUMN versao_softw DROP NOT NULL ;
-- mudando tamanho e tipo de dado de uma coluna
ALTER TABLE equipamento ALTER COLUMN nota_fiscal_eqpto TYPE VARCHAR(15) ;
-- atribuir um valor default para uma coluna
ALTER TABLE instalacao_softw ALTER COLUMN dthora_inst SET DEFAULT current_timestamp ;
ALTER TABLE equipamento ALTER COLUMN tempo_garantia SET DEFAULT 12 ;
-- adicionar novas colunas
ALTER TABLE equipamento ADD COLUMN dt_validade_garantia DATE,
ADD COLUMN situacao_eqpto CHAR(12) NULL ;
-- excuindo uma coluna
ALTER TABLE equipamento DROP COLUMN dt_validade_garantia ;
-- incluindo novamente
ALTER TABLE equipamento ADD COLUMN dt_validade_garantia DATE ;
-- definir o CHECK para situação do equipamento
ALTER TABLE equipamento ADD CHECK ( situacao_eqpto IN ('ATIVO', 'INATIVO', 'MANUTENCAO')) ;
SELECT num_patrimonio, modelo_eqpto, situacao_eqpto
FROM equipamento ;
-- atualizando a situação
UPDATE equipamento SET situacao_eqpto = 'ATIVO'
WHERE num_patrimonio IN (2022, 2023) ;
-- redefinindo situacao_eqpto como NOT NULL
ALTER TABLE equipamento ALTER COLUMN situacao_eqpto SET NOT NULL ;
-- nova empresa
INSERT INTO empresa VALUES (default,'Microsoft Corporation' , 'Av. Engenheiro Berrini, 2000-Vila Olimpia' ,
1150509090, 885522, 'microsoft@microsoft.com.br', null, 'FABRICANTE', 'ATIVA') ;
-- populando fabricante
SELECT * FROM empresa ;
INSERT INTO fabricante (nacionalidade, cod_fabr, tipo_fabr)
VALUES ('EUA', 3 , 'SW') ;
-- populando software
INSERT INTO software VALUES ( 'WIN11', 'Windows 11', 'Pro R14.3', 'SISOPER',3) ;
INSERT INTO software VALUES ( 'OFF365', 'Office 365', 'Pro R03.44', 'OFFICE',3) ;
SELECT * FROM software ;
-- populando instalação do software
INSERT INTO instalacao_softw VALUES ('WIN11', 2022, default, null, 'W98765' ) ;
INSERT INTO instalacao_softw VALUES ('WIN11', 2023,
current_timestamp - INTERVAL '10' HOUR, null, 'OF12345' ) ;
INSERT INTO instalacao_softw VALUES ('OFF365', 2022,
current_timestamp + INTERVAL '2' DAY, null, 'OF33441' ) ;
INSERT INTO instalacao_softw VALUES ('OFF365', 2023, default, null, 'W09876' ) ;



UPDATE instalacao_softw
SET dthora_desinst = current_timestamp - INTERVAL '10' MINUTE
WHERE cod_softw = 'OFF365' AND num_patr_comp = 2022
AND dthora_desinst IS NULL ;
SELECT current_timestamp;
-- verifica
SELECT table_name AS "nome tabela", column_name AS "nome coluna", data_type AS "tipo dado", is_nullable "Permite nulo"
FROM information_schema_colums
WHERE table_name = '';