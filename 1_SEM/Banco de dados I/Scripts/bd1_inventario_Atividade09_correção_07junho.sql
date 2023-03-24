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

/* Aula 10/maio/22 ****/
-- tabela fabricante Fabricante (cod_fabr (PK)(FK), tipo_fabr [HW/SW], nacionalidade)
DROP TABLE IF EXISTS fabricante CASCADE ;
CREATE TABLE fabricante (
cod_fabr SMALLINT NOT NULL,
tipo_fabr CHAR(4) NOT NULL,
nacionalidade VARCHAR(15) NOT NULL,
PRIMARY KEY(cod_fabr),
FOREIGN KEY (cod_fabr) REFERENCES empresa(cod_empresa)
	ON DELETE CASCADE ON UPDATE CASCADE ) ; 

-- reiniciar a sequencia a partir de 1
ALTER SEQUENCE empresa_cod_empresa_seq RESTART WITH 1 ;
-- testando as ações referenciais
DELETE FROM empresa ;
INSERT INTO empresa VALUES (default,'HP do Brasil Ltda' , 'Av. Interlagos, 1000-Santo Amaro' ,
						   1198765432, 12345, 'hpbrasil@hpbrasil.com.br', 'Tenorio', 'FABRICANTE', 'ATIVA') ;
SELECT * FROM empresa;
-- DELETE FROM empresa WHERE cod_empresa = 2 OR cod_empresa = 3 ;
INSERT INTO empresa VALUES (default,'ABC Equipamentos SA' , 'Av. Nazare, 1500-Ipiranga' ,
						   11998877665, 98765, 'abcr@abc.com.br', null,  'FORNECEDOR', 'ATIVA') ;
-- populando fabricante
INSERT INTO fabricante (nacionalidade, cod_fabr, tipo_fabr)
 VALUES ('EUA', 1 , 'HW') ;
/* testar as ações referenciais em cascata - HP código 100 -> código 111
DELETE FROM fabricante WHERE cod_fabr = 111 ;
UPDATE empresa
    SET cod_empresa = 111 
	WHERE cod_empresa = 100 ;
SELECT * FROM empresa ;
SELECT * FROM fabricante ;
-- excluir a HP
DELETE FROM empresa WHERE cod_empresa = 111 ; */
-- verificando o fabricante
SELECT * FROM fabricante ;

-- tabela equipamento
DROP TABLE IF EXISTS equipamento CASCADE;
CREATE TABLE equipamento (
num_patrimonio SERIAL PRIMARY KEY,
modelo_eqpto VARCHAR(30) NOT NULL,
num_serie_eqpto VARCHAR(20) NOT NULL,
dt_aquisicao_eqpto DATE NOT NULL, 
nota_fiscal_eqpto CHAR(10),
valor_aquisicao_eqpto NUMERIC(6,2),  -- NNNN.NN
tempo_garantia SMALLINT,
tipo_eqpto CHAR(10) NOT NULL,
cod_fabr SMALLINT REFERENCES fabricante(cod_fabr)
	ON DELETE SET NULL ON UPDATE CASCADE ,
cod_forn SMALLINT REFERENCES empresa(cod_empresa)
    ON DELETE SET NULL ON UPDATE CASCADE ) ;
	
-- tabela computador
DROP TABLE IF EXISTS computador CASCADE;
CREATE TABLE computador (
num_patr_comp INTEGER PRIMARY KEY REFERENCES equipamento(num_patrimonio)
	ON DELETE CASCADE ON UPDATE CASCADE,
tipo_processador CHAR(10) NOT NULL,
velocidade_processador NUMERIC(3,1) NOT NULL ,  --3.6 12.8
capacidade_armazenamento_GB NUMERIC(7,1) NOT NULL,
memoria_comp SMALLINT NOT NULL,
tipo_computador CHAR(12) NOT NULL) ;
-- definindo uma restrição de verificação para o tipo do computador
ALTER TABLE computador ADD CHECK 
(tipo_computador IN ('NOTEBOOK', 'DESKTOP', 'SERVIDOR', 'TABLET')) ;
-- populando equipamento e computador
ALTER TABLE equipamento ADD CHECK (tipo_eqpto IN ('COMPUTADOR', 'PERIFERICO'));
ALTER SEQUENCE equipamento_num_patrimonio_seq RESTART WITH 2022 ;
-- equipamento
INSERT INTO equipamento VALUES ( default, 'Inspiron 5500', 'DLL12345', '10/01/2022' ,
		'XYZ123', null, 24, 'COMPUTADOR', 1, 2) ;					
INSERT INTO equipamento VALUES ( default, 'Inspiron 5600', 'DLL98765', '20/02/2022' ,
		'123XYZ', 5000, 24, 'COMPUTADOR', 1, 2) ;
-- computador
INSERT INTO computador VALUES ( 2022, 'I5', 3.4, 1000, 16, 'NOTEBOOK') ;
INSERT INTO computador VALUES ( 2023, 'I3', 3.6, 1000, 8, 'DESKTOP') ;
-- verificando
SELECT * FROM equipamento ;
SELECT * FROM computador ;

SELECT e.*, c.*
FROM equipamento e JOIN computador c 
ON ( e.num_patrimonio = c.num_patr_comp)
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
-- definir as chaves de instalação do software
ALTER TABLE instalação_software ADD PRIMARY KEY ( cod_softw, num_patr_comp, dt_hora_instalacao) ;
ALTER TABLE instalação_software ADD FOREIGN KEY ( cod_softw) REFERENCES software
            ON DELETE CASCADE ON UPDATE CASCADE ; 
