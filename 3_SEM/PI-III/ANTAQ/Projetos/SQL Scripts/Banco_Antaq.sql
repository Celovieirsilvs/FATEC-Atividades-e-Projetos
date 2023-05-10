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

SELECT * FROM tbCarga_Regiao;
ALTER TABLE tbCarga_Regiao ADD COLUMN valor NUMERIC(10,3);
UPDATE tbCarga_Regiao SET valor_mov = REPLACE(Valor_mov, ',', '.')::NUMERIC;
ALTER TABLE tbCarga_Regiao ALTER COLUMN valor_mov TYPE NUMERIC(10,2) USING valor_mov::Numeric(10,2);
ALTER TABLE tbCarga_Regiao DROP COLUMN Valor_mov;
ALTER TABLE tbCarga_Regiao RENAME COLUMN valor TO ValorMovimentado_Regiao;
SELECT * FROM tbCarga_Regiao;

--Tabela Carga Hidrovia
DROP TABLE tbCarga_Hidrovia;
CREATE TABLE tbCarga_Hidrovia(IDCarga INT,
							 Hidrovia VARCHAR(50),
							 Valor_Movimentado_Hidrovia VARCHAR(50));
							 
COPY tbCarga_Hidrovia(IDCarga, Hidrovia, Valor_Movimentado_Hidrovia) FROM 'C:\2022\2022Carga_Hidrovia.csv' DELIMITER ';' CSV HEADER; 

--Tabela Carga_Hidrovia - ALTER
SELECT * FROM tbCarga_Hidrovia;
UPDATE tbCarga_Hidrovia SET Valor_Movimentado_Hidrovia = REPLACE(Valor_Movimentado_Hidrovia, ',', '.');
ALTER TABLE tbCarga_Hidrovia DROP COLUMN Valor_Movimentado_Hidrovia;
ALTER TABLE tbCarga_Hidrovia ALTER COLUMN Valor_Movimentado_Hidrovia TYPE NUMERIC(10,3) USING Valor_Movimentado_Hidrovia::NUMERIC(10,3);
SELECT * FROM tbCarga_Hidrovia;

--Tabela Carga_Rio 
DROP TABLE IF EXISTS tbCarga_Rio CASCADE;
CREATE TABLE tbCarga_Rio (
	IDCarga INT,
	Rio VARCHAR(30),
	ValorMovimentado_Rio VARCHAR(10)
);
ALTER TABLE tbCarga_Rio ADD COLUMN valor NUMERIC(10,3);
UPDATE tbCarga_Rio SET valor = REPLACE(ValorMovimentado_Rio, ',', '.')::NUMERIC;
ALTER TABLE tbCarga_Rio DROP COLUMN ValorMovimentado_Rio;
ALTER TABLE tbCarga_Rio RENAME COLUMN valor TO ValorMovimentado_Rio;
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
ALTER TABLE tbCarga_Conteinerizada ADD COLUMN valor NUMERIC(10,3);
UPDATE tbCarga_Conteinerizada SET valor = REPLACE(vl_peso_carga, ',', '.')::NUMERIC;
ALTER TABLE tbCarga_Conteinerizada DROP COLUMN vl_peso_carga;
ALTER TABLE tbCarga_Conteinerizada RENAME COLUMN valor TO vl_peso_carga;
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
SELECT DISTINCT IDBerco, mes_taxaocupacao, SUM(tempo_min_dias) FROM tbTaxa_Ocupação
GROUP BY IDBerco,mes_taxaocupacao
ORDER BY mes_taxaocupacao DESC, SUM ASC;
DELETE FROM tbTaxa_ocupação
WHERE tempo_min_dias = 0;
--tbTempos_Atracacao
DROP TABLE IF EXISTS tbTempos_Atracacao CASCADE;
CREATE TABLE tbTempos_Atracacao(
	IDAtracao INT,
	TEspera_Atracacao VARCHAR(15),
	TEsperaInicioOp VARCHAR(15),
	TOperacao VARCHAR(15),
	TEsperaDesatracacao VARCHAR(15),
	TAtracado VARCHAR(15),
	TEstrada VARCHAR(15),
);

COPY tbTempos_Atracacao(IDAtracao, TEspera_Atracacao, TEsperaInicioOp, TOperacao, TEsperaDesatracacao, TAtracado,TEstrada) FROM 'C:\2022\2022TaxaOcupacao.csv' DELIMITER ';' CSV HEADER; 