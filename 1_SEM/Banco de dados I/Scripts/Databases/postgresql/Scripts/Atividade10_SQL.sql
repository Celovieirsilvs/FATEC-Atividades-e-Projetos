/*Atividade 10:
Escreva a instrução SQL, para o SGBD Postgresql,  para responder às seguintes consultas*/
/*a)Montar uma lista com todos os dados dos computadores que 
não tem periféricos instalados atualmente (fazer de 3 maneiras diferentes).*/
SELECT * FROM computador;
SELECT * FROM periferico;
SELECT * FROM perifericos_instalados;
SELECT * FROM alocacao_eqpto;
SELECT * FROM equipamento;
SELECT p.tipo_perif AS "Tipo periferico",
		pi.num_patr_perif_aloc AS "Numero Patrimonio",
		c.tipo_computador AS "Tipo de Computador",
		p.situacao_perif AS "Situação do periférico"
FROM equipamento e RIGHT OUTER JOIN periferico p
	ON (e.num_patrimonio = p.num_patr_perif)
	   JOIN computador c
	ON (e.num_patrimonio = c.num_patr_comp)
	 JOIN perifericos_instalados pi
	 ON (pi.num_patr_comp_aloc = c.num_patr_comp)
WHERE pi.dt_ini_aloc IS NULL AND e.situacao_eqpto = 'ATIVO'
ORDER BY 1;

SELECT * FROM computador;
--JOIN: 
SELECT p.tipo_perif AS "Tipo periferico",
		pi.num_patr_perif_aloc AS "Numero Patrimonio",
		c.tipo_computador AS "Tipo de Computador",
		p.situacao_perif AS "Situação do periférico"
FROM equipamento e JOIN periferico p
	ON (e.num_patrimonio = p.num_patr_perif)
	   JOIN computador c
	ON (e.num_patrimonio = c.num_patr_comp)
	 JOIN perifericos_instalados pi
	 ON (pi.num_patr_comp_aloc = c.num_patr_comp)
WHERE pi.dt_ini_aloc IS NULL AND e.situacao_eqpto = 'ATIVO'
ORDER BY 1;

--WHERE: 
SELECT p.tipo_perif AS "Tipo periferico",
		pi.num_patr_perif_aloc AS "Numero Patrimonio",
		c.tipo_computador AS "Tipo de Computador",
		p.situacao_perif AS "Situação do periférico"
FROM equipamento e, periferico p, computador c, perifericos_instalados pi
WHERE (e.num_patrimonio = p.num_patr_perif) AND
(e.num_patrimonio = c.num_patr_comp) AND
(pi.num_patr_comp_aloc = c.num_patr_comp) AND (pi.dt_ini_aloc) IS NULL AND (e.situacao_eqpto) = 'ATIVO';
ORDER BY 1;
/*b)Montar uma lista com todos os dados dos periféricos que ainda não foram alocados a um computador. Resolva com junção externa usando junção à esquerda e depois à direita.*/
--RIGHT OUTER JOIN:
SELECT p.tipo_perif AS Periferico,
	   c.tipo_computador AS "Tipo de computador",
	   pi.* ,
	   eq.modelo_eqpto AS Equipamento,
	   eq.tipo_eqpto AS Equipamento
FROM periferico p RIGHT OUTER JOIN perifericos_instalados pi
  ON (p.num_patr_perif = pi.num_patr_perif_aloc)
  	RIGHT OUTER JOIN computador c
  ON (pi.num_patr_comp_aloc = c.num_patr_comp)
   RIGHT OUTER JOIN equipamento eq
  ON (c.num_patr_comp = eq.num_patrimonio)
WHERE pi.num_patr_comp_aloc IS NULL AND eq.tipo_eqpto = 'PERIFERICO'
ORDER BY 1;
-- LEFT OUTER JOIN:
SELECT p.tipo_perif AS Periferico,
	   c.tipo_computador AS "Tipo de computador",
	   pi.* ,
	   eq.modelo_eqpto AS Equipamento,
	   eq.tipo_eqpto AS Equipamento
FROM periferico p LEFT OUTER JOIN perifericos_instalados pi
  ON (p.num_patr_perif = pi.num_patr_perif_aloc)
  	RIGHT OUTER JOIN computador c
  ON (pi.num_patr_comp_aloc = c.num_patr_comp)
   LEFT OUTER JOIN equipamento eq
  ON (c.num_patr_comp = eq.num_patrimonio)
WHERE pi.num_patr_comp_aloc IS NULL AND eq.tipo_eqpto = 'PERIFERICO'
ORDER BY 1;
/*c)Mostrar os dados dos computadores : 
Patrimonio-Modelo-Processador-Tipo Computador que nunca teve software do tipo ‘Ferramenta CASE’ instalado. 
Resolva de três formas diferentes, sendo uma delas com JUNÇÃO EXTERNA;*/
-- com join: 
SELECT isw.num_patr_comp AS Patrimonio,
	   eq.modelo_eqpto AS Modelo,
	   c.tipo_processador AS Processador,
	   c.tipo_computador AS Tipo
