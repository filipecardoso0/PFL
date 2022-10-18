module Parsing where
import Data.List.Split
import Data.Char

type Term = (Int, [(Char, Int)])
type Polynomial = [Term]


--Input teste 
str = "0*x^2 + 2*y + 5*z + y + 7*y^2"
str1 = "x + 2*y + 5*z + y + 7*y^2"


--Para efeitos de parsing da string : Utilizacao de todas as funcoes usadas para partir a string 
removeSpaces :: String -> [String]
removeSpaces x = splitOneOf " " x


--Junta os sinais ao coeficiente do respetivo termo
addSignals :: [String] -> [String]
addSignals [] = []
addSignals ("+":y:xs) = ("+"++y) : addSignals xs
addSignals ("-":y:xs) = ("-"++y) : addSignals xs
addSignals (x:xs) = x : addSignals xs

--Variavel para teste auxiliar
str2 = addSignals (removeSpaces str)


--Remove o sinal de multiplicacao em forma de separar os coeficiente e as variáveis de um termo
removeMult :: String -> [String]
removeMult [] = []
removeMult str = wordsBy (== '*') str

fixExpr :: String -> String
fixExpr [] = []
fixExpr ('+':y:xs)
    | y >= 'a' && y <= 'z' = '+' : '1' : '*' : y : xs
fixExpr ('-':y:xs)
    | y >= 'a' && y<= 'z' = '-' : '1' : '*' : y : xs
fixExpr (x:xs)
    | x >= 'a' && x<= 'z' = '1' : '*' : x  : xs -- Casos em que o primeiro termo é uma variável
    | otherwise =  x : fixExpr xs

verifyStrs :: [String] -> [String]
verifyStrs [] = []
verifyStrs [[]] = [[]]
verifyStrs (l:ls) = fixExpr l : verifyStrs ls

-- Termos para testar apenas
x = removeMult "2*x*y^2"
y = removeMult "+3*x*y^2"
z = removeMult "-3*x*y^2"
w = removeMult "+y" 
k = removeMult "-y^2*z^3"
j = removeMult "+54*y^2*z^3"
f = removeMult "54*x*y^2"


--Recebe um termo por processar e extrai o coeficiente
coeficiente :: [String] -> Int
coeficiente [[]] = error "Ocorreu um erro"
coeficiente list 
        | fst == '+' = snd -- O numero é positivo
        | fst == '-' = -(snd) -- O numero é negativo
        | otherwise = read (head list) :: Int --Aqui obtém-se a string corresponde ao coefiente diretamente, depois é so fazer a conversão para inteiro
        where   
            fst = head (head list) --Corresponde ao sinal do termo, exceto quando é o primeiro termo do polinomio (que se for positivo nao tem sinal), então nesse caso corresponderá diretamente ao coeficiente
            snd = read (tail (head list)) :: Int --Corresponde ao coefiente do termo. Se for o primeiro termo então ocorre erro, pois nao vai existir a tail


--Separa a string numa lista em que o primeiro elemento é vazio e o segundo corresponde ao expoente da. Depois, Obtem o elemento da lista correspondente ao power através do tail
getPower :: String -> [String]
getPower [] = []
getPower str = tail (splitOn "^" (tail str))

--Recebe variaveis de um termo por processar e transforma-a num tuplo char, int
parseVar :: String -> (Char, Int)
parseVar str 
    | pow == [] = (var, 0) -- Se nao existir potencia entao corresponde a lista vazia
    | otherwise = (var, read (head pow) :: Int) -- Pega no elemento à cabeça da lista(string da potencia) e transforma-o num inteiro
    where 
        var = head str
        pow = getPower str


--Pega num termo e faz o seu parsing para a representação final
parseTermo :: String -> Term
parseTermo [] = error "Termo não existe"
parseTermo str = (coef, (tupl))
    where 
        coef = coeficiente (removeMult str)
        tupl = [parseVar x | x <- tail (removeMult str)]


parsePolinomio :: String -> Polynomial
parsePolinomio [] = error "Polinómio invalido"
parsePolinomio str = [parseTermo x | x<-verifyStrs (addSignals (removeSpaces str))]

