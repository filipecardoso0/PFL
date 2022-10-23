# **PFL PROJECT** 


## **Descrição do Projeto**

Para este projeto, foi-nos pedido para realizar um programa em Haskell, capaz de manipular polinómios permitindo:
 - normalizar polinómios
 - adicionar polinomios 
 - multiplicar polinomios
 - calcular a sua derivada 
 
## **Descrição/Justificação da representação interna**

> **Nota:** Para ajudar na interpretação vai ser usado o polinómio `"x^2*y^3 + 2*y*z^2 + 5*z + 7*y^2"` como exemplo

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

- **parsePolinomio**

No processo de parsing, `parsePolinomio` vai ser a nossa main function, que vai receber um polinómio em `String` e retornar esse mesmo polinómio já no tipo `Polynomial`, chamando várias funções no processo.

```haskell
parsePolinomio :: String -> Polynomial
parsePolinomio [] = []
parsePolinomio str = [parseTermo x | x<-verifyStrs (addSignals (removeSpaces str))]
```

O polinómio recebido tem de ter cada termo separado por um espaço, e a função `removeSpaces` vai então remover esses espaços e retornar uma lista de strings, sendo os elementos os termos do polinomio e os sinais. Depois através da `addSignals` vai se adicionar o sinal ao respetivo termo. 


- **parseTermo e parseVar**

Pela lista de compreensão em `parsePolinomio`, a função `parseTerm` vai receber cada termo do polinómio em `String` e retornar ja no tipo `Term`.

```haskell
parseTermo :: String -> Term
parseTermo [] = error "Termo não existe"
parseTermo str = (coef, (tupl))
    where
        coef = coeficiente (removeMult str)
        tupl = removeNonNecessary [parseVar x | x <- tail (removeMult str)]

```

`Term` vai ser um tuplo de forma (coef, (tupl)), em que para obter o primeiro elemento, que vai ser o coeficiente do termo,  vai se utilizar as funções auxiliares `removeMult` e `coeficiente`. A primeira, como o nome indica, vai retornar uma lista de strings, onde a string mãe e separada no '*'. Aplicando depois `coeficiente` que nos retorna o coefiente do termo.
O segundo elemento, vai ser uma lista de tuplos ,de todas as variaveis e o seu respetivo expoente ,de cada termo. Para isso, aplica-se na mesma `removeMult` mas ja não estamos interessados no coefiente faz se `tail`, removendo assim o coeficinte da lista.

```haskell
parseVar :: String -> (Char, Int)
parseVar str
    | pow == [] = (var, 1)
    | otherwise = (var, read (head pow) :: Int)
    where
        var = head str
        pow = getPower str
```

Novamente através de uma lista de compreenção, por cada elemento da lista, mais propriamente por cada variável de cada termo, vai-se aplicar a função `parseVar`, que nos vai retornar a lista tuplos pretendida em `parseTerm`, dando uso a funções com `pow`, `head`, e `getPower`, cada tuplo com a variável e o seu respetivo expoente.
 
- **normalizePoly**

Tal como o nome indica, o objetivo da função `normalizePoly` vai ser colocar o polinómio da forma mais ordenada e "limpa" para ser possível uma melhor interpretação.

```haskell
normalizePoly :: Polynomial -> Polynomial
normalizePoly [] = []
normalizePoly poly = reverse $ removeCoef0 (simplifyPoly (sortBy mycompare ([(fst x,addSameVariable (myisort((removeExp0 (snd x)))))  | x<-poly])))
```

Para tal começamos por remover as variáveis em que o expoente seja nulo, dado que o resultado de qualquer variável é 1, e 1 é o elementro neutro da multiplicação. Para tal utiliza-se a funçao `removeExp0 (snd x)` para de cada `Term` aplicar sobre o segundo elemento, onde se encontram as variáveis armazenadas numa lista. De seguida, utilizamos a função `addSameVariable` que para casos em que o polinómio esta por exemplo `x*y*x`vai adicionar os expoentes das variáveis iguais, ficam `x^2*y`. Para terminar sao usadas as funções, `simplifyPoly`, que soma termos que têm as mesmas variáveis, e a `removeCoe0`, que remove termos em que o coeficente seja 0, dado que é o elemento neutro da multiplicação.

- **sumPoly**

Para a soma dos polinómios `sumPoly`, dá-se uso à função já criada `normalizePoly`, após se ter contacatenado todos os termos dos polinómios a que a soma é sujeita.

```haskell
sumPoly :: [Polynomial] -> Polynomial
sumPoly [] = []
sumPoly (x:xs) = normalizePoly (x ++ sumPoly (xs))
```

- **multPoly**

No caso da multiplicação o polinómio no inicio da lista é multiplicado pelos polinómios adjacentes de forma recursiva, sendo o resultado dos calculos intermédios guardado até ao polinómio adjacente ser a lista vazia. Assim, seria algo da forma: (((polinómio1 x polinómio2) x polinómio 3) x polinómio 4) x []

```haskell
multPoly :: [Polynomial] -> Polynomial
multPoly [[]] = []
multPoly [x] = x
multPoly (x:y:[]) = mult2Poly x y
multPoly (x:y:xs) = let res = normalizePoly (mult2Poly x y) in multPoly (res:xs)
```