FROM instalacao_softw isw JOIN software sw
	ON (isw.cod_softw = sw.cod_Softw)
	 JOIN computador c
	  ON (isw.num_patr_comp = c.num_patr_comp)
	 JOIN equipamento eq
	  ON (eq.num_patrimonio = c.num_patr_comp)
WHERE sw.tipo_softw = 'Ferramenta CASE';
--Com AND:
SELECT isw.num_patr_comp AS Patrimonio,
	   eq.modelo_eqpto AS Modelo,
	   c.tipo_processador AS Processador,
	   c.tipo_computador AS Tipo
FROM instalacao_softw isw, software sw, computador c, equipamento eq
WHERE isw.cod_softw = sw.cod_Softw AND
eq.num_patrimonio = c.num_patr_comp AND
isw.num_patr_comp = c.num_patr_comp AND
isw.num_patr_comp = c.num_patr_comp AND sw.tipo_softw = 'Ferramenta CASE';;
--COM OUTER JOIN:
SELECT isw.num_patr_comp AS Patrimonio,
	   eq.modelo_eqpto AS Modelo,
	   c.tipo_processador AS Processador,
	   c.tipo_computador AS Tipo
FROM instalacao_softw isw LEFT OUTER JOIN software sw
	ON (isw.cod_softw = sw.cod_Softw)
	 LEFT OUTER JOIN computador c
	  ON (isw.num_patr_comp = c.num_patr_comp)
	     LEFT OUTER JOIN equipamento eq
	  ON (eq.num_patrimonio = c.num_patr_comp)
WHERE sw.tipo_softw = 'Ferramenta CASE';
/*d)Mostre todos os dados das empresas fabricantes de software e também os softwares que produzem 
E que não tiveram seus produtos instalados em servidores no súltimos 45 dias. Resolva de três formas diferentes, 
sendo uma delas com JUNÇÃO EXTERNA.*/
SELECT * FROM fabricante;
SELECT * FROM empresa;
SELECT * FROM software;
SELECT * FROM instalacao_softw;

SELECT isw.cod_softw,
		f.tipo_fabr,
		sw.tipo_softw,
		eq.cod_fabr,
		e.cod_empresa,
		sw.cod_fabr_softw
FROM instalacao_softw isw RIGHT OUTER JOIN software sw
ON (isw.cod_softw = sw.cod_softw)
 RIGHT OUTER JOIN fabricante f
 ON (sw.cod_fabr_softw = f.cod_fabr)
   RIGHT OUTER JOIN equipamento eq
 ON (eq.cod_fabr = f.cod_fabr)
 RIGHT OUTER JOIN empresa e
 ON (e.cod_empresa = eq.cod_fabr)
WHERE isw.dthora_inst = current_timestamp - INTERVAL '45' DAY AND f.tipo_fabr = 'SW' ;

--join:
SELECT isw.cod_softw,
		f.tipo_fabr,
		sw.tipo_softw,
		eq.cod_fabr,
		e.cod_empresa,
		sw.cod_fabr_softw
FROM instalacao_softw isw  JOIN software sw
ON (isw.cod_softw = sw.cod_softw)
  JOIN fabricante f
 ON (sw.cod_fabr_softw = f.cod_fabr)
    JOIN equipamento eq
 ON (eq.cod_fabr = f.cod_fabr)
  JOIN empresa e
 ON (e.cod_empresa = eq.cod_fabr)
WHERE isw.dthora_inst = current_timestamp - INTERVAL '45' DAY AND f.tipo_fabr = 'SW' ;

--WHERE:
SELECT isw.cod_softw,
		f.tipo_fabr,
		sw.tipo_softw,
		eq.cod_fabr,
		e.cod_empresa,
		sw.cod_fabr_softw
FROM instalacao_softw isw, software sw, fabricante f, equipamento eq, empresa e
ON ()
 RIGHT OUTER JOIN 
 ON ()
   RIGHT OUTER JOIN 
 ON ()
 RIGHT OUTER JOIN 
 ON ()
WHERE isw.cod_softw = sw.cod_softw AND 
sw.cod_fabr_softw = f.cod_fabr AND 
eq.cod_fabr = f.cod_fabr AND 
e.cod_empresa = eq.cod_fabr AND 
isw.dthora_inst = current_timestamp - INTERVAL '45' DAY AND f.tipo_fabr = 'SW' ;

--verifica a estrutura da tabela
SELECT table_name AS "nome tabela", column_name AS "Nome coluna", data_type AS "tipo dado", is_nullable "Permite nulo"
FROM information_schema.columns -- instância do catálogo
WHERE table_name = 'equipamento';
