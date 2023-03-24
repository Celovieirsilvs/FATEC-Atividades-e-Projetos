/* Esquema de relações - Inventario de equipamentos e software - POSTGRESQL
Empresa (cod_empresa(PK), rz_social, end_empresa, fone_empresa , cnpj, email, contato,tipo_empresa [fab/forn], situacao_empresa) 
Fabricante (cod_fabr (PK)(FK), tipo_fabr [HW/SW], nacionalidade) 
Fornecedor (cod_forn (PK)(FK)) 
Departamento (cod_depto(PK), nome_depto, ramal_depto, localizacao_depto, centro_custo) 
Equipamento (num_patrimonio(PK), modelo_eqpto, num_serie_epto, dt_aquisicao_eqpto,  
   nota_fiscal_eqpto, valor_aquisicao_eqpto, tempo_garantia, tipo_eqpto, cod_fabr(FK)NN, cod_forn(FK)NN) 
Computador (num_patr_comp(PK)(FK), tipo_processador, velocidade_processador, capacidade_armazenamento,  
            memoria_comp, tipo_computador) 
Periferico (num_patr_perif(PK)(FK), tipo_perif, caracteristicas_perif) 
Software (cod_softw(PK), nome_softw, versao_softw, tipo_softw, cod_fabr(FK)NN) 
Instalacao_softw ( cod_softw(PK)(FK), num_patrimonio_comp(PK)(FK), dt_hora_instalacao(PK), dt_hora_desinstalacao, num_licenca) 
Instalacao_perif (num_patrimonio_comp(PK)(FK), num_patrimonio_perif(PK)(FK), dt_hora_inst_perif(PK), dt_hora_retirada_perif) 
Alocacao_eqpto ( num_patrimonio(PK)(FK), cod_depto(PK)(FK), dt_ini_alocacao(PK), dt_termino_alocacao) 
*/ 
-- configurando o formato da data
SET DATESTYLE TO POSTGRES, DMY;
-- Tabela Departamento - CREATE: definindo o nome da tabela, os campos e os tipos de dados dos campos
DROP TABLE IF EXISTS departamento CASCADE;  -- Exclusão da tabela em cascata para se certificar que não tenha a tabela existente na hora de cria-lá(apaga a tabela relacionada também)
CREATE TABLE departamento (
cod_depto SMALLINT PRIMARY KEY, 
nome_depto CHAR(20) NOT NULL, 
ramal_depto SMALLINT, 
localizacao_depto VARCHAR(30) NOT NULL, 
centro_custo CHAR(10)
);
DESC departamento -- comando pra descrever tabela
SHOW TABLE departamento; -- comando pra mostrar tabela(o mesmo que desc) 
-- Constraints - Chave primária da tabela
-- populando departamento
--1):
INSERT INTO departamento VALUES (1, 'Recursos Humanos', null, 'Sala 20', '10.5.2');
SELECT * FROM departamento; 
-- Exemplo pra demonstrar erro de restrição de chave primária - integridade de entidade(duplição de valor de chave e violação de unicidade) : 
INSERT INTO departamento VALUES (1, 'Administração', null, 'Sala 21', '11.1.1');
-- Exemplo de demonstração de erro de violação de integridade de domínio(valor nulo em campo definido com valor não nulo obrigatório):
INSERT INTO departamento VALUES (2, 'Administração', null, null, '11.1.1');
-- Nesse exemplo, ele permite a inserção dos dados:
INSERT INTO departamento VALUES (2, 'Administração', null, '', '11.1.1');
--atualização a localização do depto 2
UPDATE departamento
		SET localizacao_depto = 'Sala 21'
		WHERE cod_depto = 2;
-- tabela empresa:
DROP TABLE IF EXISTS empresa CASCADE;
CREATE TABLE empresa (
cod_empresa SMALLSERIAL, 
rz_social VARCHAR(50) NOT NULL, 
end_empresa VARCHAR(100) NOT NULL, 
-- para o usuário não cadastrar errado:
-- Numeric(precisão, escala) -> NUMERIC(6,2) = 9999.99/ NUMERIC(8,4) = 9999.9999
fone_empresa NUMERIC(11), 
cnpj NUMERIC(14) NOT NULL, 
email VARCHAR(32) NOT NULL, 
contato VARCHAR(10),
tipo_empresa CHAR(10) NOT NULL CHECK ( tipo_empresa IN ('FABRICANTE', 'FORNECEDOR')),  -- restrição de verificação(CHECK): Ou vai ter FABRICANTE ou  vai ter FORNECEDOR preenchido no campo
situacao_empresa CHAR(8) NOT NULL CHECK ( situacao_empresa IN('ATIVA', 'INATIVA', 'SUSPENSA')),
PRIMARY KEY(cod_empresa),
UNIQUE(cnpj)
);
-- alterar a estrutura da tabela:
ALTER TABLE empresa ADD PRIMARY KEY (cod_empresa) ;
