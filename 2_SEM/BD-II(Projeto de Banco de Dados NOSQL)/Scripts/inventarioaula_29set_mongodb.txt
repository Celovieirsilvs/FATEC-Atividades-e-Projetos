use inventario_aula
show dbs
show collections
// criando a coleção empresa
db.empresa.insertOne({razao_social : 'Ibm do Brasil Ltda',
    cnpj: 123456 , endereço : 'Rua Tutóia, 200 - Paraíso' })
// selecionando - equivale ao SELECT * FROM
db.empresa.find({})
db.empresa.deleteOne({"_id" : ObjectId("632c576083d34947f9b6a03f")})
// deleta vários db.empresa.deleteMany({razao_social: /ibm/i})
// incluindo mais de um documento
db.empresa.insertMany( [{ razao_social : 'Microsoft do Brasil Ltda',
cnpj: 678901, tipo: 'Fabricante', endereço: {rua: 'Vegueiro',
número: 6000, bairro: 'Ipiranga'}, ano_fundação: 1977},
{razao_social: 'ABC Distribuidora Equipamentos Ltda',
cnpj: 123987, tipo: 'Fornecedor', fones: [1234, 5678, 9012] } ] )
// busca pelo bairro
db.empresa.find({"endereço.bairro": {$regex: /Ipiranga/i }})
// busca pelo bairro e rua
db.empresa.find({"endereço.bairro": {$regex: /Ipiranga/i }},
	{"endereço.rua": {$regex: /verg/i}} )
// testando o AND
db.empresa.find({"endereço.bairro": {$regex: /Ipiranga/i }},
	{"endereço.rua": {$regex: /naza/i}} )
// usando o OR	
db.empresa.find( {$or: [{"endereço.bairro": /Ipiranga/i },
{"endereço.rua": /naza/i}] } )	
// busca pelo bairro - negação
db.empresa.find({"endereço.bairro": {$not: /Ipiranga/i }})
// atualizando Vegueiro
db.empresa.find({"endereço.rua": {$regex: /veg/i}})
db.empresa.updateOne({"endereço.rua": {$regex: /veg/i}},
	{$set: {"endereço.rua": 'VERGUEIRO'}})
db.empresa.updateOne({razao_social: /abc/i },
	{$set: {endereço: {rua: 'Frei João', número: 90, cep: 12345,
	fones: [554433, 221199] }} )
// filtrando o que será exibido
db.empresa.find({})
   .projection({razao_social:1, ano_fundação:1})
   .sort({_id:-1})
   .limit(100)
// tratatamento dos vetores
// incluindo um novo número de telefone para ABC Distribuidora
db.empresa.updateOne({razao_social: /abc/i },
	{$set: {"endereço.fones" : [8877744] }} )
// incluindo cada um separado -- errado
db.empresa.updateOne({razao_social: /abc/i },
	{$set: {"endereço.fones" : {$push: [554433] }}} )
// incluindo cada um separado
db.empresa.updateOne({razao_social: /abc/i },
	{$push: {"endereço.fones" : {$each: [554433, 221199] }}} )
// atualizar um dos números de telefone
db.empresa.updateOne({razao_social: /abc/i ,
"endereço.fones" : 8877744 },
{$set: {"endereço.fones.$": 4477788}} )
// excluindo um elemento do vetor
db.empresa.updateOne({razao_social: /abc/i },
	{$pull: {"endereço.fones": 554432}} )
// incluindo os telefones com estrutura
db.empresa.updateOne({razao_social: /micro/i},
	{$set: {fones: [{ddd: 11, número : 123789, tipo: 'comercial'},
	{ddd: 11, número: 987654, tipo: 'celular', contato: 'Chico'}}}]}

db.empresa.find({"fones.contato": /chico/i)	

// Atividade 4
// coleção software
db.software.drop()
db.software.insert({id:'WIN11', nome: 'Windows 11', versao: '11.5.2R'})
db.software.insert({id:'OFF16', nome: 'Office 365', tipo: 'Office' })
db.software.insert({id:'ORA21', nome: 'Oracle 21c', versao: '21.1.1',
 tipo : 'SGBD'})
db.software.find()
// coleção departamento
db.departamento.insertMany ([{id: 10, nome:'Informatica', centro_custo: '10.2.3'},
{id: 20, nome:'Recursos Humanos', localização : 'Sala 10'}])
db.departamento.insert({id: 11, nome:'Administração', localização : 'Sala 11'}]))

