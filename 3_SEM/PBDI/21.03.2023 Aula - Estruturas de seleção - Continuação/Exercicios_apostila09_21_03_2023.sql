/*Autor: Marcelo Vieira da Silva*/
CREATE OR REPLACE FUNCTION valor_aleatorio_entre (lim_inferior INT, lim_superior
INT) RETURNS INT AS
$$
BEGIN
RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
END;
$$ LANGUAGE plpgsql;
--1.1 - Faça um programa que exibe se um número inteiro é múltiplo de 3.
--IF
DO
$$
DECLARE 
    num INT := valor_aleatorio_entre(1,1000);
BEGIN
    RAISE NOTICE 'Número: %', num;
    IF num % 3 = 0 THEN 
        RAISE NOTICE 'O % é múltiplo de 3', num;

    ELSE 
        RAISE NOTICE 'O % não é múltiplo de 3', num;
    END IF;
END;
$$

--CASE
DO
$$
DECLARE 
    num INT := valor_aleatorio_entre(1,1000);
BEGIN
    RAISE NOTICE 'Número: %', num;
    CASE 
        WHEN num % 3 = 0 THEN 
            RAISE NOTICE 'O % é múltiplo de 3', num;
        ELSE 
            RAISE NOTICE 'O % não é múltiplo de 3', num;
    END CASE;
END;
$$

-- 1.2 - Faça um programa que exibe se um número inteiro é múltiplo de 3 ou de 5
-- IF
DO
$$
DECLARE 
    num INT := valor_aleatorio_entre(1,1000);
BEGIN
    RAISE NOTICE 'Número: %', num;
    IF num % 3 = 0 THEN 
        RAISE NOTICE 'O % é múltiplo de 3', num;
    ELSIF num % 5 = 0 THEN 
        RAISE NOTICE 'O % é múltiplo de 5', num;
    ELSE 
        RAISE NOTICE 'O % não é múltiplo de 3 nem múltiplo de 5', num;
	END IF;
END;
$$

--CASE
DO
$$
DECLARE 
    num INT := valor_aleatorio_entre(1,1000);
BEGIN
    RAISE NOTICE 'Número: %', num;
    CASE 
        WHEN num % 3 = 0 THEN 
            RAISE NOTICE 'O % é múltiplo de 3', num;
        WHEN num % 5 = 0 THEN 
            RAISE NOTICE 'O % é múltiplo de 5', num;
        ELSE 
            RAISE NOTICE 'O % não é múltiplo de 3 nem múltiplo de 5', num;
    END CASE;
END;
$$

/*1.3 Faça um programa que opera de acordo com o seguinte menu.
Opções:
1 - Soma
2 - Subtração
3 - Multiplicação
4 - Divisão
Cada operação envolve dois números inteiros. O resultado deve ser exibido no formato
op1 op op2 = res
Exemplo:
2 + 3 = 5*/
--IF
DO
$$
DECLARE 
    num1 INT := valor_aleatorio_entre(0,100);
    num2 INT := valor_aleatorio_entre(0,20);
    op INT := valor_aleatorio_entre(1,4);
BEGIN
    RAISE NOTICE 'Operações\n
                  1- Soma\n
                  2- Subtração\n
                  3- Multiplicação\n
                  4- Divisão';
    IF op = 1 THEN 
        RAISE NOTICE '% + % = %', num1, num2, num1 + num2;
    ELSIF op = 2 THEN
        RAISE NOTICE '% - % = %', num1, num2, num1 - num2;
	ELSIF op = 3 THEN 
        RAISE NOTICE '% X % = %', num1, num2, num1 * num2;
	ELSE
		CASE 
			 WHEN num1 = 0 OR num2 = 0 THEN
				RAISE NOTICE 'Não é possível realizar divisão por 0';
			 ELSE
        		RAISE NOTICE '% / % = %', num1, num2, num1 / num2;
			END CASE;
	END IF;
END;
$$
--CASE
DO
$$
DECLARE 
    num1 INT := valor_aleatorio_entre(0,100);
    num2 INT := valor_aleatorio_entre(0,20);
    op INT := valor_aleatorio_entre(1,4);