ALTER TABLE instalação_software ADD FOREIGN KEY (num_patr_comp) REFERENCES computador
            ON DELETE CASCADE ON UPDATE CASCADE ; 
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
SELECT current_timestamp ;
-- nova empresa
INSERT INTO empresa VALUES (default,'Microsoft Corporation' , 'Av. Engenheiro Berrini, 2000-Vila Olimpia' ,
						   1150509090, 885522, 'microsoft@microsoft.com.br', null,  'FABRICANTE', 'ATIVA') ;
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
WHERE cod_softw = 'OFF365' AND  num_patr_comp = 2022
AND dthora_desinst IS NULL ;

-- formato de timestamp '01/02/2022 12:30:05.988'

SELECT * FROM instalacao_softw ;
-- verifica a estrutura da tabela
SELECT table_name AS "nome tabela", column_name AS "nome coluna" , 
data_type AS "tipo dado", is_nullable "Permite nulo"
FROM information_schema.columns
WHERE table_name = 'instalacao_softw' ;
/* 
Atividade 06
1- Montar o script em SQL para a criação das tabelas :Periférico, Instalação do periférico no computador
e Alocação do Equipamento no Departamento no SGBD Postgresql, baseando-se no esquema de relações feito em aula .*/ 
--periferico
DROP TABLE IF EXISTS periferico CASCADE;
CREATE TABLE periferico(
num_patr_perif INTEGER NOT NULL,
tipo_perif VARCHAR(20),
desc_perif VARCHAR(30),
PRIMARY KEY (num_patr_perif),
FOREIGN KEY (num_patr_perif) REFERENCES equipamento(num_patrimonio)
ON DELETE CASCADE ON UPDATE CASCADE);

ALTER TABLE periferico ADD COLUMN caracteristicas VARCHAR(30);
-- população
SELECT * FROM equipamento ; -- 2 computadores
INSERT INTO equipamento VALUES ( default, 'Mouse sem Fio WM126', 'PRS123', '22/04/2022' ,
		'KKKH45', 100, 24, 'PERIFERICO', 1, 2, 'ATIVO') ;
INSERT INTO equipamento VALUES ( default, 'Monitor Dell E2222HS', 'QYTF123', '20/05/2022' ,
		'KGT987', 1159.99, 24, 'PERIFERICO', 1, 2, 'ATIVO') ;
INSERT INTO equipamento VALUES ( default, 'Monitor Dell E2222HS', 'QYTF123', '20/05/2022' ,
		'KGT765', 1159.99, 24, 'PERIFERICO', 1, 2, 'ATIVO') ;		
-- periferico 2025 - 2026 - 2027
INSERT INTO periferico(num_patr_perif, tipo_perif, desc_perif,caracteristicas)VALUES
(2025,'mouse','sem fio','1000ppp, 3 botoes');
INSERT INTO periferico(num_patr_perif, tipo_perif, desc_perif,caracteristicas)VALUES
(2026,'monitor','LCD Full HD','1920x1080 60Hz');
INSERT INTO periferico(num_patr_perif, tipo_perif, desc_perif,caracteristicas)VALUES
(2027,'monitor','LCD Full HD','1920x1080 60Hz');

SELECT * FROM periferico ;
-- Instalação do periférico no computador
DROP TABLE IF EXISTS alocacao_periferico CASCADE;
CREATE TABLE alocacao_periferico(
num_patr_perif_aloc INTEGER NOT NULL,
num_patr_comp_aloc INTEGER NOT NULL,
dt_ini_aloc TIMESTAMP NOT NULL,
dt_term_aloc TIMESTAMP,
PRIMARY KEY (num_patr_perif_aloc,dt_ini_aloc,num_patr_comp_aloc),
FOREIGN KEY (num_patr_perif_aloc) REFERENCES equipamento(num_patrimonio) 
	ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (num_patr_comp_aloc) REFERENCES equipamento(num_patrimonio)
ON DELETE CASCADE ON UPDATE CASCADE);

ALTER TABLE alocacao_periferico ADD CHECK (dt_term_aloc >= dt_ini_aloc);
-- populando
SELECT * FROM computador ;
INSERT INTO alocacao_periferico(num_patr_perif_aloc, dt_ini_aloc, dt_term_aloc,num_patr_comp_aloc) VALUES
(2025,CURRENT_TIMESTAMP - INTERVAL '10 DAYS 5 HOURS',null,2022);
INSERT INTO alocacao_periferico(num_patr_perif_aloc, dt_ini_aloc, dt_term_aloc,num_patr_comp_aloc) VALUES
(2026,CURRENT_TIMESTAMP - INTERVAL '10 DAYS 6 HOURS 30 MINUTES 25 SECONDS',null,2022);
INSERT INTO alocacao_periferico(num_patr_perif_aloc, dt_ini_aloc, dt_term_aloc,num_patr_comp_aloc) VALUES
(2027,CURRENT_TIMESTAMP - INTERVAL '2 DAYS 6 HOURS 30 MINUTES 25 SECONDS',null ,2023);
-- alocação eqpto no departamento
-- Alocacao_eqpto ( num_patrimonio(PK)(FK), cod_depto(PK)(FK), dt_ini_alocacao(PK), dt_termino_alocacao)
DROP TABLE IF EXISTS alocacao_eqpto CASCADE ;
CREATE TABLE alocacao_eqpto (
num_patr_eqpto INTEGER NOT NULL REFERENCES equipamento
	ON DELETE CASCADE ON UPDATE CASCADE,
cod_depto SMALLINT NOT NULL REFERENCES departamento
   ON DELETE CASCADE ON UPDATE CASCADE,
dt_ini_alocacao TIMESTAMP,
dt_term_alocacao TIMESTAMP,
PRIMARY KEY ( num_patr_eqpto, cod_depto, dt_ini_alocacao) );
-- populando
INSERT INTO alocacao_eqpto VALUES ( 2022, 1, current_timestamp - INTERVAL '10 DAYS', null),
( 2023, 2, current_timestamp - INTERVAL '9 DAYS', null) ;
SELECT * FROM alocacao_eqpto ;

