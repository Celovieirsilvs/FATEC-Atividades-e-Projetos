--Atividade 09:
--a)Mostrar para cada fornecedor (razão social) o valor total acumulado de equipamentos fornecidos por mês de aquisição;
SELECT emp.rz_social, eq.cod_forn, emp.cod_empresa
FROM 
GROUP BY 
HAVING 
--b)Mostrar para cada fabricante de software (razão social) a quantidade de softwares instalados por tipo de computador (notebook, server,etc.);
--c)Mostrar os departamentos (nome) que tem mais de 5 computadores alocados com alocações feitas desde o ano passado;
--d)Mostrar todos os dados do equipamento computador do tipo SERVIDOR mais caro;
--e)Mostrar todos os dados dos computadores que tem mais memória RAM.
--f)Mostrar todos os dados dos fornecedores que forneceram mais de $ 5 mil em periféricos diferentes de impressoras nos últimos 3 meses;