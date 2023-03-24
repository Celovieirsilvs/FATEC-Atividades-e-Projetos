SELECT * FROM cliente;
SELECT * FROM compra; 
SELECT * FROM estoque;
SELECT * FROM fornecedor;
SELECT * FROM funcionario;
SELECT * FROM pet;
SELECT * FROM produto;
SELECT * FROM servico;
SELECT * FROM venda;

--QUERY 01 mostra as informações do produto, a quantidade no estoque e o fornecedor do produto
SELECT p.nome_prod AS "Nome do produto",
	   p.tipo_prod AS "Tipo",
	   f.rz_social AS "Fornecedor",
	   e.qntd_estq AS "Quant. Estoque"
FROM produto p JOIN estoque e
ON (p.id_prod = e.id_prod_estq)
	JOIN fornecedor f
ON (p.id_forn = f.id_forn);

--QUERY 02 mostra as informações de compra do produto(valor, produto)
SELECT p.nome_prod AS "Nome do produto",
	   p.tipo_prod AS "Tipo",
	   c.preco_compra AS "Valor da compra",
	   c.nota_fiscal_compra AS "Nota Fiscal"
FROM produto p JOIN compra c
ON (p.id_prod = c.id_prod);

/*QUERY 03 mostra as informações de venda(quantidade vendida, forma de pagamento),
tipo de serviço vendido e o produto vendido(caso exista)*/
SELECT 	c.nome_cliente "Cliente",
		p.nome_prod AS "Nome do Produto",
		ven.preco_venda AS "Preço da venda",
		srv.tipo_serv AS "Tipo de serviço",
	    ven.form_pag AS "Forma da pagamento",
		ven.dt_hora_venda AS "Data/hora da venda"
FROM produto p JOIN venda ven
ON (p.id_prod = ven.id_prod)
         JOIN cliente c
ON (ven.id_cliente = c.id_cliente)
    JOIN servico srv
ON (ven.id_serv = srv.id_serv);

--QUERY 05: Mostra os clientes que compraram mais de um serviço e o funcionário responsável pela venda
SELECT 	c.nome_cliente "Cliente",
		p.nome_prod AS "Nome do Produto",
		ven.preco_venda AS "Preço da venda",
		srv.id_serv AS "Cod. Serviço",
		srv.tipo_serv AS "Tipo de serviço",
		ven.id_venda_serv AS "Serviços Vendidos",
		f.nome_func AS "Funcionário resp. venda",
	    ven.form_pag AS "Forma da pagamento",
		ven.dt_hora_venda AS "Data/hora da venda"
FROM produto p JOIN venda ven
ON (p.id_prod = ven.id_prod)
         JOIN cliente c
ON (ven.id_cliente = c.id_cliente)
	JOIN funcionario f
ON (ven.id_func = f.id_func)
    JOIN servico srv
ON (ven.id_serv = srv.id_serv)
WHERE ven.id_venda_serv LIKE '%/%';

--QUERY 06: Mostra os clientes que compraram só um serviço e o funcionário responsável pela venda
SELECT 	c.nome_cliente "Cliente",
		p.nome_prod AS "Nome do Produto",
		ven.preco_venda AS "Preço da venda",
		srv.id_serv AS "Cod. Serviço",
		srv.tipo_serv AS "Tipo de serviço",
		ven.id_venda_serv AS "Serviços Vendidos",
		f.nome_func AS "Funcionário resp. venda",
	    ven.form_pag AS "Forma da pagamento",
		ven.dt_hora_venda AS "Data/hora da venda"
FROM produto p JOIN venda ven
ON (p.id_prod = ven.id_prod)
         JOIN cliente c
ON (ven.id_cliente = c.id_cliente)
	JOIN funcionario f
ON (ven.id_func = f.id_func)
    JOIN servico srv
ON (ven.id_serv = srv.id_serv)
WHERE ven.id_serv IN('1212','1313','1414') AND ven.id_venda_serv IN('1212','1313','1414');

/*QUERY 07: mostra as informações de venda(quantidade vendida, forma de pagamento)e o produto vendido(caso exista)*/
SELECT 	p.nome_prod AS "Nome do Produto",
		ven.preco_venda AS "Preço da venda",
	    ven.form_pag AS "Forma da pagamento",
		ven.dt_hora_venda AS "Data/hora da venda"
FROM produto p JOIN venda ven
ON (p.id_prod = ven.id_prod);

-- QUERY 08 : mostra os funcionários responsáveis por cada venda
SELECT fun.nome_func AS "Nome Funcionário",
	   fun.espec_func AS "Especialização",
       ven.dt_hora_venda AS "Data/Hora da venda",
	   ven.preco_venda AS "Preço da venda"
FROM funcionario fun JOIN venda ven
ON (fun.id_func = ven.id_func);

--QUERY 09: mostra os produtos do tipo brinquedo vendido e a quantidade no estoque
SELECT p.nome_prod AS "Nome do produto",
	   ven.dt_hora_venda AS "Data/hora da venda",
	   ven.form_pag AS "Forma de pagamento",
	   est.qntd_estq AS "Quantidade no estoque"
FROM produto p JOIN venda ven
ON(p.id_prod = ven.id_prod)
		JOIN estoque est
ON (est.id_prod_estq = ven.id_prod)
WHERE p.tipo_prod = 'Brinquedo';

--QUERY 10: clientes que compraram mais de um produto no petshop
SELECT c.nome_cliente AS "Nome do cliente",
	   p.tipo_prod AS "Tipo prod",
	   p.marca_prod AS "Marca",
	   ven.dt_hora_venda AS "Data/hora da compra",
	   ven.id_venda_prod AS "Cod. produtos comprados",
	   ven.id_prod AS "Cod. produto"
FROM produto p JOIN venda ven
ON (p.id_prod = ven.id_prod)
	 RIGHT JOIN cliente c
ON (c.id_cliente = ven.id_cliente)
WHERE ven.id_venda_prod LIKE '%/%';

-- QUERY 11: clientes que compraram só um produto no petshop
SELECT c.nome_cliente AS "Nome do cliente",
	   p.tipo_prod AS "Tipo prod",
	   p.marca_prod AS "Marca",
	   ven.dt_hora_venda AS "Data/hora da compra",
	   ven.id_venda_prod AS "Cod. produtos comprados",
	   ven.id_prod AS "Cod. produto"
FROM produto p JOIN venda ven
ON (p.id_prod = ven.id_prod)
	 RIGHT JOIN cliente c
ON (c.id_cliente = ven.id_cliente)
WHERE ven.id_venda_prod NOT LIKE '%/%' ;
