/* 7 - a)*/
SELECT rz_social AS "Razão Social",
	   tipo_empresa AS "Tipo empresa",
	   cnpj AS "CNPJ",
	   end_empresa AS "Endereço"
FROM empresa
WHERE UPPER(rz_social) not like '%LTDA' and tipo_empresa = 'FABRICANTE'
ORDER BY 2, 1, 3, 4 ASC;

/* b) */
select equip.* 
from equipamento equip
WHERE equip.dt_aquisicao_eqpto BETWEEN current_date - INTERVAL '1' MONTH
AND current_date - INTERVAL '0' MONTH ;

/* c) */
SELECT UPPER('O tipo de eqpto é do modelo '||modelo_eqpto||'adquirido em '||
TO_CHAR(dt_aquisicao_eqpto, 'DD/MM/YYYY')||' com '||
EXTRACT (MONTH FROM dt_validade_garantia)||'meses de garantia') AS "Equip. com 90 dias com mais de 12 meses de garantia"
FROM equipamento
WHERE dt_aquisicao_eqpto = current_date - INTERVAL '3' MONTH and EXTRACT (MONTH FROM dt_validade_garantia) = 12
ORDER BY 1 ;

/* d) */
select 	nome_softw AS "Nome Software",
		versao_softw AS "Versao",
		tipo_softw AS "Tipo de software"
from software
where tipo_softw <> 'SISOPER';

select * from equipamento;