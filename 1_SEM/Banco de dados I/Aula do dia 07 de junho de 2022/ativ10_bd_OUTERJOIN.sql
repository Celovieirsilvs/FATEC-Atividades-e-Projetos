--a):
--b):
SELECT * FROM perifericos_instalados;
SELECT * FROM periferico;
SELECT * FROM computador;
-- left outer join:
SELECT pi.num_patr_perif_aloc, p.num_patr_perif AS "Numero Patrimonio Pèrif.",
c.num_patr_comp "Patrimonio Comp."
FROM perifericos_instalados pi LEFT OUTER JOIN periferico p
ON (pi.num_patr_perif_aloc = p.num_patr_perif)
  JOIN computador c
ON (pi.num_patr_comp_aloc = c.num_patr_comp)
WHERE p.num_patr_perif IS NULL
--right outer join:
SELECT pi.num_patr_perif_aloc, p.num_patr_perif AS "Numero Patrimonio Pèrif.",
c.num_patr_comp "Patrimonio Comp."
FROM perifericos_instalados pi RIGHT OUTER JOIN periferico p
ON (pi.num_patr_perif_aloc = p.num_patr_perif)
  JOIN computador c
ON (pi.num_patr_comp_aloc = c.num_patr_comp)
WHERE p.num_patr_perif IS NULL
--c):
--d):
SELECT * FROM empresa;
SELECT * FROM software;
SELECT * FROM instalacao_softw;

SELECT e.rz_social AS "Razao Social", e.tipo_empresa AS "Tipo de Empresa", 
s.nome_softw, s.cod_fabr_softw, s.tipo_softw AS "Tipo de Software", s.cod_softw, 
isw.cod_softw
FROM empresa e JOIN software s
ON(e.cod_empresa = s.cod_fabr_softw) JOIN
instalacao_softw isw
ON(s.cod_softw = isw.cod_softw)
WHERE UPPER(e.tipo_empresa) LIKE 'FABR%';
