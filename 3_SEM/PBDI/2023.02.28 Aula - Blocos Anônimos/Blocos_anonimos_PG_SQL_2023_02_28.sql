-- DO
-- '
-- BEGIN
-- 	RAISE NOTICE ''Meu primeiro bloco anônimo''; /*Pra enviar mensagem no prompt*/
-- END;
-- '

-- Outra forma de sintaxe de bloco anônimo
-- DO
-- $$
-- BEGIN
-- 	RAISE NOTICE 'Meu primeiro bloco anônimo'; /*Pra enviar mensagem no prompt*/
-- END;
-- $$

--placeholders
-- DO
-- $$
-- BEGIN 
--    -- 2 + 2 = 4
--    RAISE NOTICE '% + % = %',  2, 2, 2 + 2;
-- END;
-- $$

-- variaveis
DO
$$
DECLARE
	codigo INTEGER := 1;
	nome_completo VARCHAR(200) := 'Simone Vieira Dos Santos';
	salario NUMERIC(11, 2) := 1500.00;
BEGIN
	RAISE NOTICE 'Meu código é %, meu nome é % e eu ganho %', codigo, nome_completo, salario;
END;
$$

-- -- variaveis com select
-- DO
-- $$
-- DECLARE
-- 	codigo INTEGER := 1;
-- 	nome_completo VARCHAR(200) := 'Simone Vieira Dos Santos';
-- 	salario NUMERIC(11, 2) := 1500.00;
-- BEGIN
-- 	SELECT 10 INTO codigo;
-- 	RAISE NOTICE 'Meu código é %, meu nome é % e eu ganho %', codigo, nome_completo, salario;
-- END;
-- $$

--valores aleatórios
-- função random: 0 <= n <1
-- DO
-- $$
-- DECLARE 
-- 	n1 NUMERIC (5, 2);
-- 	n2 INTEGER;
-- 	limite_inferior INTEGER := 5;
-- 	limite_superior INTEGER := 17;
-- BEGIN
-- 	n1 := random(); -- 0 <= n1 < 1
-- 	RAISE NOTICE '%', n1;
-- 	n1 := random() * 10;
-- 	RAISE NOTICE '%', n1;
-- 	-- 1 < n2 < 10
-- 	n2 := floor(random() * 10 + 1)::int; -- para declarar como inteiro no intervalo até 10 truncado
-- 	RAISE NOTICE '%', n2;
-- 	n2 := FLOOR(limite_inferior + random() *(limite_superior - limite_inferior + 1));
-- 	RAISE NOTICE '%', n2;
-- END;
-- $$

--Operadores aritméticos
-- DO
-- $$
-- DECLARE
-- 	n1 INTEGER := 5;
-- 	n2 INTEGER := 2;
-- 	n3 NUMERIC(5,2) := 5;
-- 	n4 INTEGER := -5;
-- BEGIN
-- 	-- adicao
-- 	RAISE NOTICE '% + % = %', n1, n2, n1 + n2;
-- 	-- + unário:
-- 	RAISE NOTICE '%', +n1;
-- 	-- subtração
-- 	RAISE NOTICE '% - % = %', n1 , n2, n1 - n2;
-- 	-- negação (unário)
-- 	RAISE NOTICE '%', -n1;
-- 	-- multiplicação
-- 	RAISE NOTICE '% * % = %', n1, n2, n1 * n2;
-- 	-- divisão inteira(pois envolve inteiros)
-- 	RAISE NOTICE '% / % = %', n1, n2, n1 / n2;
-- 	-- divisão real
-- 	RAISE NOTICE '% / % = %', n3, n2, n3 / n2;
-- 	-- divisão real com formatação
-- 	RAISE NOTICE '% /% = %', n3, n2, to_char(n3 / n2, '99.99');
-- 	-- resto da divisão 
-- 	RAISE NOTICE '% %% % = %', n1, n2, n1 % n2;
-- 	-- exponenciação
-- 	RAISE NOTICE '% ^ % = %', n1, n2, n1 ^ n2;
-- 	-- raiz quadrada
-- 	RAISE NOTICE '|/ % = %', n1, |/n1;
-- 	-- raiz quadrada
-- 	RAISE NOTICE '||/ % = %', n1, ||/n1;
-- 	-- valor absoluto 
-- 	RAISE NOTICE '@% = % e @% = %', n1, @n1, n4, @n4;
-- END;
-- $$

