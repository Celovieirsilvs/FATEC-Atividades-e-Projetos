# Completed implementation of a stack ADT
class Stack:
    #método construtor - serve pra iniciar um tipo de classe objeto;
    def __init__(self):
        #inicia uma lista vazia
        self.items = []

    def is_empty(self):
        #indica se a pilha está vazia - usado para verificar se a pilha está vazia
        return self.items == []

    def push(self, item):
        #este método é utilizado para empilhar elementos na pilha
        self.items.append(item)

    def pop(self):
        #remove elementos da pilha
        return self.items.pop()

    def peek(self):
        #mostra o elemento que está no topo da pilha
        return self.items[len(self.items) - 1]

    def size(self):
        #mostraa a quantidade de elementos que estão pilha
        return len(self.items)

    def imprimir(self):
        # mostra todos os elementos da pilha
        return print(self.items)

# criar objeto do tipo Pilha
objetopilha = Stack()

print(objetopilha.is_empty())
objetopilha.push(4)
objetopilha.push('dog')
print(objetopilha.peek())
objetopilha.imprimir()
objetopilha.push(True)
objetopilha.imprimir()
print(objetopilha.size())
print(objetopilha.is_empty())
objetopilha.push(8.4)
objetopilha.imprimir()
print(objetopilha.pop())
objetopilha.imprimir()
print(objetopilha.pop())
objetopilha.imprimir()
print(objetopilha.size())
