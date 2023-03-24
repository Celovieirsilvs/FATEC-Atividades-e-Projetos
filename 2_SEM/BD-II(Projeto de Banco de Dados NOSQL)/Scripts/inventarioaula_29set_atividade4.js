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
db.software.insert({id:'ORA21', nome: 'Oracle 21c', versao: '21.1.1', tipo : 'SGBD'})
db.software.find()
// coleção departamento
db.departamento.insertMany ([{id: 10, nome:'Informatica', centro_custo: '10.2.3'},
{id: 20, nome:'Recursos Humanos', localização : 'Sala 10'}])
db.departamento.find()
db.departamento.find({nome: {$ne: 'informatica'}})
db.departamento.find({nome: {$not: /informatica/i}})
//c)Faça uma consulta mostrando os documentos de software que não são da categoria Sistema Operacional;
db.software.find({tipo: {$not : /operacional/i}})
//d)Faça uma consulta mostrando os documentos de departamento cujo nome tem ‘ção’ no nome.
db.departamento.find({nome: /ÇÃO/i})

