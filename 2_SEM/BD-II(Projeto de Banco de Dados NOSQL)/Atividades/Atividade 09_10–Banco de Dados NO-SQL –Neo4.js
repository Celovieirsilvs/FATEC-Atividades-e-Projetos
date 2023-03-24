//Atividade 09–Banco de Dados NO-SQL –Neo4J –Utilizando a base criada em aula com Salas, Sessões, Filmes, Artistas e Elencos :
/*1)Mostre os 5 campeões de bilheteria pela quantidade total de público:
a.Por filme (título)*/
MATCH (se:Sessao)-[e:Exibe]->(f:Filme)
RETURN f.titulo, SUM(se.publico) AS Publico_total, COUNT(se.id_sessao) As Qtas_sessoes
ORDER BY f.titulo, Publico_total DESC
LIMIT 5
//b.Por gênero de filme
MATCH (se:Sessao)-[e:Exibe]->(f:Filme)
RETURN f.generos, SUM(se.publico) AS Publico_total, COUNT(se.id_sessao) As Qtas_sessoes
ORDER BY f.generos, Publico_total DESC
LIMIT 5
//c.Por Complexo de Exibição
MATCH (s:Sala)<-[u:Utiliza]-(se:Sessao)-[e:Exibe]->(f:Filme)
RETURN s.grupo, f.titulo, SUM(se.publico) AS Publico_total, COUNT(se.id_sessao) As Qtas_sessoes
ORDER BY s.grupo, Publico_total DESC
LIMIT 5
/*2)Mostre os 3 campeões de bilheteria por taxa média de ocupação (público versus capacidade da sala)
a.Por filme*/
MATCH (s:Sala)<-[u:Utiliza]-(se:Sessao)-[e:Exibe]->(f:Filme)
RETURN f.titulo, AVG((se.publico*1.0/s.capacidade)*100) AS Media_Taxa_ocupação, COUNT(se.id_sessao) As Qtas_sessoes
ORDER BY f.titulo, Media_Taxa_ocupação DESC
LIMIT 3
//b.Por horário de exibição
MATCH (s:Sala)<-[u:Utiliza]-(se:Sessao)-[e:Exibe]->(f:Filme)
RETURN se.id_sessao,se.dt_hora_sessao, AVG((se.publico*1.0/s.capacidade)*100) AS Media_Taxa_ocupação
ORDER BY se.dt_hora_sessao, Media_Taxa_ocupação DESC
LIMIT 3
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
RETURN sala, Nome_filme, sessao, MAX(taxa_ocupacao) AS Valor_Taxa, COUNT(sessao) As Qtas_sessoes, Genero
ORDER BY Valor_Taxa DESC
LIMIT 10
//5)Mostre o dia que teve mais público nas salas, independente do filme, sala
MATCH (se:Sessao)-[e:Exibe]->(f:Filme)
RETURN MAX(se.publico) AS Qnt_Publico, COUNT(se.id_sessao) AS Qtas_sessoes, se.dt_hora_sessao AS Dia
ORDER BY Dia, Qnt_Publico DESC
LIMIT 1
//6)Mostre um ranking dos complexos de exibição por total de público nos últimos 15 dias
MATCH (s:Sala)<-[u:Utiliza]-(se:Sessao)-[e:Exibe]->(f:Filme)
WHERE date(se.dt_hora_sessao).day < date().day - 15 
RETURN s.grupo, SUM(se.publico) AS Publico_total
ORDER BY s.grupo, Publico_total DESC
/*Atividade 10 –Banco NO-SQL –Neo4J-Recomendação
1)Mostre o nome dos atores que trabalharam diretamente com a atriz Fernanda Montenegro em filmes diferentes de drama e romance.*/
MATCH (a1:Artista)<-[e:Elenco]-(f:Filme)-[e2:Elenco]->(a2:Artista)
WHERE a1.nome =~ '(?i).*fernanda montenegro.*'
AND e2.tipo_participação =~ '(?i).*actor.*'
AND f.generos=~ '(?i).*drama.*' 
AND f.generos=~ '(?i).*romance.*'
RETURN a2.nome, COUNT(*) AS Total_parc, e2.tipo_participação
ORDER BY a2.nome
//2)Repita a consulta 1) acima para os que não trabalharam diretamente com ela, com maior força para fazer contato
MATCH (a1:Artista)<-[:Elenco]-(f:Filme)-[el2:Elenco]->(a2:Artista),
(a2:Artista)<-[:Elenco]-(f2:Filme)-[el3:Elenco]->(a3:Artista)
WHERE a1.nome = 'Fernanda Montenegro'
AND el2.tipo_participação =~ '(?i).*actor.*'
AND f.generos=~ '(i?).*Drama.*' 
AND f.generos=~ '(i?).*Romance.*'
AND el3.tipo_participação =~ '(?i).*actor.*'
AND a1 <> a3
AND NOT (a1)<-[:Elenco]-(:Filme)-[:Elenco]->(a3)
RETURN a3.nome AS Não_trabalharam, a2.nome AS Ator_recomendado, COUNT(*) AS Força_proximidade
ORDER by Força_proximidade DESC
//3)Mostre todos os artistas de filmes de comédia que não trabalharam com Renato Aragão (ator/atriz/diretor, etc.).
MATCH (a1:Artista)<-[el:Elenco]-(f:Filme)-[el2:Elenco]->(a2:Artista)<-[el3:Elenco]-(f2:Filme)-[el4:Elenco]->(a3:Artista)
WHERE a1.nome = 'Renato Aragão'
AND f.generos=~ '(i?).*Comedy.*' 
AND NOT (a1)<-[:Elenco]-(:Filme)-[:Elenco]->(a3)
RETURN a3.nome AS Não_trabalharam, el4.tipo_participação
ORDER BY a3.nome
//4)Mostre os atores/atrizes que mais trabalharam com a atriz Marieta Severo.
MATCH (a1:Artista)<-[el:Elenco]-(f:Filme)-[el2:Elenco]->(a2:Artista)
WHERE a1.nome = 'Marieta Severo'
AND el2.tipo_participação =~ '(?i).*act.*'
RETURN a2.nome AS Nome, COUNT(*) AS quant_parcerias, el2.tipo_participação AS Função
ORDER BY quant_parcerias DESC
//5)Mostre os diretores que dirigiram atores comuns ao diretor Glauber Rocha mas em gêneros diferentes
MATCH (a1:Artista)<-[el:Elenco]-(f:Filme)-[el2:Elenco]->(a2:Artista)<-[el3:Elenco]-(f2:Filme)-[el4:Elenco]->(a3:Artista)
WHERE a1.nome = 'Glauber Rocha'
AND f2.generos <> f.generos
AND NOT (a1)<-[:Elenco]-(:Filme)-[:Elenco]->(a3)
AND el4.tipo_participação =~ '(?i).*director.*'
AND el2.tipo_participação =~ '(?i).*act.*'
AND a1 <> a3
RETURN a3.nome AS Nome_diretor
ORDER BY a3.nome