/* 2- Com o comando ALTER TABLE : 
a) Inclua uma nova coluna em Periférico com a Situação: Instalado ou Disponível. Atualize os dados.*/
ALTER TABLE periferico ADD COLUMN situacao_perif CHAR(10) 
CHECK ( situacao_perif IN ( 'INSTALADO', 'DISPONIVEL')) ;
UPDATE periferico SET situacao_perif = 'INSTALADO'
WHERE num_patr_perif IN (2025, 2026, 2027) ;

b) Crie as seguintes constraints de verificação : 
		Tipo em Software: SISOPER, OFFICE, SGBD, CASE ou DESENVOLVIMENTO;
		Velocidade, Memória e Capacidade de armazenamento em Computador nunca negativos 
ALTER TABLE software ADD CHECK ( tipo_softw IN ( 'SISOPER', 'OFFICE', 'SGBD', 'CASE', 'DESENVOLVIMENTO'));
ALTER TABLE software ALTER COLUMN tipo_softw TYPE VARCHAR(15);
ALTER TABLE computador ADD CHECK ( velocidade_processador > 0);
ALTER TABLE computador ADD CHECK ( capacidade_armazenamento_gb > 0);
ALTER TABLE computador ADD CHECK ( memoria_comp > 0);
--c) Renomeie as colunas velocidade_processador para velocidade_proc_GHZ, memoria_comp para memoria_comp_GB;
ALTER TABLE computador RENAME COLUMN velocidade_processador TO velocidade_proc_GHZ;
ALTER TABLE computador RENAME COLUMN memoria_comp TO memoria_comp_GB;
--d) Renomeie a tabela Instalacao_periferico para Perifericos_Instalados ;
ALTER TABLE alocacao_periferico RENAME TO perifericos_instalados ;
--e) Altere o tipo de dados de alguma coluna CHAR para VARCHAR;
ALTER TABLE departamento ALTER COLUMN nome_depto TYPE VARCHAR(25) ;
--f) Coloque valores default para todas as colunas que indiquem Valor e para a data e hora das instalações.
ALTER TABLE alocacao_eqpto ALTER COLUMN dt_ini_alocacao SET DEFAULT current_timestamp ;
ALTER TABLE perifericos_instalados ALTER COLUMN dt_ini_aloc SET DEFAULT current_timestamp ;
ALTER TABLE instalacao_softw ALTER COLUMN dthora_inst SET DEFAULT current_timestamp ;
--3 – Insira 3 linhas para cada tabela criada em 1

/*****************************
Aula 17/maio - SELECT 
*******************************/
INSERT INTO departamento VALUES (3, 'Suporte TI',22 , 'Sala 34', '15.1.3' );
INSERT INTO empresa VALUES (default, 'LG Eletronics Corporation', 'Rua Coreia, 200', 93821, 34198, 
'lgeletronics@lg.com.br', 'Sun Yang', 'FABRICANTE', 'ATIVA'); --4
INSERT INTO empresa VALUES (default, 'Matrix Equipamentos S/A', 'Avenida Cursino, 1089', 71926, 919192, 
'matrix@matrix.com.br', 'Rebecca', 'FORNECEDOR', 'ATIVA'); --5
INSERT INTO fabricante (nacionalidade, cod_fabr, tipo_fabr)
 VALUES ('KOR', 4 , 'HW') ;
SELECT * FROM empresa ;
INSERT INTO equipamento VALUES ( default, 'HPE ProLiant ML30 Gen10 Server', 'HP5412A4', '10/03/2022' ,
		'765WHP', 9899.99, 36, 'COMPUTADOR', 3, 5, 'ATIVO') ; --2029
INSERT INTO equipamento VALUES ( default, 'AMD Freesync', 'LG3412', '01/01/2021' ,
		'64W12A', 2123.98, 24, 'PERIFERICO', 4, 5, 'ATIVO' ) ; -- 2032
SELECT * FROM equipamento ;
-- computador
ALTER TABLE computador ALTER COLUMN tipo_processador TYPE VARCHAR(20);
INSERT INTO computador VALUES ( 2029, 'Xeon E-2224', 3.4, 4000, 64, 'SERVIDOR') ;
-- periferico
INSERT INTO periferico(num_patr_perif, tipo_perif, desc_perif,caracteristicas, situacao_perif)
VALUES (2032,'monitor','IPS Full HD','1920x1080 75Hz', 'DISPONIVEL');

-- Funções caracter
--1)Mostrar a razao social, endereço e contato de todas as empresas */
SELECT rz_social, end_empresa, contato
FROM empresa
ORDER BY 3 DESC ,1 ASC
LIMIT 1;
 
SELECT modelo_eqpto, num_serie_eqpto, situacao_eqpto
FROM equipamento ;

--2) Formatação de caracteres
SELECT UPPER(modelo_eqpto) AS MAIUSCULA, 
LOWER(num_serie_eqpto) AS minuscula, 
INITCAP(situacao_eqpto) AS "Começa MAIUSC resto minusc"
FROM equipamento ;

--3) Operador de concatenação
SELECT 'Empresa '||UPPER(rz_social)||' está localizada em '||
LOWER(end_empresa)||' e quem atende é '||INITCAP(contato) AS "Dados empresa"
FROM empresa
ORDER BY 1 ;

SELECT UPPER('Empresa '||rz_social||' está localizada em '||
end_empresa||' e quem atende é '||contato) AS "Dados empresa"
FROM empresa
ORDER BY 1 ;

