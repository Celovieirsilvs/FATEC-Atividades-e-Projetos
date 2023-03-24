//Atividade 09–Banco de Dados NO-SQL –Neo4J –Utilizando a base criada em aula com Salas, Sessões, Filmes, Artistas e Elencos :
/*1)Mostre os 5 campeões de bilheteria pela quantidade total de público:
a.Por filme (título)*/
MATCH (se:Sessao)-[e:Exibe]->(f:Filme)
RETURN f.titulo, SUM(se.publico) AS Publico_total, COUNT(se.id_sessao) As Qtas_sessoes
ORDER BY Publico_total DESC
LIMIT 5

//b.Por gênero de filme
//c.Por Complexo de Exibição
/*2)Mostre os 3 campeões de bilheteria por taxa média de ocupação (público versus capacidade da sala)
a.Por filme*/
//b.Por horário de exibição
//3)Mostre a sessão com menor taxa de ocupação juntamente com data e hora e sala
MATCH (s:Sala)<-[u:Utiliza]-(se:Sessao)-[e:Exibe]->(f:Filme)
WITH s.nome AS sala, se.id_sessao As sessao, (se.publico*1.0/s.capacidade)*100 AS taxa_ocupacao, 
se.dt_hora_sessao AS Data_Hora_Sessão
RETURN sessao, MIN(taxa_ocupacao) AS Valor_Taxa, COUNT(sessao) As Qtas_sessoes, Data_Hora_Sessão 
ORDER BY Valor_Taxa DESC
LIMIT 1
//4)Mostre as 10 sessões com melhor taxa de ocupação, juntamente com a sala, título do filme e gênero
MATCH (s:Sala)<-[u:Utiliza]-(se:Sessao)-[e:Exibe]->(f:Filme)
WITH s.nome AS sala, se.id_sessao As sessao, (se.publico*1.0/s.capacidade)*100 AS taxa_ocupacao, 
f.generos AS Genero, f.titulo AS Nome_filme
RETURN sessao, MAX(taxa_ocupacao) AS Valor_Taxa, COUNT(sessao) As Qtas_sessoes, Genero, Nome_filme
ORDER BY Valor_Taxa DESC
LIMIT 10
//5)Mostre o dia que teve mais público nas salas, independente do filme, sala
MATCH (se:Sessao)-[e:Exibe]->(f:Filme)
WITH se.dt_hora_sessao AS Dia 
RETURN f.titulo, SUM(se.publico) AS Publico_total, COUNT(se.id_sessao) As Qtas_sessoes
ORDER BY Dia, Publico_total DESC
LIMIT 1
//6)Mostre um ranking dos complexos de exibição por total de público nos últimos 15 dias

/*Atividade 10 –Banco NO-SQL –Neo4J-Recomendação
1)Mostre o nome dos atores que trabalharam diretamente com a atriz Fernanda Montenegro em filmes diferentes de drama e romance.*/
//2)Repita a consulta 1) acima para os que não trabalharam diretamente com ela, com maior força para fazer contato
//3)Mostre todos os artistas de filmes de comédia que não trabalharam com Renato Aragão (ator/atriz/diretor, etc.).
//4)Mostre os atores/atrizes que mais trabalharam com a atriz Marieta Severo.
//5)Mostre os diretores que dirigiram atores comuns ao diretor Glauber Rocha mas em gêneros diferentes