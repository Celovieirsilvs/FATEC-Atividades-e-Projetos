/*Atividade 08:Escreva a instrução SQL, para o SGBD Postgresql,  
para responder às seguintes consultas*/
/*a)Mostrar os periféricos adquiridos no mês atual no formato: Patrimônio-Modelo-Data Aquisição-Tipo Periferico-Características*/
SELECT eq.num_patrimonio AS "Patrimônio Equipamento",
	   p.num_patr_perif AS "Patrimonio Perif.",
	   eq.dt_aquisicao_eqpto AS Aquisição,
	   eq.modelo_eqpto AS Modelo,
	   p.tipo_perif AS "Tipo Periférico",
	   p.caracteristicas
FROM equipamento eq, periferico p
WHERE eq.num_patrimonio = p.num_patr_perif AND eq.dt_aquisicao_eqpto BETWEEN current_date - INTERVAL '30' DAY AND current_date
/*b)Mostrar os dados dos fabricantes não brasileiros: Razão Social-Endereço-Tipo Fabricante-Nacionalidade*/
SELECT 	emp.rz_social, 
		emp.end_empresa, 
		fc.tipo_fabr,
		fc.nacionalidade
FROM empresa emp INNER JOIN fabricante fc
ON tipo_empresa = tipo_fabr
WHERE UPPER(fc.nacionalidade) NOT LIKE 'BRA%'

/*c)Refaça a consulta a) acima mostrando também a razão social do fornecedor. Faça com as duas sintaxes: junção no where e junção com INNER JOIN*/ 
--USANDO A CLAÚSULA WHERE
SELECT eq.num_patrimonio AS "Patrimônio Equipamento",
	   p.num_patr_perif AS "Patrimonio Perif.",
	   eq.dt_aquisicao_eqpto AS Aquisição,
	   eq.modelo_eqpto AS Modelo,
	   p.tipo_perif AS "Tipo Periférico",
	   p.caracteristicas,
	   emp.rz_social,
	   emp.tipo_empresa
	   fc.cod_fabr,
	   fc.tipo_fabr
FROM equipamento eq, periferico p, empresa emp, fabricante fc
WHERE eq.num_patrimonio = p.num_patr_perif
AND eq.cod_fabr = fc.cod_fabr
AND emp.tipo_empresa = fc.tipo_fabr 
AND eq.dt_aquisicao_eqpto BETWEEN current_date - INTERVAL '30' DAY AND current_date

---Comando INNER JOIN
SELECT eq.num_patrimonio AS "Patrimônio Equipamento",
	   p.num_patr_perif AS "Patrimonio Perif.",
	   eq.dt_aquisicao_eqpto AS Aquisição,
	   eq.modelo_eqpto AS Modelo,
	   p.tipo_perif AS "Tipo Periférico",
	   p.caracteristicas,
	   emp.rz_social,
	   emp.tipo_empresa
	   fc.cod_fabr,
	   fc.tipo_fabr
FROM periferico p INNER JOIN equipamento eq
ON eq.num_patrimonio = p.num_patr_perif
	INNER JOIN fabricante fc
ON eq.cod_fabr = fc.cod_fabr
	INNER JOIN empresa emp
ON emp.tipo_empresa = fc.tipo_fabr 
WHERE eq.dt_aquisicao_eqpto BETWEEN current_date - INTERVAL '30' DAY AND current_date - INTERVAL '30' DAY AND current_date

/*d)Reescreva a consulta 18) realizada em aula , agora usando a sintaxe do INNER JOIN*/
SELECT pi.num_patr_comp_aloc, eqc.modelo_eqpto AS Computador, 
       c.tipo_computador, eqc.valor_aquisicao_eqpto AS "Valor Pago",
	   c.tipo_processador, ec.rz_social AS Fabricante_Computador,
       pi.num_patr_perif_aloc, eqp.modelo_eqpto AS Periferico, p.tipo_perif,
       p.caracteristicas, pi.dt_ini_aloc AS "Inicio Alocação"
FROM equipamento eqp INNER JOIN periferico p 
ON  eqp.num_patrimonio = p.num_patr_perif -- perif x eqpto
INNER JOIN perifericos_instalados pi
ON p.num_patr_perif = pi.num_patr_perif_aloc-- perifinstal x perif
          INNER JOIN computador c  
ON pi.num_patr_comp_aloc = c.num_patr_comp -- perifinstal x comp
		  INNER JOIN equipamento eqc 
ON c.num_patr_comp = eqc.num_patrimonio -- computadot x eqpto
          INNER JOIN fabricante fc
ON eqc.cod_fabr = fc.cod_fabr -- comp x fabricante
		  INNER JOIN empresa ec
ON ec.cod_empresa = fc.cod_fabr -- fabricante x empresa
WHERE eqc.valor_aquisicao_eqpto > 1000 ;
