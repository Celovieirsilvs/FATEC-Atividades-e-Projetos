--ddmmaa
--22/10/2020: OK
--29/02/2020: OK
--29/02/2021: NOK
--31/06/2020: NOK
DO
$$
DECLARE
		data INT := 29022020/*31062021*/;
		dia INT;
		mes INT;
		ano INT;
		data_valida BOOL := TRUE;
BEGIN
	dia := data / 1000000;
	RAISE NOTICE 'dia: %', dia;
	mes:= data % 1000000 /10000;
	RAISE NOTICE 'mes: %',mes;
	ano := data % 100000 % 10000;
	RAISE NOTICE 'ano: %', ano;
	IF ano >= 1 THEN
		CASE 
			WHEN mes > 12 OR mes < 1 OR dia < 1 OR dia > 31 THEN 
					data_valida := FALSE;
			ELSE
				IF ((mes = 4 OR mes=6 OR mes = 9 OR mes = 11) AND dia > 30) THEN
					data_valida := FALSE;
				ELSE
					IF mes = 2 THEN
						CASE 
							WHEN ((ano % 4 = 0 AND ano % 100 <> 0) OR ano % 400 = 0) THEN
								IF dia > 29 THEN
									data_valida := FALSE;
								END IF;
							ELSE
									IF dia > 28 THEN 
									 data_valida := FALSE;
									END IF;
						END CASE;
					END IF;
				END IF;
		END CASE;
	ELSE
		data_valida := FALSE;
	END IF;
	
	--só pra exibir mensagem
	CASE 
		WHEN data_valida THEN
			RAISE NOTICE 'A data %/%/% é válida', dia, mes, ano;
		ELSE
			RAISE NOTICE 'A data %/%/% é inválida', dia, mes, ano;
	END CASE;
END;
$$

DO
$$
DECLARE 
		valor INT := valor_aleatorio_entre(1,12);
BEGIN
		RAISE NOTICE 'O valor gerado é: %', valor;
		CASE
			WHEN valor BETWEEN 1 AND 10 THEN
				CASE 
					WHEN valor % 2 = 0 THEN
						RAISE NOTICE 'Par';
					ELSE,
						RAISE NOTICE 'Ímpar';
					END CASE;
			ELSE
				RAISE NOTICE 'valor % fora do intervalo', valor;
			END CASE;
END;
$$

DO 
$$
DECLARE
		valor int;
		mensagem VARCHAR(200);
BEGIN
		valor := valor_aleatorio_entre(1,12);
		RAISE NOTICE 'Valor gerado: %', valor;
		CASE valor
		WHEN 1,3,5,7,9 THEN
			mensagem :='Ímpar';
		WHEN 2,4,6,8,10 THEN
			mensagem :='Par';
		ELSE 
		 	RAISE NOTICE 'O % se encontra fora do intervalo', valor;
		END CASE;
		RAISE NOTICE '';
END;
$$


DO 
$$
DECLARE
		valor int;
		mensagem VARCHAR(200);
BEGIN
		valor := valor_aleatorio_entre(1,12);
		RAISE NOTICE 'Valor gerado: %', valor;
		CASE valor
		WHEN 1 THEN
			mensagem :='Ímpar';
		WHEN 3 THEN
			mensagem :='Ímpar';
		WHEN 5 THEN
			mensagem :='Ímpar';
		WHEN 7 THEN
			mensagem :='Ímpar';
		WHEN 9 THEN
			mensagem :='Ímpar';
		WHEN 2 THEN
			mensagem :='Par';			
		WHEN 4 THEN
			mensagem :='Par';	
		WHEN 6 THEN
			mensagem :='Par';			
		WHEN 8 THEN		
			mensagem :='Par';	
		WHEN 10 THEN
			mensagem :='Par';
		ELSE 
		 	RAISE NOTICE 'O % se encontra fora do intervalo', valor;
		END CASE;
		RAISE NOTICE '';
END;
$$