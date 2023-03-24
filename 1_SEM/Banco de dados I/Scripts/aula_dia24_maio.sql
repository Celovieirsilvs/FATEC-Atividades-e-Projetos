/*Aula do dia 24 de maio de 2022*/
-- INNER JOIN - Junção Interna:
SELECT  num_patrimonio, modelo_equipto, dt_aquisicao_eqpto, valor_aquisicao_eqpto, 
        num_patr_comp, tipo_processador, velocidade_proc_GHZ
FROM equipamento, computador 
WHERE equipamento.num_patrimonio = computador.num_patr_comp ;

SELECT  equipamento.num_patrimonio, equipamneto.modelo_equipto, equipamento.dt_aquisicao_eqpto, equipamento.valor_aquisicao_eqpto, 
        computador.num_patr_comp, computador.tipo_processador, computador.velocidade_proc_GHZ
FROM equipamento, computador 
WHERE equipamento.num_patrimonio = computador.num_patr_comp ;

SELECT  eq.num_patrimonio, equipamneto.modelo_equipto, eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto, 
        c.num_patr_comp, c.tipo_processador, c.velocidade_proc_GHZ
FROM equipamento eq, computador c
WHERE eq.num_patrimonio /*PK*/ = c.num_patr_comp /*FK*/;

-- INNER JOIN COM COMANDO JOIN:
SELECT  eq.num_patrimonio, equipamneto.modelo_equipto, eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto, 
        c.num_patr_comp, c.tipo_processador, c.velocidade_proc_GHZ
FROM equipamento eq INNER JOIN computador c
ON ( eq.num_patrimonio  = c.num_patr_comp ) ; -- PK => eq.num_patrimonio; FK - c.num_patr_comp.

SELECT  eq.num_patrimonio, equipamneto.modelo_equipto, eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto, 
                f.cod_fabr AS fabricante, f.tipo_fabr AS tipo_fabr
                f.nacionalidade,
                c.num_patr_comp, c.tipo_processador, c.velocidade_proc_GHZ
FROM equipamento eq , computador c, fabricante f
ON ( eq.num_patrimonio  = c.num_patr_comp ) 
AND  eq.cod_fabr  =  f.cod_fabr ; -- 1º)PK => eq.num_patrimonio; FK - c.num_patr_comp. 
-- 2º) PK => eq.cod_fabr; FK - f.cod_fabr.

-- COM COMANDO JOIN:
SELECT  eq.num_patrimonio, equipamneto.modelo_equipto, eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto, 
                f.cod_fabr AS fabricante, f.tipo_fabr AS tipo_fabr
                f.nacionalidade,
                c.num_patr_comp, c.tipo_processador, c.velocidade_proc_GHZ
FROM equipamento eq  INNER JOIN computador c  -- OU FROM equipamento eq  JOIN computador c 
ON ( eq.num_patrimonio  = c.num_patr_comp ) 
                INNER JOIN fabricante f  -- JOIN fabricante f 
ON  ( eq.cod_fabr  =  f.cod_fabr) ;


SELECT  eq.num_patrimonio, equipamneto.modelo_equipto, eq.dt_aquisicao_eqpto, eq.valor_aquisicao_eqpto, 
                f.cod_fabr AS fabricante, f.tipo_fabr AS tipo_fabr
                f.nacionalidade, e.razao_social. e.end_empresa,
                c.num_patr_comp, c.tipo_processador, c.velocidade_proc_GHZ
FROM equipamento eq  JOIN computador c   
ON ( eq.num_patrimonio  = c.num_patr_comp ) 
                 JOIN fabricante f   
ON  ( eq.cod_fabr  =  f.cod_fabr) 
        JOIN empresa e
ON ( f.cod_fabr = e.cod_empresa )
WHERE UPPER(e.end_empresa) LIKE '%BERRINI%';

-- SEM COMANDO JOIN:
                f.cod_fabr AS fabricante, f.tipo_fabr AS tipo_fabr
                f.nacionalidade, e.razao_social. e.end_empresa,
                c.num_patr_comp, c.tipo_processador, c.velocidade_proc_GHZ
FROM equipamento eq, computador c, fabricante f, empresa e
ON ( f.cod_fabr = e.cod_empresa )
WHERE UPPER(e.end_empresa) LIKE '%BERRINI%' 
AND eq.num_patrimonio = c.num_patr_comp --eqpto x computador
AND eq.cod_fabr = f.cod_fabr -- eqpto x fabricante
AND f.cod_fabr = e.cod_empresa; -- fabricante X empresa
SELECT * FROM equipamento ;  --7
SELECT * FROM computador; --3
SELECT * FROM fabricante; --3 

-- 18
SELECT pi.num_patr_comp_aloc, c.tipo_computador, c.tipo_processador, pi.num_patr.perif_aloc, 
       p.tipo_perif, p.caracteristicas,
       pi.dt_ini_aloc 
FROM perifericos_instalados pi, computador c, periferico p;
WHERE pi.num_patr_comp_aloc = c.num_patr_comp
AND pi.num_patr_perif_aloc = p.num_patr_perif

--mostrando dados de equipamento
SELECT pi.num_patr_comp_aloc, eqc.modelo_eqpto AS Computador, c.tipo_computador, c.tipo_processador, ec.razao_social AS Fabricante_computador, pi.num_patr.perif_aloc, 
       p.tipo_perif, p.caracteristicas,
       pi.dt_ini_aloc AS "Inicio Alocação"
FROM perifericos_instalados pi, computador c, periferico p, equipamento.eqc, equipamento.eqp, fabricante fc, empresa ec;
WHERE pi.num_patr_comp_aloc = c.num_patr_comp
AND pi.num_patr_perif_aloc = p.num_patr_perif
AND eqc.num_patrimonio = c.num_patr_comp
AND eqp.num_patrimonio = p.num_patr_perif
AND eqc.cod_fabr = fc.cod_fabr
AND ec.cod_empresa = fc.cod_fabr
AND eqc.valor_aquisicao_eqpto > 1000 ;

-- 19) Funções de grupo
SELECT COUNT(*) FROM equipamento;
-- 20) funções principais: COUNT, MAX, MIN, SUM, AVG
SELECT COUNT(*) AS Contagem,
MAX(valor_aquisicao_eqpto) AS Maior_valor,
MIN(valor_aquisicao_eqpto) AS Menor_valor,
AVG(valor_aquisicao_eqpto) AS Media,
SUM(valor_aquisicao_eqpto) AS Total
FROM equipamento ;

SELECT tipo_eqpto, COUNT(*) AS Contagem,
MAX(valor_aquisicao_eqpto) AS Maior_valor,
MIN(valor_aquisicao_eqpto) AS Menor_valor,
AVG(valor_aquisicao_eqpto) AS Media,
SUM(valor_aquisicao_eqpto) AS Total
FROM equipamento 
GROUP BY tipo_eqpto;