/*Nome: Marcelo Vieira da Silva 
Curso: Big Data para negócios
Semestre: 2ºSEM
RA: 2041382211027 */
/*Atividade 04 – Banco NO-SQL – MongoDB 
Com base nos atributos do Modelo Lógico-Relacional, utilizando a linguagem javascript no SGBD MongoDB (lembre-se que em BDs NO-SQL não existe chave primária e estrangeira) */
/*a) Crie uma nova coleção para software. Insira três documentos. 
Em cada um deles use uma estrutura diferente, em comum só o campo nome;*/
use inventario_aula
db.software.insert({código_softw: "WIN1",
                    nome_softw: "Windows 11",
                    versão: "Pro-R1.3",
                    tipo: "Sistema Operacional",
                    cod_fabr: 3 
})

db.software.insertMany([{código_softw: "OFF365", 
                        nome_softw: "Office 365",
                        tipo: 'OFFICE',
                        cod_fabr: 3
},
                        {código_softw: "FIG", 
                        nome_softw: "Figma",
                        versão: "88.1.0",
                        cod_fabr: 3
}])

//checando dados na coleção software
db.software.find({})
/*b) Crie uma nova coleção para departamento. Insira 2 documentos. 
Em cada deles use uma estrutura diferente, em comum só o campo nome;*/
db.departamento.insertMany([{nome_depto: 'Recursos Humanos', 
                             cod_depto: 1,
                             localizaçao: 'Sala 12',
                             ramal: 1221,
                             Cen_custo: '11.1.5',
},                          
                            {nome_depto: 'Administração', 
                             cod_depto: 2,
                             localizaçao:  '20.3.2'
}])
//checando a coleção departamento
db.departamento.find({})
//c) Faça uma consulta mostrando os documentos de software que não são da categoria Sistema Operacional;
db.software.find({tipo: {$not:/sistema/i}})
//d) Faça uma consulta mostrando os documentos de departamento cujo nome tem ‘ção’ no nome.
db.departamento.find({nome_depto: {$regex: /ção/i}})