module Derivative where 
import Normalize
import Parsing

t :: Term
t = (7,[('y', 1),('z',2)])

lst :: TupleList
lst = [('y', 1),('z',2)]

fds :: Polynomial
fds = [(5,[('z',1)]),(-7,[('y',2)]),(7,[('y',1),('z',0)]),(1,[('y',1)]),(2,[('y',1)]),(1,[('x',1),('y',1),('y',1)]),(10,[]),(3,[])]
p = normalizePoly fds 

--Deriva um termo em ordem a uma determinada var

derivTupleList :: Char -> TupleList -> TupleList
derivTupleList ' ' lst = error "Invalid Variable"
derivTupleList var [] = []
derivTupleList var (x:xs)
    | var == fst x = [(var,(snd x -1))] ++ xs -- Encontrou tuplo derivável 
    | otherwise = x : (derivTupleList var xs) -- Nao encontrou tuplo derivável

updateDerivTermCoef :: Char -> Term -> Int
updateDerivTermCoef ' ' term = error "Invalid Variable" 
updateDerivTermCoef var (x,[]) = 0 -- Para casos em que existe apenas coeficiente e não existem variáveis
updateDerivTermCoef var term
    | var == fst x = fst term * snd x -- Encontrou o Tuplo derivável, pega no valor do expoente e atualiza o coeficiente do termo
    | xs == [] = 0 --Variável em função da qual se pretende derivar o polinómio não existe
    | otherwise = updateDerivTermCoef var (fst term, xs) -- Caso contrário, continua a pesquisa
    where 
        (x:xs) = snd term

derivTerm :: Char -> Term -> Term
derivTerm ' ' term = error "Invalid Variable"
derivTerm var term = (updateDerivTermCoef var term, derivTupleList var (snd term))

derivPoly :: Char -> Polynomial -> Polynomial
derivyPoly var [] = []
derivPoly ' ' poly = error "Derivative Error: Invalid Variable"
derivPoly var poly = normalizePoly $ [derivTerm var x | x<-poly]