SELECT UPPER('Empresa '||rz_social||' de CNPJ : '||
TO_CHAR(cnpj, 'L00099999D999')||' está localizada em '||
end_empresa||' e quem atende é '||contato) AS "Dados empresa"
FROM empresa
ORDER BY 1 ;
-- 4) clausula WHERE
SELECT num_patrimonio, modelo_eqpto, 
TO_CHAR(dt_aquisicao_eqpto, 'DD/MON/YY') AS "Data Aquisição",
TO_CHAR(valor_aquisicao_eqpto, 'L009999.99') AS Valor_eqpto
FROM equipamento
WHERE tipo_eqpto != 'COMPUTADOR' ;
-- 5) operador Like
SELECT rz_social FROM empresa ;
SELECT rz_social, end_empresa
FROM empresa
WHERE rz_social LIKE '%equipamento%' ;

SELECT rz_social, end_empresa
FROM empresa
WHERE LOWER(rz_social) LIKE '%quipa%' ;

SELECT rz_social, end_empresa
FROM empresa
WHERE UPPER(rz_social) LIKE '%LTDA' ;

UPDATE empresa SET end_empresa = 'Av. São João, 550'
WHERE cod_empresa = 5 ;

SELECT rz_social, end_empresa
FROM empresa
WHERE UPPER(end_empresa) LIKE '%JO_O%' ;

SELECT rz_social, end_empresa
FROM empresa
WHERE UPPER(rz_social) LIKE 'A%' ;

SELECT rz_social, end_empresa
FROM empresa
WHERE UPPER(end_empresa) LIKE '%JO_O%' 
AND UPPER(rz_social) LIKE '%LTDA%' ;
-- 6) WHERE com AND e OR
SELECT rz_social, end_empresa
FROM empresa
WHERE UPPER(end_empresa) LIKE '%JO_O%' 
OR UPPER(rz_social) LIKE '%LTDA%' ;

SELECT rz_social, end_empresa, cnpj
FROM empresa
WHERE UPPER(end_empresa) NOT LIKE '%AV%' 
OR ( UPPER(rz_social) LIKE '%LTDA%' AND 
     cnpj < 10000 ) ;
-- 7) Manipulação de datas
-- data e horra atuais
SELECT current_date AS "Data Atual",
current_timestamp AS "Data Horta Atual" ;
--8) operador EXTRACT - extrai um pedaço específico da DATABASE
SELECT num_patrimonio, modelo_eqpto,
dt_aquisicao_eqpto, 
EXTRACT ( YEAR FROM dt_aquisicao_eqpto) AS "Ano aquisição",
EXTRACT ( MONTH FROM dt_aquisicao_eqpto) AS "Mês aquisição"
FROM equipamento
WHERE EXTRACT ( YEAR FROM dt_aquisicao_eqpto) =
      EXTRACT ( YEAR FROM current_date) ;

SELECT 	current_timestamp AS "Data Hora Atual" ,
EXTRACT (HOUR FROM current_timestamp) AS Hora_atual,
EXTRACT (MINUTE FROM current_timestamp) AS Minuto_atual,
EXTRACT (SECOND FROM current_timestamp) AS Segundo_atual ;
-- 9) operador BETWEEN
SELECT *, EXTRACT ( HOUR FROM dt_ini_aloc) AS "Corujão da instalação"
FROM perifericos_instalados
WHERE EXTRACT ( HOUR FROM dt_ini_aloc) BETWEEN 0 AND 3 ;
-- equivalente do between
SELECT *, EXTRACT ( HOUR FROM dt_ini_aloc) AS "Corujão da instalação"
FROM perifericos_instalados
WHERE EXTRACT ( HOUR FROM dt_ini_aloc) >= 0
AND  EXTRACT ( HOUR FROM dt_ini_aloc) <= 3 ;
-- 10) operador INTERVAL
SELECT eq.*
FROM equipamento eq
WHERE eq.dt_aquisicao_eqpto >= current_date - INTERVAL '60' DAY ;

SELECT eq.*
FROM equipamento eq
WHERE eq.dt_aquisicao_eqpto >= current_date - INTERVAL '2' MONTH ;

SELECT current_timestamp + INTERVAL '1' DAY + INTERVAL '30' MINUTE
AS "Amanhã depois da aula. Free!!!",
current_timestamp - INTERVAL '1' DAY - INTERVAL '2' HOUR 
AS "Ontem durante a aula. Prison" ;

SELECT eq.*
FROM equipamento eq
WHERE eq.dt_aquisicao_eqpto BETWEEN current_date - INTERVAL '3' MONTH
AND current_date - INTERVAL '2' MONTH ;

--11) Mostrar os perifericos instalados hoje
SELECT * FROM perifericos_instalados ;

UPDATE perifericos_instalados
SET dt_ini_aloc = current_timestamp
WHERE num_patr_perif_aloc = 2027 ;

SELECT num_patr_perif_aloc
FROM perifericos_instalados
--WHERE dt_ini_aloc = current_timestamp ;
WHERE TO_CHAR(dt_ini_aloc, 'DD/MM/YYYY')  = TO_CHAR(current_timestamp, 'DD/MM/YYYY') ;

/* Atividade 7 */
-- a)	Mostrar as empresas fabricantes que não são Ltda, no formato :
--  Razão Social – Tipo Empresa – CNPJ - Endereço
SELECT rz_social, tipo_empresa, cnpj, end_empresa
FROM empresa
WHERE tipo_empresa = 'FABRICANTE'
AND UPPER(rz_social) NOT LIKE '%LTDA%'  ;

-- b)	Mostrar todos os dados dos equipamentos adquiridos neste mês, utilizando apelido para a(s) tabela(s).
SELECT eq.*
FROM equipamento eq
WHERE EXTRACT(MONTH FROM eq.dt_aquisicao_eqpto) = 
      EXTRACT(MONTH FROM current_date)
AND EXTRACT(YEAR FROM eq.dt_aquisicao_eqpto) = 
      EXTRACT(YEAR FROM current_date) ;
      
