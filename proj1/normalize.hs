module Normalize where
import Parsing
import InsertionSort
import Data.List
import Data.Char (ord)
--Funcao para remover aquando do parse os coeficientes que sao iguais a 0
removeCoef0 :: Polynomial -> Polynomial
removeCoef0 [] = []
removeCoef0 (x:xs) 
    | fst x == 0 = removeCoef0 xs
    | otherwise = x : removeCoef0 xs

--Funcao para remover aquando do parse os expoentes que sao iguais a 0
removeExp0  :: TupleList -> TupleList
removeExp0 [] = []
removeExp0 (x:xs) 
  | snd x  == 0  = removeExp0 xs
  | otherwise = x : removeExp0 xs

--Funcao para  quando numa lista de tuplos tem a mesma variavel soma-se os expoentes 
addSameVariable :: TupleList -> TupleList
addSameVariable [] = []
addSameVariable [x] = [x]
addSameVariable (x:y:xs)
 | fst x == fst y = addSameVariable (n:xs)
 | otherwise = x : addSameVariable (y:xs)
  where n = (fst x, snd x + snd y)

--funcao que soma os coeficientes quando os termos sao iguais
simplifyPoly :: Polynomial -> Polynomial
simplifyPoly [] = []
simplifyPoly [x] = [x]
simplifyPoly (x:y:xs)
    | snd x == snd y = simplifyPoly (n:xs)
    | otherwise = x : simplifyPoly (y:xs)
    where
        n = (fst x + fst y, snd x)

--funcao que compara a lista de tuplos de 2 termos diferentes
mycompare :: Term -> Term -> Ordering
mycompare a b 
  | snd a > snd b = GT
  | snd a == snd b = EQ
  | otherwise = LT

--funcao que usa todas as funcoes descritas acima para normalizar o polinomio
normalizePoly :: Polynomial -> Polynomial
normalizePoly [] = []
normalizePoly poly =  removeCoef0 (simplifyPoly (sortBy mycompare ([(fst x, addSameVariable ( orderTupleList (myisort  (removeExp0 (snd x)))))  | x<-poly])))