BEGIN
    RAISE NOTICE 'Operações\n
                  1- Soma\n
                  2- Subtração\n
                  3- Multiplicação\n
                  4- Divisão';
    CASE
		WHEN op = 1 THEN 
        RAISE NOTICE '% + % = %', num1, num2, num1 + num2;
		WHEN op = 2 THEN
        	RAISE NOTICE '% - % = %', num1, num2, num1 - num2;
		WHEN op = 3 THEN 
        	RAISE NOTICE '% X % = %', num1, num2, num1 * num2;
		ELSE
			CASE 
				 WHEN num1 = 0 OR num2 = 0 THEN
					RAISE NOTICE 'Não é possível realizar divisão por 0';
				 ELSE
					RAISE NOTICE '% / % = %', num1, num2, num1 / num2;
				END CASE;
	END CASE;
END;
$$

/*1.4 Um comerciante comprou um produto e quer vendê-lo com um lucro de 45% se o valor
da compra for menor que R$20. Caso contrário, ele deseja lucro de 30%. Faça um
programa que, dado o valor do produto, calcula o valor de venda.
*/
-- IF
DO
$$
DECLARE 
      compra INT := valor_aleatorio_entre(1,100);
	  venda INT;
BEGIN
    RAISE NOTICE '';
    IF compra > 20 THEN 
        venda := (compra * (130/100)) + compra;
		RAISE NOTICE 'Valor da venda: %', venda;
    ELSE 
         venda := (compra * (145/100)) + compra;
		RAISE NOTICE 'Valor da venda: %', venda;
	END IF;
END;
$$

--CASE
DO
$$
DECLARE 
      compra INT := valor_aleatorio_entre(1,100);
	  venda INT;
BEGIN
    RAISE NOTICE '';
    CASE
		WHEN compra > 20 THEN 
			venda := (compra * (130/100)) + compra;
			RAISE NOTICE 'Valor da venda: %', venda;
		ELSE 
			venda := (compra * (145/100)) + compra;
			RAISE NOTICE 'Valor da venda: %', venda;
	END CASE;
END;
$$

/*1.5 - Resolva o problema disponível no link a seguir.
https://www.beecrowd.com.br/judge/en/problems/view/1048
*/
DO
$$
DECLARE 
      salario INT := valor_aleatorio_entre(0,4000.00);
	  reajuste NUMERIC(10,2);
	  novo_salario NUMERIC(10,2);
BEGIN
    RAISE NOTICE '';
    IF  salario >=0 OR salario <=400 THEN 
        reajuste := salario * 0.15;
		novo_salario := salario + reajuste;
		RAISE NOTICE 'Novo Salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 15%%';
    ELSIF salario > 400 OR salario <=800 THEN
        reajuste := salario * 0.12;
		novo_salario := salario + reajuste;
		RAISE NOTICE 'Novo salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 12%%';
    ELSIF salario >= 800.01 OR salario <= 1200.00 THEN
	        reajuste := salario * 0.10;
		novo_salario := salario + reajuste;		
		RAISE NOTICE 'Novo salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 10%%';	
	ELSIF salario > 1200 OR salario <=2000 THEN 
        reajuste := salario * 0.07;
		novo_salario := salario + reajuste;
		RAISE NOTICE 'Novo salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 7%%';
	ELSE
		reajuste := salario * 0.04;		
		novo_salario := salario + reajuste;
		RAISE NOTICE 'Novo salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 4%%';
	END IF;
END;
$$

--CASE
DO
$$
DECLARE 
      salario INT:= valor_aleatorio_entre(0,4000);
	  reajuste NUMERIC(10,2);
	  novo_salario NUMERIC(10,2);
BEGIN
    RAISE NOTICE '';
    CASE
	WHEN  salario >=0 OR salario <=400 THEN 
		reajuste := salario * 0.15;
		novo_salario := salario + reajuste;
		RAISE NOTICE 'Novo Salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 15%%';
    WHEN salario > 400 OR salario <=800 THEN
        reajuste := salario * 0.12;
		novo_salario := salario + reajuste;
		RAISE NOTICE 'Novo salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 12%%';
    WHEN salario > 800 OR salario <=1200 THEN
        reajuste := salario * 0.10;
		novo_salario := salario + reajuste;		
		RAISE NOTICE 'Novo salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 10%%';
    WHEN salario > 1200 OR salario <=2000 THEN
        reajuste := salario * 0.07;
		novo_salario := salario + reajuste;
		RAISE NOTICE 'Novo salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 7%%';
	ELSE
		reajuste := salario * 0.04;		
		novo_salario := salario + reajuste;
		RAISE NOTICE 'Novo salário: %', novo_salario;
		RAISE NOTICE 'Reajuste ganho: %', reajuste;
		RAISE NOTICE 'Em percentual: 4%%';
	END CASE;
END;
$$