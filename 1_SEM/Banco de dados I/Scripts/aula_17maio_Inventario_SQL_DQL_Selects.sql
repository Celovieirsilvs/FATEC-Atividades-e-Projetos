/* Aula 17/maio SQL DQL Selects */
--1 ) discriminando as colunas
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

















	  
	  


















