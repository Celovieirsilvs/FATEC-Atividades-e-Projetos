--tabela temporária
-- DROP TABLE temp_dados;
-- CREATE TEMPORARY TABLE temp_dados(IDCarga INT,
-- 							 Hidrovia VARCHAR(50),
-- 							 Valor_Movimentado_Hidrovia VARCHAR(50));
-- COPY temp_dados FROM 'C:\2022\2022Carga_Hidrovia.csv' DELIMITER ';' CSV HEADER; 
-- ALTER TABLE temp_dados ADD COLUMN valor NUMERIC(10,2);
-- UPDATE temp_dados SET valor = REPLACE(Valor_Movimentado_Hidrovia, ',', '.')::NUMERIC;
-- ALTER TABLE temp_dados DROP COLUMN Valor_Movimentado_Hidrovia;
-- ALTER TABLE temp_dados RENAME COLUMN valor TO Valor_Movimentado_Hidrovia;
-- SELECT * FROM temp_dados;

--Tabela Regiao
DROP TABLE IF EXISTS tbCarga_Regiao CASCADE;
CREATE TABLE tbCarga_Regiao(IDCarga INT,
							 Regiao_Hidro VARCHAR(50),
							 Valor_mov VARCHAR(50));

COPY tbCarga_Regiao(IDCarga, Regiao_Hidro, Valor_mov) FROM 'C:\2022\2022Carga_Regiao.csv' DELIMITER ';' CSV HEADER; 

UPDATE tbCarga_Regiao SET valor_mov = REPLACE(Valor_mov, ',', '.');
ALTER TABLE tbCarga_Regiao ALTER COLUMN valor_mov TYPE NUMERIC(10,3) USING valor_mov::NUMERIC(10,3);
SELECT * FROM tbCarga_Regiao;

--Tabela Carga Hidrovia
DROP TABLE tbCarga_Hidrovia;
CREATE TABLE tbCarga_Hidrovia(IDCarga INT,
							 Hidrovia VARCHAR(50),
							 Valor_Movimentado_Hidrovia VARCHAR(50));
							 
COPY tbCarga_Hidrovia(IDCarga, Hidrovia, Valor_Movimentado_Hidrovia) FROM 'C:\2022\2022Carga_Hidrovia.csv' DELIMITER ';' CSV HEADER; 

--Tabela Carga_Hidrovia - ALTER
UPDATE tbCarga_Hidrovia SET Valor_Movimentado_Hidrovia = REPLACE(Valor_Movimentado_Hidrovia, ',', '.');
ALTER TABLE tbCarga_Hidrovia ALTER COLUMN Valor_Movimentado_Hidrovia TYPE NUMERIC(10,3) USING Valor_Movimentado_Hidrovia::NUMERIC(10,3);
SELECT * FROM tbCarga_Hidrovia;

--Tabela Carga_Rio 
DROP TABLE IF EXISTS tbCarga_Rio CASCADE;
CREATE TABLE tbCarga_Rio (
	IDCarga INT,
	Rio VARCHAR(30),
	ValorMovimentado_Rio VARCHAR(10)
);
COPY tbCarga_Rio(IDCarga, Rio, ValorMovimentado_Rio) FROM 'C:\2022\2022Carga_Rio.csv' DELIMITER ';' CSV HEADER; 

UPDATE tbCarga_Rio SET ValorMovimentado_Rio = REPLACE(ValorMovimentado_Rio, ',', '.');
ALTER TABLE tbCarga_Rio ALTER COLUMN ValorMovimentado_Rio TYPE NUMERIC(10,3) USING ValorMovimentado_Rio::NUMERIC(10,3);
SELECT * FROM tbCarga_Rio;

--Tabela Carga_Conteinerizada
DROP TABLE IF EXISTS tbCarga_Conteinerizada CASCADE;
CREATE TABLE tbCarga_Conteinerizada (
	CDMercadoria_conteinerizada INT,
	IDCarga VARCHAR(6),
	vl_peso_carga VARCHAR(25)
);
--Importação
COPY tbCarga_Conteinerizada(CDMercadoria_conteinerizada, IDCarga, vl_peso_carga) FROM 'C:\2022\2022Carga_Conteinerizada.csv' DELIMITER ';' CSV HEADER; 
--Alterando
UPDATE tbCarga_Conteinerizada SET vl_peso_carga = REPLACE(vl_peso_carga, ',', '.');
ALTER TABLE tbCarga_Conteinerizada ALTER COLUMN vl_peso_carga TYPE NUMERIC(10,3) USING vl_peso_carga::NUMERIC(10,3);
SELECT * FROM tbCarga_Conteinerizada;

--tbTaxa_ocupação
DROP TABLE IF EXISTS tbTaxa_ocupação CASCADE;
CREATE TABLE tbTaxa_ocupação(
	IDBerco VARCHAR(15),
	Dia_TaxaOcupacao INT,
	Mes_TaxaOcupacao CHAR(3),
	Ano_TaxaOcupacao INT,
	Tempo_Min_dias INT
);

COPY tbTaxa_ocupação(IDBerco, Dia_TaxaOcupacao, Mes_TaxaOcupacao, Ano_TaxaOcupacao, Tempo_Min_dias) FROM 'C:\2022\2022TaxaOcupacao.csv' DELIMITER ';' CSV HEADER; 

--tbTempos_Atracacao
DROP TABLE IF EXISTS tbTempos_Atracacao CASCADE;
CREATE TABLE tbTempos_Atracacao(
	IDAtracao VARCHAR(8),
	TEspera_Atracacao VARCHAR(15),
	TEsperaInicioOp VARCHAR(15),
	TOperacao VARCHAR(15),
	TEsperaDesatracacao VARCHAR(15),
	TAtracado VARCHAR(15),
	TEstrada VARCHAR(15)
);

COPY tbTempos_Atracacao(IDAtracao, TEspera_Atracacao, TEsperaInicioOp, TOperacao, TEsperaDesatracacao, TAtracado,TEstrada) FROM 'C:\2022\2022TaxaOcupacao.csv' DELIMITER ';' CSV HEADER; 