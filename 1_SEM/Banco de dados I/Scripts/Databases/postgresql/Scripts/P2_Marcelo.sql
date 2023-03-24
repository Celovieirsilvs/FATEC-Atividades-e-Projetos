--1.(2,0) Implementecom a linguagem SQL este modelono SGBD Postgresqlcom as seguintes características : 
--a.Posição: Defesa, Meio-Campo, Ataque 
--b.Atributos que expressam valores NUNCA negativos
SET DATASTYLE TO POSTGRES, DMY;

DROP TABLE IF EXISTS selecao CASCADE;
CREATE TABLE selecao (idSelecao SMALLSERIAL PRIMARY KEY NOT NULL,
Pais VARCHAR(18),
Colocacao_ultimo_Mundial VARCHAR(15),
Continente CHAR(7), --América, Europa, Ásia, África e Oceania,
Qtde_Participacoes INTEGER
);

ALTER TABLE selecao ADD CHECK (Continente IN('América', 'Europa', 'Ásia', 'África', 'Oceania'));

DROP TABLE IF EXISTS jogador CASCADE;
CREATE TABLE jogador (idJogador SMALLSERIAL PRIMARY KEY,
Nome_Popular VARCHAR(15),
Nome VARCHAR(35),
Data_Nascimento DATE,
Pais_Nascimento VARCHAR(18),
Posicao CHAR(10) CHECK(Posicao IN('Defesa','Meio-Campo', 'Ataque')),
id_selecao SMALLINT NOT NULL REFERENCES selecao(idSelecao)
      ON DELETE CASCADE ON UPDATE CASCADE,
id_time SMALLINT NOT NULL REFERENCES Clube(id_time)
      ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Clube CASCADE;
CREATE TABLE Clube (id_time SMALLINT PRIMARY KEY,
Nome VARCHAR(30),
Pais VARCHAR(18),
Ano_Fundacao INTEGER
);
--ALTER TABLE E SEQUENCE
ALTER TABLE selecao ALTER COLUMN Colocacao_ultimo_mundial TYPE VARCHAR(30)
ALTER SEQUENCE jogador_idjogador_seq RESTART WITH 1;
-- 2.(1,0) Insira 2 linhas em cada tabela.
INSERT INTO selecao(idSelecao, Pais, Continente, Qtde_Participacoes, Colocacao_ultimo_mundial)
                  VALUES(default, 'França', 'Europa', 15, 'Campeão'),
                        (default, 'Brasil', 'América', 21, '6º Colocado - Quartas de final');

INSERT INTO Jogador VALUES(default, 'Mbappé', 'Kylian Mbappé Lottin', '20/12/1998', 'França', 'Ataque', 1, 1),
                          (default, 'Raphael Veiga','Raphael Calvacante Veiga', '19/06/1995', 'Brasil', 'Meio-Campo', 2, 2);

INSERT INTO Clube VALUES(1, 'Paris Saint Germain', 'França', 1970),
                        (2, 'Sociedade Esportiva Palmeiras', 'Brasil', 1914);

/*3.Responda às seguintes consultas :*/
SELECT * FROM selecao;
SELECT * FROM jogador;
SELECT * FROM Clube;
--a.(1,0) Nome da seleção (país), IDADE e Nome do time em que atuam os jogadores da seleções, ordenados pela IDADE na DESCENDENTE, ou seja, do mais velho para o mais novo, desde que o país do time seja diferente do país da seleção.
SELECT s.pais AS "Nome da Seleção",
        j.Nome_Popular AS "Jogador",
		EXTRACT(YEAR FROM AGE(current_timestamp, j.Data_Nascimento)) AS "Idade",
		T.Nome AS "Clube"
FROM selecao s JOIN jogador j
ON (s.idSelecao = j.id_selecao)
	JOIN Clube T
ON (j.id_time = T.id_time)
WHERE t.pais != s.pais 
ORDER BY 3 DESC;
--b.(1,0) Mostre para cada seleção de um país a quantidade de jogadores por posição, desde que tenha mais de 3 jogadores para a mesma posição. Mostre a posição também
INSERT INTO Jogador VALUES(default, 'CR7', 'Crsitiano Ronaldo dos Santos Aveiro', '05/02/1985', 'Portugal', 'Ataque', 3, 3),
                          (default, 'Lionel Messi','Lionel', '24/06/1987', 'Argentina', 'Ataque', 4, 1),
						  (default, 'Neymar','Neymar Santos Junior', '21/02/1992', 'Brasil', 'Ataque', 4, 1);
INSERT INTO selecao(idSelecao, Pais, Continente, Qtde_Participacoes, Colocacao_ultimo_mundial)
                  VALUES(default, 'Portugal', 'Europa', 10, '11º Colocado - Oitavas'),
                        (default, 'Argentina', 'América', 19, '10º Colocado - Oitavas');
INSERT INTO Clube VALUES(3, 'Man.United', 'Inglaterra', 1900);
INSERT INTO Clube VALUES(4, 'Tottenham Hotspur', 'Inglaterra', 1882);
INSERT INTO selecao(idSelecao, Pais, Continente, Qtde_Participacoes, Colocacao_ultimo_mundial)
                  VALUES(default, 'Coréia do Sul', 'Ásia', 3, '3º Colocado - Fase de grupos');
INSERT INTO Jogador VALUES (default, 'Son','Heung-min Son', '08/07/1992', 'Coréia do Sul', 'Ataque', 4, 1);
SELECT COUNT (Pais_nascimento) AS "Pais do Jogador"
FROM jogador
WHERE posicao = 'Ataque'
GROUP BY pais_nascimento;
--c.(1,0) Mostre o nome do time que nunca teve jogador convocado para a seleção brasileira (admita que na tabela time são cadastrados todos os times de um país). Resolva usando junção externa, outra solução não será considerada.
SELECT  s.pais AS "Nome da Seleção",
        j.Nome_Popular AS "Jogador",
		T.Nome AS "Clube",
		j.posicao AS "Posicao"
FROM selecao s JOIN jogador j
ON (s.idSelecao = j.id_selecao)
	JOIN Clube T
ON (j.id_time = T.id_time)
WHERE t.pais != 'Brasil' AND s.pais != 'Brasil';

UPDATE jogador 
       SET id_time = 4
	   WHERE Nome_popular = 'Son'
	   
		