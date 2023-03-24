//Atividade 7 – Banco de Dados NO-SQL – Neo4J – CRUD Básico
//Utilizando o BD criado no Neo4Jpara Cinema durante a aula, e a linguagem CYPHER:
//a)	Crie um novo filme 007-Cassino Royale, inclua a duração e idioma do filme
CREATE (f4:Filme {nome: "007-Cassino Royale", ano_lançamento: 2006, país: "EUA",
                  duração : 98, idioma : "Inglês"})
RETURN f4
//b)	Crie 4 novos artistas, dois para o filme 007-Cassino Royale e dois para o filme Central do Brasil (um será diretor).
// Para um dos atores coloque a propriedade data de nascimento;
CREATE(a5:Artista {nome: "Daniel Craig", país: "Reino Unido", sexo:"M"}),
(a6:Artista {nome: "Mads Mikkelsen", país: "Dinamarca", sexo: "M", data_nascimento : '1965-11-22T00:00:00.000Z'})
RETURN a5, a6
CREATE(a7:Artista {nome: "Marilia Pera", país: "Brasil", sexo:"F"}),
(a8:Artista {nome: "Walter Salles", país: "Brasil", sexo:"M"})
RETURN *

//c)	Crie o relacionamento entre esses atores(artistas) e o respectivo filme,
// com o tipo de participação e papel se houver;
MATCH (a1:Artista {nome: "Daniel Craig"}), (a2:Artista {nome: "Mads Mikkelsen"}) , 
     (f3:Filme {nome: "007-Cassino Royale"})
CREATE (f3)-[e1:Elenco {tipo_participação: "Ator"}]->(a2),
       (f3)-[e2:Elenco {tipo_participação: "Ator", papel: "James Bond"}]->(a1)
     RETURN a1, a2, f3

MATCH (a2:Artista {nome: "Marilia Pera"}) , 
      (a3:Artista {nome: "Walter Salles"}), (f3:Filme {nome: "Central do Brasil"})
CREATE (f3)-[e2:Elenco {tipo_participação: "Ator", papel: "Irene"}]->(a2),
	   (f3)-[e3:Elenco {tipo_participação: "Diretor"}]->(a3)
RETURN a2, a3, f3

//d)	Mostre todos os atores;
MATCH (a:Artista)
RETURN a

//e)	Mostre o nome e ano de lançamento de todos os filmes.
MATCH (f:Filme)
RETURN f.nome, f.ano_lançamento

MATCH(n)
RETURN n
