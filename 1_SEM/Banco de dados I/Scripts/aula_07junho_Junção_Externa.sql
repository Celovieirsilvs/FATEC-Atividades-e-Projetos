/* Aula 07/junho Junção Externa - OUTER JOIN */
-- 32 - Mostrar os equipamentos que ainda não foram alocados a departamentos
-- primeiro vamos descobrir os que foram alocados
SELECT eq.num_patrimonio AS Eqpto, eq.modelo_eqpto, ae.num_patr_eqpto AS Alocado
FROM equipamento eq INNER JOIN alocacao_eqpto ae
    ON (eq.num_patrimonio = ae.num_patr_eqpto ) ;
SELECT * FROM equipamento ;
-- usando junção externa -- quem está em eqpto mas não migrou para alocação
SELECT eq.num_patrimonio AS Eqpto, eq.modelo_eqpto, ae.num_patr_eqpto AS Alocado
FROM equipamento eq LEFT OUTER JOIN alocacao_eqpto ae
    ON (eq.num_patrimonio = ae.num_patr_eqpto ) ;
-- quem está em alocação mas não foi para eqpto
SELECT eq.num_patrimonio AS Eqpto, eq.modelo_eqpto, ae.num_patr_eqpto AS Alocado
FROM equipamento eq RIGHT OUTER JOIN alocacao_eqpto ae
    ON (eq.num_patrimonio = ae.num_patr_eqpto ) ;
-- quem está em eqpto mas não foi para alocação
SELECT eq.num_patrimonio AS Eqpto, eq.modelo_eqpto, ae.num_patr_eqpto AS Alocado
FROM alocacao_eqpto ae RIGHT OUTER JOIN equipamento eq
    ON (eq.num_patrimonio = ae.num_patr_eqpto )
WHERE ae.num_patr_eqpto IS NULL ;
-- outras formas de impementar a operação de diferença
SELECT eq.* -- todos os equipamentos
FROM equipamento eq
WHERE eq.num_patrimonio NOT IN ( 
                                   SELECT ae.num_patr_eqpto -- equipamentos alocados
                                    FROM alocacao_eqpto ae ) ;
-- usando operador de conjunto
SELECT * FROM equipamento WHERE num_patrimonio IN
(SELECT eq.num_patrimonio -- todos os equipamentos
FROM equipamento eq
EXCEPT
( SELECT ae.num_patr_eqpto -- equipamentos alocados
FROM alocacao_eqpto ae )) ;
--33) Montar uma lista dos computadores que não tiveram softwares instalados nos últimos
-- 3 meses
SELECT * FROM computador
WHERE num_patr_comp NOT IN (
SELECT c.num_patr_comp
FROM computador c JOIN instalacao_softw isw
   ON ( c.num_patr_comp = isw.num_patr_comp)
WHERE isw.dthora_inst > current_date - INTERVAL '3' MONTH );
-- outer join
SELECT c.*, temsoftw3.comptem 
FROM computador c LEFT OUTER JOIN 
     (SELECT c.num_patr_comp AS comptem
       FROM computador c JOIN instalacao_softw isw
       ON ( c.num_patr_comp = isw.num_patr_comp)
       WHERE isw.dthora_inst > current_date - INTERVAL '3' MONTH ) temsoftw3
ON ( c.num_patr_comp = temsoftw3.comptem)
WHERE temsoftw3.comptem IS NULL ;
-- operador EXCEPT
SELECT * FROM computador WHERE num_patr_comp IN
(SELECT c.num_patr_comp -- todos
FROM computador c
EXCEPT	
(SELECT c.num_patr_comp
       FROM computador c JOIN instalacao_softw isw
       ON ( c.num_patr_comp = isw.num_patr_comp)
       WHERE isw.dthora_inst > current_date - INTERVAL '3' MONTH )) ;
