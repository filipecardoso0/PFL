# **PFL PROJECT** 


## **Descrição do Projeto**

Para este projeto, foi-nos pedido para realizar um programa em Haskell, capaz de manipular polinómios permitindo:
 - normalizar polinómios
 - adicionar polinomios 
 - multiplicar polinomios
 - calcular a sua derivada 
 
## **Descrição/Justificação da representação interna**

> **Nota:** Para ajudar na interpretação vai ser usado o polinómio "0*x^2*y^3 + 2*y*z^2 + 5*z + 7*y^2" como exemplo

Um polinómio normalmente é composto por vários termos, e cada um destes termos vai composto pelo o seu coeficiente, e as suas variáveis, e cada variável vai ter o seu expoente.
Dado isto, para facilitar a representação de cada polinómios decidimos criar as seguintes variáveis:

```haskell
type Tuple = (Char,Int)
type TupleList = [(Char,Int)]
type Term = (Int, TupleList)
type Polynomial = [Term]
```

**Type Tuple**

Começamos por definir uma variável Tuple, um tuple (Char, Int) que armazena uma variável(Char) e o seu respetivo expoente(Int). 
> Exemplo do primeiro Tuple do polinómio:
```haskell
('x',2) 
```
**Type TupleList**

Uma lista que vai armazenar todos Tuple, ou seja, todas as variáveis e os respetivos expoentes de um polinómio que façam parte do mesmo termo(Term).
> Exemplo da primeira TupleList do polinómio:
```haskell
[('x',2),('y',3)]
```
**Type Term**

Um tuplo de dois elemntos que vai armazenar um termo, em que no primeiro elemento vai ser o coeficiente desse termo, e no segundo uma lista com todas as variávies desse termos e os seus expoentes(TupleList).
> Exemplo do primeiro polinómio:
```haskell
(0,[('x',2),('y',3)])
```

**Type Polynomial**

Uma lista composta por todos os termos(Term) do polinómio.
> Exemplo da representação completa do polinómio:
```haskell
[(0,[('x',2),('y',3)]),(2,[('y', 1),('z',2)]),(5,[('z',1)]),(7,[('y',2)])]
```

## **Descrição das Funções**

### **Main Functions**

#### **parsePolinomio**


```haskell
parsePolinomio :: String -> Polynomial
```

No processo de parsing, `parsePolinomio` vai ser a nossa main function, que vai receber um polinómio em `String` e retornar esse mesmo polinómio já no tipo `Polynomial`, chamando várias funções no processo.

```haskell
parsePolinomio :: String -> Polynomial
parsePolinomio [] = []
parsePolinomio str = [parseTermo x | x<-verifyStrs (addSignals (removeSpaces str))]
```

- **removeSpaces e addSignals**
   
```haskell
removeSpaces :: String -> [String]

addSignals :: [String] -> [String]
```
O polinómio recebido tem de ter cada termo separado por um espaço, e a função `removeSpaces` vai então remover esses espaços e retornar uma lista de strings, sendo os elementos os termos do polinomio e os sinais. Depois através da `addSignals` vai se adicionar o sinal ao respetivo termo.

```
*Parsing> addSignals $ removeSpaces "2*x^2*y^3 + 2*y*z^2 + 5*z + 7*y^2"
["2*x^2*y^3","+2*y*z^2","+5*z","+7*y^2"]
```


        
 
        











