-- calcular o valor de delta 
-- se delta <0, não há raiz;
-- se delta = 0, há uma raiz;
-- se delta > 0, há uma raiz;
--isso é um bloco anônimo
DO $$
DECLARE
	a INT := valor_aleatorio_entre(0,20);
	b INT := valor_aleatorio_entre(0,20);
	c INT := valor_aleatorio_entre(0,20);
	delta NUMERIC(10,2);
	raizUm NUMERIC(10,2);
	raizDois NUMERIC(10,2);
BEGIN
	RAISE NOTICE '%a% + %x +%c = 0', a, U&'\00B2', b, c;
	IF a = 0 THEN
		RAISE NOTICE 'Não é de segundo grau';
	ELSE
		delta := b ^ 2 - 4 * a * c;
		RAISE NOTICE 'delta: %', delta;
		IF THEN -- delta < 0 
		
		ELSEIF -- OU ELSIF delta = 0
		
		ELSE -- delta> 0
		
		END IF;
	END IF;
END;
$$

DO $$
DECLARE
	valor INT := valor_aleatorio_entre(1,100);
BEGIN
	RAISE NOTICE 'O valor gerado é: %', valor;
	IF valor % 2 = 0 THEN
		RAISE NOTICE '% é par', valor;
	ELSE
		RAISE NOTICE '% é impar', valor;
	END IF;
END;
$$

DO $$
DECLARE
	valor int;
BEGIN
	valor := valor_aleatorio_entre(1, 100);
	RAISE NOTICE 'Valor Gerado: %', valor;
	IF valor <= 20 THEN 
		RAISE NOTICE '%/2 = %', valor, valor / 2::FLOAT;
	END IF;
END;
$$

CREATE OR REPLACE FUNCTION valor_aleatorio_entre(lim_inferior INT, lim_superior INT) RETURNS INT AS
$$
BEGIN
	RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
END;
$$ LANGUAGE plpgsql;