from Stack import Stack


# Completed extended par_checker for: [,{,(,),},]
def par_checker(symbol_string):
    s = Stack()
    balanced = True
    index = 0
    while index < len(symbol_string) and balanced:
        symbol = symbol_string[index]
        print(symbol)
        if symbol in "([{":
            s.push(symbol)
            s.imprimir()
        else:
            if s.is_empty():
                balanced = False
            else:
                top = s.pop()
                print(top)
                if not matches(top, symbol):
                    s.imprimir()
                    balanced = False

        index = index + 1
    if balanced and s.is_empty():
        return True
    else:
        return False

def matches(open, close):
    opens = "([{"
    closes = ")]}"
    # comparação feita pelo indice de cada string (o metodo index utiliza
    # como parametro o valor do símbolo para retornar o seu indice)
    return opens.index(open) == closes.index(close)

#print(par_checker('{{([][])}()}'))
#print(par_checker('[{()]'))
print(par_checker('(([))'))