-- exercício 1.1
DO
$$
DECLARE 
	var1 INTEGER;
	limite_inf INTEGER := 1;
	limite_sup INTEGER := 100;	
BEGIN
	var1:= floor(limite_inf + random() * (limite_sup - limite_inf + 1));
	RAISE NOTICE '%', var1;
END;
$$

-- exercício 1.3
DO
$$
DECLARE 
	var2 NUMERIC(5,2);
	limite_inf NUMERIC(5,2) := 1;
	limite_sup NUMERIC(5,2) := 10;	
BEGIN
	var2 := floor(limite_inf + random() * (limite_sup - limite_inf + 1));
	RAISE NOTICE '%', var2;
END;
$$

-- exercício 
-- exercício 1.1
DO
$$
DECLARE 
	celsius NUMERIC(5,2);
	limite_inf INTEGER := 20;
	limite_sup INTEGER := 30;
    x1 NUMERIC(5,2) := 1.8;
	x2 INTEGER := 32;
	F INTEGER;
BEGIN
	celsius := floor(limite_inf + random() * (limite_sup - limite_inf + 1));
	F := ((celsius * x1) + x2);
	RAISE NOTICE 'Graus em celsius: % ºC', celsius; 
	RAISE NOTICE 'Conversão para ºF: %', F; 
	--RAISE NOTICE '% * % + % = %', F, celsius, x1, x2,  celsius * x1 + x2;
END;
$$

DO
$$
DECLARE 
	var2 NUMERIC(5,2);
	limite_inf NUMERIC(5,2) := 1;
	limite_sup NUMERIC(5,2) := 10;	
BEGIN
	var2 := floor(limite_inf + random() * (limite_sup - limite_inf + 1));
	RAISE NOTICE '%', var2;
END;
$$

-- exercício 
-- exercício 1.4
DO
$$
DECLARE 
	b NUMERIC(5,2);
	limite_inf INTEGER := 1;
	limite_sup INTEGER := 10;
    vara NUMERIC(5,2);
	varc NUMERIC(5,2);
	Delta INTEGER;
BEGIN
	b := floor(limite_inf + random() * (limite_sup - limite_inf + 1));
	vara := floor(limite_inf + random() * (limite_sup - limite_inf + 1));
	varc := floor(limite_inf + random() * (limite_sup - limite_inf + 1));
	delta := (b^2) - 4*vara*varc;
	RAISE NOTICE 'resultado de delta = %', delta;
END
$$

-- exercicio 1.5
DO
$$
DECLARE 
	var NUMERIC(5,2);
	limite_inf INTEGER := 1;
	limite_sup INTEGER := 10;
    ant NUMERIC(5,2);
	suc NUMERIC(5,2);
BEGIN
	var := floor(limite_inf + random() * (limite_sup - limite_inf + 1));
	ant := var-1;
	suc := var+1;
	RAISE NOTICE 'num.aleatório: %', var;
	RAISE NOTICE 'sucessor: %', suc;
	RAISE NOTICE 'antecessor: %', ant;
	RAISE NOTICE 'raiz sucessor: ||/% = %', suc, ||/suc;
	RAISE NOTICE 'raiz antecessor: ||/%  = %', ant, ||/ant;
END;
$$

--exercício 1.6
DO
$$
DECLARE
		b NUMERIC(5,2);
		h NUMERIC(5,2);
		preco_total NUMERIC(10,2);
		preco_metro INTEGER;
		lim_sup INTEGER := 1 ;
		lim_inf INTEGER := 10;
		lim_sup2 INTEGER := 60 ;
		lim_inf2 INTEGER := 70;
BEGIN
	   b := floor(lim_inf + random() * (lim_sup - lim_inf + 1));
	   h := floor(lim_inf + random() * (lim_sup - lim_inf + 1));
	   preco_metro := floor(lim_inf2 + random() * (lim_sup2 - lim_inf2 + 1));
		preco_total := (b*h) * preco_metro;
       RAISE NOTICE 'Preço total do terreno: %', preco_total;
END
$$

--exercício 1.7
DO
$$
DECLARE
		ano_nasc INTEGER;
		ano_atual INTEGER;
		idade INTEGER;
		lim_sup INTEGER := 2000 ;
		lim_inf INTEGER := 1980;
		lim_sup2 INTEGER := 2010 ;
		lim_inf2 INTEGER := 2020;
BEGIN
	   ano_nasc := floor(lim_inf + random() * (lim_sup - lim_inf + 1));
	   ano_atual := floor(lim_inf2 + random() * (lim_sup2 - lim_inf2 + 1));
		idade := ano_atual - ano_nasc;
       RAISE NOTICE 'Idade do indivíduo: %, ano do nascimento: %, ano atual: %', idade, ano_nasc, ano_atual;
END
$$