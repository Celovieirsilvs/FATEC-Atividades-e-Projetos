--1.1 Resolva cada exercício a seguir usando LOOP, WHILE, FOR e FOREACH. Quando o enunciado disser que é preciso “ler” algum valor, gere-o aleatoriamente.
--Numeros pares de 1 a 100
--LOOP
DO
$$
DECLARE 
   num INT := 0;
BEGIN
	LOOP
		num := num + 2;
		RAISE NOTICE 'num: %', num;
		IF num = 100 THEN
			EXIT;
		END IF;
	END LOOP;
END;
$$
--WHILE
DO
$$
DECLARE 
   num INT := 0;
BEGIN
	WHILE num % 2 = 0 LOOP
		num := num + 2;
		RAISE NOTICE 'num: %', num;
		IF num = 100 THEN
			EXIT;
		END IF;
	END LOOP;
END;
$$
--FOR
DO
$$
DECLARE 
   num INT := 0;
BEGIN
	FOR num IN 0..100 BY 2 LOOP
		RAISE NOTICE 'num: %', num;
		IF num = 100 THEN
			EXIT;
		END IF;
	END LOOP;
END;
$$
--FOREACH
-- DO
-- $$
-- DECLARE 
--    num INT := 0;
-- BEGIN
-- 	FOREACH num IN 0..100 LOOP
-- 		num := num + 2
-- 		RAISE NOTICE 'num: %', num;
-- 		IF num = 100 THEN
-- 			EXIT;
-- 		END IF;
-- 	END LOOP;
-- END;
-- $$

--Números Positivos
DO
$$
DECLARE 
     num INT := valor_aleatorio_entre(-50,50);
	 num2 INT := valor_aleatorio_entre(-50,50);
	 num3 INT := valor_aleatorio_entre(-50,50);
	 num4 INT := valor_aleatorio_entre(-50,50);
	 num5 INT := valor_aleatorio_entre(-50,50);
	 num6 INT := valor_aleatorio_entre(-50,50);
	 contador INT := 1;
	 quant_pos INT := 0;
BEGIN
	LOOP 
		EXIT WHEN contador > 7;
		contador := contador + 1;		
	END LOOP;
			IF num > 0 THEN
			quant_pos := quant_pos + 1;
		END IF;
		
		IF num2 > 0 THEN 
			quant_pos := quant_pos + 1;
		END IF;
		
		IF num3 > 0 THEN 
			quant_pos := quant_pos + 1;
		END IF;
		
		IF num4 > 0 THEN 
			quant_pos := quant_pos + 1;
		END IF;
		
		IF num5 > 0 THEN 
			quant_pos := quant_pos + 1;
		END IF;
		
		IF num6 > 0 THEN
			quant_pos := quant_pos + 1;
		END IF;
	RAISE NOTICE 'Há % valores positivos', quant_pos;
	RAISE NOTICE '%', num;
	RAISE NOTICE '%', num2;
	RAISE NOTICE '%', num3;
	RAISE NOTICE '%', num4;
	RAISE NOTICE '%', num5;
	RAISE NOTICE '%', num6;	
END;
$$

--IMPARES CONSECTUVOS
DO
$$
DECLARE 
	 num INT := valor_aleatorio_entre(20,50);
	 num_2 INT := valor_aleatorio_entre(20,50);
	 contador INT := 0;
	 termo INT := 0;
	 soma INT := 0;
BEGIN
	LOOP
		contador := contador + 1;		
		EXIT WHEN contador > num  OR contador > num_2;
	END LOOP;
	IF contador % 2 != 0 THEN
		termo := termo + 1;
		contador := contador + 1;				
	END IF;

	IF num > num_2 THEN 
	  contador := num_2 + 1;
	  soma := termo^2;
	ELSE 
		contador := num + 1;
		soma := termo^2;
	END IF;
	RAISE NOTICE '%', num;
	RAISE NOTICE '%', num_2;
	RAISE NOTICE 'Nº de termos impares: %', termo;
	RAISE NOTICE 'Soma dos impares: %', soma;
	RAISE NOTICE 'contador: %', contador;
END;
$$