SELECT eq.*
FROM equipamento eq
WHERE TO_CHAR(eq.dt_aquisicao_eqpto, 'MM/YYYY') = 
      TO_CHAR( current_timestamp, 'MM/YYYY' ) ;

-- c)	Mostre os equipamentos adquiridos nos últimos 90 dias
-- com mais de 12 meses de garantia no formato :
-- Tipo Eqpto é do modelo XXX adquirido em dd/mm/yyyy  com NN meses de garantia (tudo em maiúsculo).
SELECT UPPER(eq.tipo_eqpto||' é do modelo '||eq.modelo_eqpto||' adquirido em '||
        TO_CHAR(eq.dt_aquisicao_eqpto, 'DD/MON/YYYY')||' com '||
        TO_CHAR(eq.tempo_garantia, '99')||' meses de garantia')
FROM equipamento eq
WHERE eq.dt_aquisicao_eqpto >= current_date - 90
AND eq.tempo_garantia > 12 ;

-- d)	Mostre os softwares que não são do tipo Sistema Operacional no Formato :
--  Nome Software – Versão – Tipo Software
SELECT s.nome_softw AS Software, s.versao_softw, s.tipo_softw
FROM software AS s
WHERE UPPER(s.tipo_softw) NOT LIKE '%OPER%' ;

/*** Aula 24 de maio - Junção Interna - JOIN */
--12 ) Mostrar modelo, data e valor da aquisicao, 
-- processador e velocidade dos computadores
SELECT equipamento.num_patrimonio, equipamento.modelo_eqpto, 
equipamento.dt_aquisicao_eqpto, equipamento.valor_aquisicao_eqpto,
       computador.num_patr_comp, computador.tipo_processador, 
       computador.velocidade_proc_GHZ
FROM equipamento, computador
WHERE equipamento.num_patrimonio = computador.num_patr_comp ;

--13 ) Mostrar modelo, data e valor da aquisicao, 
-- processador e velocidade dos computadores, usando apelido
SELECT eq.num_patrimonio, eq.modelo_eqpto, 
eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto,
       c.num_patr_comp, c.tipo_processador, 
       c.velocidade_proc_GHZ
FROM equipamento eq, computador c
WHERE eq.num_patrimonio = c.num_patr_comp ;

--14 ) Mostrar modelo, data e valor da aquisicao, 
-- processador e velocidade dos computadores, usando apelido e 
-- a clausula INNER JOIN
SELECT eq.num_patrimonio, eq.modelo_eqpto, 
eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto,
       c.num_patr_comp, c.tipo_processador, 
       c.velocidade_proc_GHZ
FROM equipamento eq INNER JOIN computador c
ON ( eq.num_patrimonio = c.num_patr_comp ) ;

--15 ) Mostrar modelo, data e valor da aquisicao, 
-- processador e velocidade dos computadores, usando apelido e 
-- a clausula INNER JOIN
SELECT eq.num_patrimonio, eq.modelo_eqpto, 
eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto,
f.cod_fabr AS Fabricante , f.tipo_fabr AS Tipo,
f.nacionalidade,
       c.num_patr_comp, c.tipo_processador, 
       c.velocidade_proc_GHZ
FROM equipamento eq, computador c, fabricante f
WHERE eq.num_patrimonio = c.num_patr_comp 
AND eq.cod_fabr = f.cod_fabr ;

-- usando sintaxe do INNER JOIN
SELECT eq.num_patrimonio, eq.modelo_eqpto, 
eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto,
f.cod_fabr AS Fabricante , f.tipo_fabr AS Tipo,
f.nacionalidade,
       c.num_patr_comp, c.tipo_processador, 
       c.velocidade_proc_GHZ
FROM equipamento eq JOIN computador c
ON ( eq.num_patrimonio = c.num_patr_comp )
     JOIN fabricante f
ON ( eq.cod_fabr = f.cod_fabr)

--16) idem 15 adicionando dados da empresa
SELECT eq.num_patrimonio, eq.modelo_eqpto, 
eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto,
f.cod_fabr AS Fabricante , f.tipo_fabr AS Tipo,
f.nacionalidade, e.rz_social, e.end_empresa,
       c.num_patr_comp, c.tipo_processador, 
       c.velocidade_proc_GHZ
FROM equipamento eq JOIN computador c
ON ( eq.num_patrimonio = c.num_patr_comp )
     JOIN fabricante f
ON ( eq.cod_fabr = f.cod_fabr)
     JOIN empresa e
ON ( f.cod_fabr = e.cod_empresa )
WHERE UPPER(e.end_empresa) LIKE '%BERRINI%' ;

--17) idem 16 usando sintaxe do WHERE no join
SELECT eq.num_patrimonio, eq.modelo_eqpto, 
eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto,
f.cod_fabr AS Fabricante , f.tipo_fabr AS Tipo,
f.nacionalidade, e.rz_social, e.end_empresa,
       c.num_patr_comp, c.tipo_processador, 
       c.velocidade_proc_GHZ
FROM equipamento eq, computador c, fabricante f, empresa e
WHERE UPPER(e.end_empresa) LIKE '%BERRINI%'
AND eq.num_patrimonio = c.num_patr_comp -- eqpto x computador
AND eq.cod_fabr = f.cod_fabr  -- eqpto x fabricante
AND f.cod_fabr = e.cod_empresa ; -- fabricante x empresa

--18) Mostrar os perifericos instalados em um computador,
-- mostrando dados de equipamento

SELECT pi.num_patr_comp_aloc, eqc.modelo_eqpto AS Computador, 
       c.tipo_computador, eqc.valor_aquisicao_eqpto AS "Valor Pago",
	   c.tipo_processador, ec.rz_social AS Fabricante_Computador,
       pi.num_patr_perif_aloc, eqp.modelo_eqpto AS Periferico, p.tipo_perif,
       p.caracteristicas, pi.dt_ini_aloc AS "Inicio Alocação"