db.departamento.find()
db.departamento.find({nome: {$ne: 'informatica'}})
db.departamento.find({nome: {$not: /informatica/i}})
//c)Faça uma consulta mostrando os documentos de software que não são da categoria Sistema Operacional;
db.software.find({tipo: {$not : /operacional/i}})
//d)Faça uma consulta mostrando os documentos de departamento cujo nome tem ‘ção’ no nome.
db.departamento.find({nome: /ÇÃO/i})
// Aula 29/set - Construindo coleção equipamento e relacionando com 
// software e departamento
db.equipamento.drop()
db.equipamento.find()
db.equipamento.insert({patrimonio: 100, modelo: 'ThinkPad 1000',
tipo: 'Computador', 
caracteristicas : {processador: 'I7', velocidade_ghz: 3.2, ram_gb: 16,
armazenamento_gb: 1000} })
db.equipamento.insertOne({patrimonio: 101, modelo : 'Epson 1100',
tipo: 'Periferico', categoria: 'Impressora',
caracteristicas : {ppm: 20, tipo: 'Jato de Tinta Colorida',
resolução_dpi: 1200, tam_max_papel: 'A3' } } )
// incluindo o campo tipo no computador
db.equipamento.updateOne({patrimonio: 100},
{$set: {categoria: 'Notebook'}})
// incluir o fornecedor-fornecimento no equipamento 101
db.empresa.find({tipo: /fornec/i})
// excluir um dos ABCs
db.empresa.deleteOne({"_id" : ObjectId("632c62b083d34947f9b6a041")})
// incluindo o endereço para o ABC
db.empresa.find({tipo: /fornec/i, razao_social : /abc/i})
db.empresa.updateOne({tipo: /fornec/i, razao_social : /abc/i},
	{$set: {endereço: {logradouro: 'Silva Bueno', número: 1200,
	        bairro: 'Ipiranga', cidade: 'São Paulo'} } })
// relacionando eqpto com o fornecedor
db.equipamento.updateOne({patrimonio: 101},
 {$set: {fornecimento: {fornecedor_cnpj: 123987 , 
                        dt_aquisição : ISODate("2022-03-10T14:22:15.333Z"),
						valor_aquisição: 1800.99
 nota_fiscal : 'F0123', garantia : 24}} } )
// supondo que deu errado, apagar o campo inteiro
db.equipamento.updateOne({patrimonio: 101},
	{$unset: {fornecimento: ""} })
	db.equipamento.find()
// relacionando as duas coleções - join do mongodb
// equipamento com fornecedor pelo cnpj - quem é o fornecedor de cada eqpto
db.equipamento.aggregate(
{ $lookup :
	{from: "empresa" ,
	 localField: "fornecimento.fornecedor_cnpj" ,
	 foreignField: "cnpj"
	 as: "fornecedor_eqpto"		
	}
} )
//  quais são os eqptos fornecidos por uma empresa
db.empresa.aggregate(
{ $lookup :
	{from: "equipamento" ,
	 localField: "cnpj" ,
	 foreignField:  "fornecimento.fornecedor_cnpj"
	 as: "eqptos_fornecidos"		
	}
} )
//  colocando filtros
db.empresa.aggregate(
{$match : {tipo: /fornec/i} }, 
{ $lookup :
	{from: "equipamento" ,
	 localField: "cnpj" ,
	 foreignField:  "fornecimento.fornecedor_cnpj"
	 as: "eqptos_fornecidos"		
	}
},
{$unwind: "$eqptos_fornecidos"},
	{$match: {"eqptos_fornecidos.categoria" : {$not: /impressora/i}}},
	{$project: {_id: 0, razao_social: 1, 
	            "eqptos_fornecidos.modelo": 1, 
				"eqptos_fornecidos.tipo": 1}}
)
// relacionando eqpto 100 com o fornecedor
db.equipamento.updateOne({patrimonio: 100},
 {$set: {fornecimento: {fornecedor_cnpj: 123987 , 
                        dt_aquisição : new Date(),
						valor_aquisição: 6999.99
 nota_fiscal : 'NTD123', garantia : 24}} } )
// relacionando o computador com os softwares instalados
db.software.find()
db.equipamento.updateOne({patrimonio: 100, tipo: /comp/i},
	{$set : {softwares_instalados : 
	          [{id_softw: 'WIN11' , licença: '123XYZ',
 			  dt_hora_instalação: new Date(), fabricante_cnpj : 678901 },
			   {id_softw: 'ORA21' , licença: 'KYW987', 
			  dt_hora_instalação: new Date()}]
	} } )
