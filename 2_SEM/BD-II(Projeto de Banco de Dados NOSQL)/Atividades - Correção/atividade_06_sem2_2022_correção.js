/******************************
 * Atividade 06 - 27/out/2022 ***************/
use imdb_aula
db.movie.find()
//a) Mostre a contagem de filmes por Diretor. Mostre o nome(s) do(s) diretor(es) quando tiverem no máximo 2.
db.movie.find( {directors: {$eq: null}}).count() -- 436
db.movie.aggregate ([
  { $match: {directors: {$ne: null}}}, 
  { $group : { _id: {direcao: "$directors"},  
              contagem_direcao : {$count : {} } } },
{$project : {Direção: {$cond : {"if" : {"$eq": [{$size: "$_id.direcao" }, 1] }, // concatena se tiver mais de um elemento no vetor
                               "then":  { "$arrayElemAt"  : ["$_id.direcao", 0]  },
            "else": {"$concat": [ { "$arrayElemAt" : ["$_id.direcao", 0]  }, "/", 
                                  { "$arrayElemAt" : ["$_id.direcao", 1]  } ] } }}, 
              contagem_direcao: 1, _id: 0} },
            {$sort : { contagem_direcao: -1  } } ])
            
//b) Mostre a contagem de filmes por país e idioma.
// o país e idioma estão dentro do vetor
 db.movie.aggregate ([
  { $group : { _id: {país: "$countries",idioma: "$languages"}
              contagem_pais_idioma : {$count : {} } } },
             {$sort : { contagem_pais_idioma: -1  } },
{$project :{Pais: "$_id.país", Idioma: "$_id.idioma", contagem_pais_idioma: 1, _id: 0} } ]) 

//c)Mostre a quantidade de filmes por gênero em que atuou o ator Robert de Niro.
db.movie.find({actors: /robert de niro/i})
db.movie.aggregate ([
  {$match: {actors: /robert de niro/i}},  // busca dentro do vetor
  { $group : { _id: {genero: "$genre"},  
              contagem_genero : {$count : {} } } },
             {$sort : { contagem_genero: -1  } } ])  // exibe o conteúdo do vetor mas não extrai o conteudo

// tirando o texto do vetor, combinando até 3 com case
db.movie.aggregate ([
  {$match: {actors: /robert de niro/i}},  
  { $group : { _id: {genero: "$genre"},  
              contagem_genero : {$count : {} } } },
{$project : {Gênero: 
              {$switch:   
{ branches: [ { case: {"$eq": [{$size: "$_id.genero" }, 1] }, // testa o tamanho do vetor
                then:  { "$arrayElemAt"  : ["$_id.genero", 0]  } }, // extrai o conteúdo do elemento 0
              { case: {"$eq": [{$size: "$_id.genero" }, 2] },
                then: {"$concat": [ { "$arrayElemAt" : ["$_id.genero", 0]  }, "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 1]  } ] } }, // concatena o conteúdo do 0 com o 1
               { case: {"$eq": [{$size: "$_id.genero" }, 3] },
                then: {"$concat": [ { "$arrayElemAt" : ["$_id.genero", 0]  }, "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 1]  },  "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 2]  } ] } } // concatena o conteúdo do 0, 1 e 2
            ],
            default: {"$concat": [ { "$arrayElemAt" : ["$_id.genero", 0]  }, "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 1]  },  "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 2]  }," + outros" ] } }} , contagem_genero: 1, _id: 0} },
           {$sort : { contagem_genero: -1  } } ])

//d) Mostre o total de votos por Gênero de filme com mais de 10 mil votos.
/**** primeiro converter votes ***/
// ETL : EXtract, Transform e LOad
db.movie.find() // 1,000.99 -> com parseInt vira 1
// estratégia : 1,233,746 eliminar as vírgulas -> 1233746 e depois converter para inteiro
// split vai gerar [1 , 233,  746] e o concat 1233746
// transformando votes sem a virgula
//$convert : converte um valor para um tipo de dado específico
//  input = valor, to : tipo de dado, onError e onNull = valor para esses casos
// $reduce : aplica uma expressão para cada elemento de um vetor e combina em um único valor
// input = expressão ou elemento de um vetor, initialValue = valor inicial cumulativo antes do in ser aplicado
// in = expressão aplicada para cada elemento da expressão ou vetor : value é a varaivel que representa o valor cumulativo
// this = é a variável que se refere ao elemento que está sendo processado
// $split : divide uma string em um vetor de substrings a partir de um delimitador
// $concat : concatena strings em uma só