FROM perifericos_instalados  pi, computador c, periferico p,
equipamento eqc, equipamento eqp, fabricante fc, empresa ec
WHERE pi.num_patr_comp_aloc = c.num_patr_comp -- perifinstal x comp
AND pi.num_patr_perif_aloc = p.num_patr_perif -- perifinstal x perif
AND eqc.num_patrimonio = c.num_patr_comp -- computadot x eqpto
AND eqp.num_patrimonio = p.num_patr_perif -- perif x eqpto
AND eqc.cod_fabr = fc.cod_fabr -- comp x fabricante
AND ec.cod_empresa = fc.cod_fabr -- fabricante x empresa
AND eqc.valor_aquisicao_eqpto > 1000 ;

-- 19) Funções de grupo
SELECT COUNT(*) FROM equipamento ;
-- 20) Funções principais : COUNT, MAX, MIN, SUM, AVG
SELECT COUNT(*) AS Contagem,
MAX(valor_aquisicao_eqpto) AS Maior_valor,
MIN(valor_aquisicao_eqpto) AS Menor_valor,
AVG(valor_aquisicao_eqpto) AS Media,
SUM(valor_aquisicao_eqpto) AS Total
FROM equipamento ;

-- 21) Por tipo de equipamento
SELECT tipo_eqpto, COUNT(*) AS Contagem,
MAX(valor_aquisicao_eqpto) AS Maior_valor,
MIN(valor_aquisicao_eqpto) AS Menor_valor,
AVG(valor_aquisicao_eqpto) AS Media,
SUM(valor_aquisicao_eqpto) AS Total
FROM equipamento
GROUP BY tipo_eqpto ;

-- fim da aula 24/maio

/* Aula 31/maio */
/* Atividade 08: Escreva a instrução SQL, para o SGBD Postgresql,  para responder às seguintes consultas
a)	Mostrar os periféricos adquiridos no mês atual no formato : 
Patrimônio-Modelo-Data Aquisição-Tipo Periferico-Características
*/
SELECT eq.num_patrimonio AS Patrimonio, eq.modelo_eqpto AS Modelo, 
eq.dt_aquisicao_eqpto , p.tipo_perif, p.caracteristicas
FROM equipamento eq, periferico p
WHERE eq.num_patrimonio = p.num_patr_perif
AND EXTRACT(MONTH FROM eq.dt_aquisicao_eqpto) = EXTRACT (MONTH FROM current_date);

/* b) Mostrar os dados dos fabricantes não brasileiros : Razão Social-Endereço-Tipo Fabricante-Nacionalidade */
SELECT e.rz_social, e.end_empresa, fa.tipo_fabr, fa.nacionalidade
FROM empresa e JOIN fabricante fa
ON ( e.cod_empresa = fa.cod_fabr)
WHERE UPPER(fa.nacionalidade) NOT LIKE '%BRA_IL%' ;

/* c) Refaça a consulta a) acima mostrando também a razão social do fornecedor. 
Faça com as duas sintaxes: junção no where e junção com INNER JOIN */
SELECT eq.num_patrimonio AS Patrimonio, eq.modelo_eqpto AS Modelo, 
eq.dt_aquisicao_eqpto , p.tipo_perif, p.caracteristicas, e.rz_social AS Fornecedor
FROM equipamento eq, periferico p, empresa e
WHERE eq.num_patrimonio = p.num_patr_perif
AND e.cod_empresa = eq.cod_forn
AND EXTRACT(MONTH FROM eq.dt_aquisicao_eqpto) = EXTRACT (MONTH FROM current_date);

-- INNER JOIN
SELECT eq.num_patrimonio AS Patrimonio, eq.modelo_eqpto AS Modelo, 
eq.dt_aquisicao_eqpto , p.tipo_perif, p.caracteristicas, e.rz_social AS Fornecedor
FROM equipamento eq JOIN periferico p
     ON ( eq.num_patrimonio = p.num_patr_perif)
                    JOIN empresa e
      ON ( e.cod_empresa = eq.cod_forn) 
WHERE EXTRACT(MONTH FROM eq.dt_aquisicao_eqpto) = EXTRACT (MONTH FROM current_date);

/* d) Reescreva a consulta 18) realizada em aula , agora usando a sintaxe do INNER JOIN */
SELECT pi.num_patr_comp_aloc, eqc.modelo_eqpto AS Computador, 
       c.tipo_computador, eqc.valor_aquisicao_eqpto AS "Valor Pago",
	   c.tipo_processador, ec.rz_social AS Fabricante_Computador,
       pi.num_patr_perif_aloc, eqp.modelo_eqpto AS Periferico, p.tipo_perif,
       p.caracteristicas, pi.dt_ini_aloc AS "Inicio Alocação"
FROM equipamento eqc JOIN computador c
     ON (eqc.num_patrimonio = c.num_patr_comp) -- computadot x eqpto 
JOIN perifericos_instalados  pi 
     ON (pi.num_patr_comp_aloc = c.num_patr_comp ) -- perifinstal x comp
JOIN periferico p
     ON (pi.num_patr_perif_aloc = p.num_patr_perif) -- perifinstal x perif
JOIN equipamento eqp
     ON (eqp.num_patrimonio = p.num_patr_perif) -- perif x eqpto
JOIN fabricante fc
     ON (eqc.cod_fabr = fc.cod_fabr) -- comp x fabricante
JOIN empresa ec
     ON (ec.cod_empresa = fc.cod_fabr) -- fabricante x empresa
WHERE eqc.valor_aquisicao_eqpto > 1000 ;

