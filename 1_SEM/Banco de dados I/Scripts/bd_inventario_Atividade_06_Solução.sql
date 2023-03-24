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

