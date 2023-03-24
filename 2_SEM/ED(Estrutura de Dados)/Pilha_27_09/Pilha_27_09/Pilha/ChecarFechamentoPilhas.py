from Stack import Stack

#função para checar a ordem de abertura e fechamento de parenteses
def par_checker(symbol_string):
    #cria um objeto pilha
    s = Stack()
    #variavel que supoe que a quantidade de aberturas e fechamentos estejam balanceados
    balanced = True
    #variavel indice que será incrementada até chegar no final da string passada como parâmetro
    index = 0

    while index < len(symbol_string) and balanced:
        symbol = symbol_string[index]
        # se símbolo for igual a "(" incluir na pilha
        if symbol == "(":
            s.push(symbol)
            s.imprimir()
        else:
            #se pilha estiver vazia, coloca variavel balanced como false
            if s.is_empty():
                balanced = False
            else:
                #remove elemento da pilha
                s.pop()
                s.imprimir()

        index = index + 1

    #se a pilha está balanceada e vazia
    if balanced and s.is_empty():
        #retorna verdadeiro
        return True
    else:
        #retorna falso
        s.imprimir()
        return False

    print(symbol)

print(par_checker('((()))'))
print(par_checker('(()'))
print(par_checker('()((()))'))
print(par_checker('()((())'))
print(par_checker('(()))'))