/* e) Montar uma lista com os equipamentos alocados nos departamentos nos últimos três meses mas que já foram desalocados no formato :
Nome Departamento – Localização – Número Patrimônio – Tipo Eqpto – Modelo Eqpto –
Data Alocação – Data Remoção – Tempo de Permanência */
SELECT d.nome_depto AS "Nome Departamento", d.localizacao_depto, eq.num_patrimonio, eq.tipo_eqpto, 
eq.modelo_eqpto AS Modelo, ae.dt_ini_alocacao, ae.dt_term_alocacao,
EXTRACT ( DAY FROM (ae.dt_term_alocacao - ae.dt_ini_alocacao )) As Dias
--( ae.dt_term_alocacao - ae.dt_ini_alocacao) As Dias
FROM departamento d JOIN alocacao_eqpto ae
     ON (d.cod_depto = ae.cod_depto )
JOIN equipamento eq
ON (ae.num_patr_eqpto = eq.num_patrimonio )
WHERE ae.dt_ini_alocacao > current_date - INTERVAL '3' MONTH
AND ae.dt_term_alocacao IS NOT NULL ;

SELECT * FROM alocacao_eqpto ;
SELECT * FROM equipamento ;
INSERT INTO equipamento VALUES ( default, 'Inspiron 5600', 'DLL12345', '20/04/2022' ,
		'123XYZ', 5000, 24, 'COMPUTADOR', 1, 2, 'ATIVO') ;
INSERT INTO alocacao_eqpto VALUES ( 2034, 1, current_timestamp - INTERVAL '19 DAYS', 
 current_timestamp - INTERVAL '9 DAYS');
INSERT INTO computador VALUES ( 2034, 'Xeon E-2224', 3.4, 4000, 64, 'SERVIDOR') ;

/* f) Montar uma lista dos softwares instalados em cada Computador no seguinte formato :
Número Patrimônio – Modelo eqpto -Tipo Processador - Fabricante Computador- Tipo Software – 
Fabricante Software-  Número Licença – Data Instalação ordenado pela instalação mais recente. */
SELECT eq.num_patrimonio AS Computador , eq.modelo_eqpto AS "Modelo Computador", c.tipo_processador, 
ec.rz_social  AS "Fabricante Computador", sw.tipo_softw AS "Tipo Software", 
es.rz_social AS "Fabricante Software", isw.num_licenca, isw.dthora_inst
FROM equipamento eq, computador c, software sw, instalacao_softw isw, fabricante fs, fabricante fe,
empresa es, empresa ec
WHERE eq.num_patrimonio = c.num_patr_comp 
AND eq.cod_fabr = fe.cod_fabr
AND sw.cod_fabr_softw = fs.cod_fabr
AND es.cod_empresa = fs.cod_fabr
AND ec.cod_empresa = fe.cod_fabr
AND c.num_patr_comp = isw.num_patr_comp
AND sw.cod_softw = isw.cod_softw 
AND isw.dthora_desinst IS NULL
ORDER BY isw.dthora_inst DESC ;

/* FUNÇÕES DE GRUPO - 31/maio/22 ****/
--22) Mostrar para cada fabricante o valor total dos equipamentos.
SELECT e.rz_social, SUM( eq.valor_aquisicao_eqpto) AS "Total aquisicao"
FROM equipamento eq, fabricante f, empresa e
WHERE eq.cod_fabr = f.cod_fabr
AND e.cod_empresa = f.cod_fabr
GROUP BY  e.rz_social ;

--23) - fornecedor
SELECT e.rz_social, SUM( eq.valor_aquisicao_eqpto) AS "Total aquisicao",
COUNT(*) AS Eqptos
FROM equipamento eq, empresa e
WHERE eq.cod_forn = e.cod_empresa
GROUP BY  e.rz_social ;

-- 24) refazendo a anterior por tipo de equipamento também
SELECT e.rz_social, eq.tipo_eqpto, SUM( eq.valor_aquisicao_eqpto) AS "Total aquisicao",
COUNT(*) AS Eqptos
FROM equipamento eq JOIN empresa e
ON ( eq.cod_forn = e.cod_empresa)
GROUP BY  e.rz_social, eq.tipo_eqpto  ;

-- 25) refazendo a anterior por mês de aquisição também
SELECT e.rz_social, eq.tipo_eqpto, SUM( eq.valor_aquisicao_eqpto) AS "Total aquisicao",
TO_CHAR(eq.dt_aquisicao_eqpto,'MM/YY') As Mês_aquisição,
COUNT(*) AS Eqptos
FROM equipamento eq JOIN empresa e
ON ( eq.cod_forn = e.cod_empresa)
GROUP BY  e.rz_social, eq.tipo_eqpto , Mês_aquisição
ORDER BY 1, 3 ;

-- 26) Mostrar para cada tipo de computador a maior velocidade e memória
SELECT c.tipo_computador, MAX(velocidade_proc_ghz) AS "Maior Velocidade",
MAX (memoria_comp_gb) AS "Maior memoria"
FROM computador c
GROUP BY c.tipo_computador;

-- 27) Mostrar o tempo médio de alocação dos equipamentos por departamento
SELECT d.nome_depto, 
AVG( EXTRACT(DAY FROM (COALESCE(ae.dt_term_alocacao, current_timestamp) - ae.dt_ini_alocacao))) AS "Media dias"
FROM alocacao_eqpto ae, departamento d
WHERE ae.cod_depto = d.cod_depto 
GROUP BY d.nome_depto ;

--28) Mostrar os computadores que possuem mais de 3 softwares instalados
SELECT c.num_patr_comp As Computador , COUNT(isw.cod_softw) AS "Quantos softwares"
FROM computador c, software s, instalacao_softw isw
WHERE c.num_patr_comp = isw.num_patr_comp
AND s.cod_softw = isw.cod_softw 
AND isw.dthora_desinst IS NULL
GROUP BY c.num_patr_comp
HAVING COUNT(isw.cod_softw) > 1 ;