db.movie.aggregate([
   { $addFields: { // a transformação vaipara um novo campo votação
           votação: { $convert: { 
                               input: { $reduce: { input: { $split: ['$votes', ','] }, initialValue: '',
                   in: { $concat: ['$$value', '$$this'] } } }, 
                   to: "string", 
                   onError: 0 , 
                   onNull: null} }
               }
   }
 ]).forEach ( function (doc)
  {db.movie.save(doc) } )

// verificando o datatype de um campo -- votação é string
db.movie.aggregate ([
  {"$project": {tipodado : {$type: "$votação" } } }
])
// visualizando votes e votação
db.movie.find().project({votes:1, votação:1, _id:0})
// converter string para inteiro
db.movie.find({votação: {$ne: ""}}).count() // 62058 não são nulos
db.movie.find({votação: {$eq: null}).count() // 2 são nulos
// convertendo para inteiro
db.movie.find({votação: {$ne: ""}}).forEach ( function (doc) 
  { doc.votação = parseInt (doc.votação) ;
    db.movie.save(doc) } )
//verificando   
db.movie.aggregate ([
{$group : {_id: null ,
           contagem: {$count : {}} ,
           maior_votação: {$max: "$votação"},
           menor_votação: {$min: "$votação"},
           media_votação: {$avg: "$votação"},
           total_votos : {$sum: "$votação" }} }  ] )
// 2 docs com NaN : not a number
db.movie.find({votação:NaN})
db.movie.updateMany({votação:NaN}, {$set: {votação: null}} )
// finalmente a consulta
db.movie.aggregate (
  { $group : { _id: {genero: "$genre"},  
              soma_genero : {$sum : "$votação" } } },
{$project : {Gênero: {$cond : {"if" : {"$eq": [{$size: "$_id.genero" }, 1] },
                               "then":  { "$arrayElemAt"  : ["$_id.genero", 0]  },
            "else": {"$concat": [ { "$arrayElemAt" : ["$_id.genero", 0]  }, "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 1]  } ] } }}, 
              soma_genero: 1, _id: 0} },
 {$match: {soma_genero : {$gte: 1000000}}},
            {$sort : { soma_genero: -1  } } )

// usando case
db.movie.aggregate ([
  { $group : { _id: {genero: "$genre"},  
              soma_genero : {$sum : "$votação" } } },
{$project : {Gênero: 
              {$switch:   
{ branches: [ { case: {"$eq": [{$size: "$_id.genero" }, 1] },
                then:  { "$arrayElemAt"  : ["$_id.genero", 0]  } },
              { case: {"$eq": [{$size: "$_id.genero" }, 2] },
                then: {"$concat": [ { "$arrayElemAt" : ["$_id.genero", 0]  }, "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 1]  } ] } },
               { case: {"$eq": [{$size: "$_id.genero" }, 3] },
                then: {"$concat": [ { "$arrayElemAt" : ["$_id.genero", 0]  }, "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 1]  },  "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 2]  } ] } }
            ],
            default: {"$concat": [ { "$arrayElemAt" : ["$_id.genero", 0]  }, "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 1]  },  "/", 
                                  { "$arrayElemAt" : ["$_id.genero", 2]  }," + outros" ] } }} , soma_genero: 1, _id: 0} },
   {$match: {soma_genero : {$gte: 1000000}}},
            {$sort : { soma_genero: -1  } } ])

//e) Mostre os 10 filmes com maior elenco, título e quantidade do elenco
// tamanho de elenco 
db.movie.aggregate( [
    {$project : {tamanho_elenco: {$size: "$actors" }}},
    {$group: {_id: "$tamanho_elenco",
              count_tamanho: {$count: {}}}},
    {$sort: {_id: -1}} ]) 
 
 db.movie.aggregate([
     {$project : {title: 1, tamanho_elenco: {$size: "$actors" }, _id:0 }
    {$sort: {tamanho_elenco: -1}},
    {$limit: 1000} 
])
