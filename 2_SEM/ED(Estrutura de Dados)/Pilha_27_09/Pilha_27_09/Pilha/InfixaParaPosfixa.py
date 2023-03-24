from Stack import Stack

def infix_to_postfix(infix_expr):
    prec = {}

    prec["*"] = 3
    prec["/"] = 3
    prec["+"] = 2
    prec["-"] = 2
    prec["("] = 1

    #cria o objeto do tipo pilha, chamado op_stack, para armazenar
    op_stack = Stack()
    #cria uma lista de elemento final - já no formato posfixo
    postfix_list = []

    #crio uma lista de elementos oriundos da string
    token_list = infix_expr.split()

    for token in token_list:
        if token in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" or token in "0123456789":
            postfix_list.append(token)
            print(postfix_list)
        elif token == '(':
            #empilhar o "("
            op_stack.push(token)
            op_stack.imprimir()
        elif token == ')':
            op_stack.imprimir()
            top_token = op_stack.pop()
            while top_token != '(':
                op_stack.imprimir()
                postfix_list.append(top_token)
                top_token = op_stack.pop()
                print(top_token)
                print(postfix_list)
        else:
            while (not op_stack.is_empty()) and (prec[op_stack.peek()] >= prec[token]):
                postfix_list.append(op_stack.pop())
            op_stack.push(token)

    while not op_stack.is_empty():
        postfix_list.append(op_stack.pop())

    return " ".join(postfix_list)
    #return postfix_list => retorna em formato de lista


print(infix_to_postfix("A * B + C * D"))
print(infix_to_postfix("( A + B ) * C - ( D - E ) * ( F + G )"))