// mostrando os softwares instalados
db.equipamento.aggregate(
{$lookup:
	{from : "software",
	 localField : "softwares_instalados.id_softw",
	 foreignField: "id",
	 as : "instalação_softw"
    }
} )
// mostrar os softwares e fornecedor
db.equipamento.aggregate(
// junção com software
{$lookup:
	{from : "software",
	 localField : "softwares_instalados.id_softw",
	 foreignField: "id",
	 as : "instalação_softw" } },
//junção com fornecedor
{ $lookup :
	{from: "empresa" ,
	 localField: "fornecimento.fornecedor_cnpj" ,
	 foreignField: "cnpj",
	 as: "fornecedor_eqpto"	} } )
// mostrar os softwares e fornecedor, filtrando
db.equipamento.aggregate(
// junção com software
{$lookup:
	{from : "software",
	 localField : "softwares_instalados.id_softw",
	 foreignField: "id",
	 as : "instalação_softw" } },
//junção com fornecedor
{ $lookup :
	{from: "empresa" ,
	 localField: "fornecimento.fornecedor_cnpj" ,
	 foreignField: "cnpj",
	 as: "fornecedor_eqpto"	} },
	{$unwind: "$instalação_softw"},
	{$unwind: "$fornecedor_eqpto"},
	{$project: {_id:0, patrimonio: 1, modelo:1,
	  "instalação_softw.nome" :1, "instalação_softw.versão" :1,
	"fornecedor_eqpto.razao_social": 1, "fornecedor_eqpto.fones": 1 } )
	
/*Atividade 05: Banco NO-SQL – MongoDB
Com base nos atributos do Modelo Lógico-Relacional, utilizando a linguagem javascript no SGBD MongoDB
a) Altere a estrutura de equipamento para referenciar os departamentos em que o computador foi alocado (dois departamentos, um 
que já alocou e desalocou e o atual em que está alocado);*/
db.equipamento.updateOne({patrimonio: 100},{$set: {alocacao_eqpto:[{departamento_id: 10, nome_dep: "Informatica", 
                                                dt_hr_inst: ISODate("2022-04-24T18:50:35.555Z"), dt_hr_desint: new Date()}, 
                                                {departamento_id: 11, nome_dep: "Administração", 
                                                dt_hr_inst: new Date()}]} })
db.equipamento.find()
/*b) Altere a estrutura de equipamento para referenciar os periféricos instalados nos computadores atualmente, com a data de 
instalação (dois periféricos no computador cadastrado em aula, se necessário cadastre mais um periférico)*/
db.equipamento.insertOne({patrimonio: 102, modelo: "Logitech G203 LIGHTSYNC RGB", tipo: "Periferico", categoria: "Mouse", 
                         fornecimento: {fornecedor_cnpj: 123987, dt_aquisição: new Date(), 
                         valor_aquisicao: 128.99, nota_fiscal: "MOU123", garantia: 24}})
db.equipamento.updateOne({tipo: "Computador"}, {$set: {perif_inst: [{num_patr_perif: 101, dt_hr_inst: ISODate("2022-04-25T10:38:11.111Z")},
                                                                 {num_patr_perif: 102, dt_hr_inst: ISODate("2022-04-26T14:45:45.555Z")}]}})
/*c) Faça uma consulta que mostre os seguintes dados do computador : patrimonio, marca, processador, nome dos softwares 
instalados, data de instalação, versão e número da licença*/
db.equipamento.aggregate({$match: {tipo: /Computador/i}},
                          {$lookup : 
                            {from: "software",
                            localField: "softwares_instalados.id_softw",
                            foreignField: "id",
                            as: "softwares_inst"
                            }
},{$unwind: "$softwares_inst"},
  {$project: {_id: 0, patrimonio: 1, modelo: 1, "caracteristicas.processador": 1, "softwares_instalados.dt_hora_instalação": 1,  "softwares_instalados.licença": 1,
                                    "softwares_inst.nome": 1, 
                                    "softwares_inst.versao": 1}})
/*d) Faça uma consulta que mostre os seguintes dados do departamento : nome, centro de custos, patrimonio e modelo dos 
computadores alocados e a data de alocação.*/
db.departamento.aggregate({$lookup : 
                          {from: "equipamento",
                           localField: "id",
                           foreignField: "alocacao_eqpto.departamento_id",
                           as: "dep_alocações"
                           },
},{$match: {"dep_alocações.tipo": /Comp/i}}, 
  {$unwind: "$dep_alocações"},
  {$project: {_id: 0, nome: 1, centro_custo: 1, "dep_alocações.patrimonio": 1, "dep_alocações.modelo": 1,
                                    "dep_alocações.alocacao_eqpto.dt_hr_inst": 1}})
db.software.find()
db.departamento.find()
db.equipamento.find()









	
	








