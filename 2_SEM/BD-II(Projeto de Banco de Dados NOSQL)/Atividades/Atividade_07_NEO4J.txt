//a)Crie um novo filme 007-Cassino Royale, incluaa duração e idioma do filme
CREATE(f4:Filme {nome: "007-Cassino Royale", ano_lançamento: "2006",
        gênero: "Ação", estúdio: "Columbia Pictures", idioma: "Inglês", duração:144})
RETURN f4

/*b)Crie 4 novos artistas, dois para o filme 007-Cassino Royale e dois para o filme Central do Brasil 
(um será diretor). 
Para um dos atores coloque a propriedade data de nascimento;*/
CREATE(a1007:Artista {nome: "Daniel Craig", pais: "Inglaterra",
        Sexo: "M", data_nascimento: "1968-03-02T00:00:00.000Z"}),
      (a2007:Artista {nome: "Judi Dench", pais: "Inglaterra",
        Sexo: "F"}),  
      (aCB01:Artista {nome: "Walter Salles", pais: "Brasil",
        Sexo: "M" }),
      (aCB02:Artista {nome: "Felicia de Castro", pais: "Brasil",
        Sexo: "F"})
RETURN a1007, a2007, aCB01, aCB02

/*c)Crie o relacionamento entre esses atores(artistas) e o respectivo filme, 
com o tipo de participação e papel se houver; */
MATCH (a1:Artista),(a2:Artista), (a3:Artista),(a4:Artista),
      (f1:Filme), (f2:Filme)
WHERE a1.nome CONTAINS 'Craig' 
  AND a2.nome CONTAINS 'Dench'
  AND a3.nome CONTAINS 'Salles'
  AND a4.nome CONTAINS 'de Castro'
  AND f1.nome CONTAINS '007'
  AND f2.nome = "Central do Brasil"
CREATE (f1)-[e4:Elenco {tipo_participação :"Ator",
papel: "James Bond"}]->(a1),
(f1)-[e5:Elenco {tipo_participação :"Atriz",
papel: "M"}]->(a2),
(f2)-[e6:Elenco {tipo_participação: "Diretor"}]->(a3),
(f2)-[e7:Elenco {tipo_participação: "Atriz"}]->(a4)
RETURN a1, a2, a3,a4, f1, f2, e4, e5, e6, e7

//d)Mostre todos os atores;
//consultando relacionamento - elenco
MATCH (f)-[e:Elenco]->(art)
WHERE e.tipo_participação = 'Atriz' OR e.tipo_participação = 'Ator'
RETURN art.nome

//e)Mostre o nome e ano de lançamento de todos os filmes.
MATCH (n:Filme)
RETURN n.nome, n.ano_lançamento