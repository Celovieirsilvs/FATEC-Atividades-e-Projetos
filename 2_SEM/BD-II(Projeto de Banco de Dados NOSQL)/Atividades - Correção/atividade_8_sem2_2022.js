/* Atividade 8 
1) Mostre o título do filme e nome dos artistas do elenco para filmes de Terror,
 e que só está clasificado como terror, sem combinação com outro gênero. */
MATCH (f)-[e:Elenco]->(a)
WHERE f.generos =~ '(?i).*horror.*'
AND size(f.generos) = 6
RETURN f.titulo, f.generos, a.nome
ORDER BY f.titulo

//unwind [{id:'0001',name:'Test',size:'10mm'}] as map
//return size(keys(map))

MATCH (f)-[e:Elenco]->(a)
WHERE f.generos =~ '(?i).*terror.*' //não tem terror é horror
AND e.tipo_participação ='actor'
RETURN f.id_filme, f.titulo, e.tipo_participação, a.id_ator, a.nome
ORDER BY a.nome

/* 2) Mostre os diretores brasileiros (nome) de filmes de comédia dos últimos 20 anos. */
MATCH (f)-[e:Elenco]->(a)
WHERE e.tipo_participação =~ '(?i).*direct.*'
AND a.local_nascto =~ '(?i).*brazil.*'
AND f.generos =~ '(?i).*comed.*'
AND f.ano_lançamento > date().year - 20
RETURN a.nome, f.ano_lançamento
ORDER BY a.nome

/* 3) Mostre o título, gênero, ano de lançamento e duração dos filmes japoneses com mais de 120 minutos de duração.
 Ordene pela maior duração.*/
MATCH (f:Filme)
WHERE f.país =~ '(?i).*japan.*'
AND f.duração > 120
RETURN f.titulo, f.generos, f.ano_lançamento, f.duração
ORDER BY f.duraçao DESC
 
/* 4) Mostre o nome e idade do ator ou atriz que fizeram parte do elenco de filmes brasileiros de drama,
 que morreram com mais de 75 anos. Ordene pela idade. */
MATCH (f)-[e:Elenco]->(a)
WHERE a.dt_nascto IS NOT NULL
AND a.local_nascto =~ '(?i).*brazil.*'
AND a.dt_nascto =~ '.*-.*'
AND a.dt_obito IS NOT NULL
AND a.dt_obito =~ '.*-.*'
AND f.país =~ '(?i).*brazil.*'
AND e.tipo_participação =~ '(?i).*act.*'
AND duration.between(date(a.dt_nascto),date()).years > 75
AND f.generos =~ '(?i).*drama.*'
RETURN a.nome, a.dt_nascto,
duration.between(date(a.dt_nascto),date(a.dt_obito)).years as Idade
ORDER BY Idade DESC

/* 5) Mostre o nome dos diretores cuja nacionalidade é diferente do pais que produziu o filme. */
MATCH (f)-[e:Elenco]->(a)
WHERE e.tipo_participação =~ '(?i).*direct.*'
AND NOT a.local_nascto CONTAINS f.país
RETURN a.nome, a.local_nascto, f.país  // usar unwind para tirar país