-- 29) Mostrar os fabricantes que tem mais de $ 1o mil em equipamentos que não sejam Notebooks
SELECT e.rz_social, SUM( eq.valor_aquisicao_eqpto) AS "Total aquisicao"
FROM computador c JOIN equipamento eq
     ON (eq.num_patrimonio = c.num_patr_comp )
JOIN fabricante f
     ON (eq.cod_fabr = f.cod_fabr )
JOIN empresa e
     ON ( e.cod_empresa = f.cod_fabr) 
WHERE UPPER(c.tipo_computador) NOT LIKE '%NOTEBOOK%'
GROUP BY e.rz_social 
HAVING SUM( eq.valor_aquisicao_eqpto) > 1000 ;

/**********************************************
Selects Aninhados  - SUBQUERY
***********************************************/
-- 30) Mostrar os dados do computador com maior velocidade de processador
SELECT c.*
FROM computador c
WHERE c.velocidade_proc_ghz = 
                         (SELECT MAX(c.velocidade_proc_ghz) FROM computador c);

--31) Mostrar o nome dos fabricantes que desenvolvem softwares
-- do mesmo tipo que o Windows 11
SELECT * FROM software ;
INSERT INTO software VALUES ( 'WINSV', 'Windows Server', '21H2', 'SISOPER',3) ;
UPDATE software SET versao_softw = '11.0.22'
WHERE cod_softw = 'WIN11';

SELECT DISTINCT e.rz_social
FROM empresa e, fabricante f, software sw
WHERE e.cod_empresa = f.cod_fabr
AND f.cod_fabr = sw.cod_fabr_softw
AND sw.tipo_softw =
                     (SELECT sw.tipo_softw
                      FROM software sw
                      WHERE UPPER(sw.nome_softw) LIKE '%WINDOWS%'
                      AND UPPER(sw.versao_softw) LIKE '%11%' );

/* Atividade 09:
a) Mostrar para cada fornecedor (razão social) o valor total acumulado de equipamentos fornecidos por mês de aquisição;
*/
SELECT e.rz_social, TO_CHAR(eq.dt_aquisicao_eqpto,'MM/YY') As Mês_aquisição,
SUM( eq.valor_aquisicao_eqpto) AS "Total aquisicao",
COUNT(*) AS Eqptos
FROM equipamento eq, empresa e
WHERE eq.cod_forn = e.cod_empresa
GROUP BY  e.rz_social, Mês_aquisição  ;

/*b) Mostrar para cada fabricante de software (razão social) a quantidade de softwares instalados
 por tipo de computador (notebook, server,etc.); */
SELECT * FROM computador ;
SELECT e.rz_social As Fabricante, c.tipo_computador AS Tipo, COUNT(isw.cod_softw) AS "Quantos softwares"
FROM computador c, software s, instalacao_softw isw, empresa e, fabricante fa
WHERE c.num_patr_comp = isw.num_patr_comp
AND s.cod_softw = isw.cod_softw
AND s.cod_fabr_softw = fa.cod_fabr
AND fa.cod_fabr = e.cod_empresa
AND isw.dthora_desinst IS NULL
GROUP BY Fabricante, tipo ;

/*c) Mostrar os departamentos (nome) que tem mais de 5 computadores alocados com alocações
 feitas desde o ano passado;*/
SELECT * FROM alocacao_eqpto ;
SELECT d.nome_depto, COUNT(ae.num_patr_eqpto) AS Qtde_alocados
FROM alocacao_eqpto ae, departamento d
WHERE ae.cod_depto = d.cod_depto
AND ae.dt_ini_alocacao > current_date - INTERVAL '1' YEAR
GROUP BY d.nome_depto
HAVING COUNT(ae.num_patr_eqpto) > 5 ;
 
/* d) Mostrar todos os dados do equipamento computador do tipo SERVIDOR mais caro; */
SELECT eq.*, c.*
FROM equipamento eq INNER JOIN computador c
ON ( eq.num_patrimonio = c.num_patr_comp )
WHERE c.tipo_computador = 'SERVIDOR'
AND eq.valor_aquisicao_eqpto = ( 
                                 SELECT MAX(eq.valor_aquisicao_eqpto)
                                   FROM equipamento eq INNER JOIN computador c
                                        ON ( eq.num_patrimonio = c.num_patr_comp )
                                    WHERE c.tipo_computador = 'SERVIDOR' ) ;

/* e) Mostrar todos os dados dos computadores que tem mais memória RAM. */
SELECT eq.*, c.*
FROM equipamento eq INNER JOIN computador c
ON ( eq.num_patrimonio = c.num_patr_comp )
WHERE c.tipo_computador = 'SERVIDOR'
AND eq.num_patrimonio IN ( SELECT c.num_patr_comp
                               FROM computador c
                               WHERE c.memoria_comp_GB =
							         ( SELECT MAX(c.memoria_comp_GB)
                                        FROM computador c) ) ;

/* f) Mostrar todos os dados dos fornecedores que forneceram mais de $ 5 mil
 em periféricos diferentes de impressoras nos últimos 3 meses; */
SELECT e.*
FROM empresa e
WHERE e.cod_empresa IN ( 
     SELECT e.cod_empresa
     FROM equipamento eq JOIN periferico p
	    ON ( eq.num_patrimonio = p.num_patr_perif)
	                     JOIN empresa e 
	    ON (e.cod_empresa = eq.cod_forn )
     WHERE p.tipo_perif != 'IMPRESSORA'
     AND eq.dt_aquisicao_eqpto >= current_date - INTERVAL '3' MONTH
     GROUP BY e.cod_empresa
      HAVING SUM(eq.valor_aquisicao_eqpto) > 2000 );



