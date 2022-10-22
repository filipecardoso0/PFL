module Deparse where 
import Parsing

--Deparsing de um tuplo
deparseTuple :: Tuple -> String
deparseTuple tup --Nao nos precisamos de preocupar com expoentes nulos, pois o polinomio normalizado nao contem expoentes nulos
    | snd tup == 1 = [fst tup] -- Caso seja variavel^1 apenas basta mostrar variavel
    | otherwise =  [fst tup] ++ "^" ++ show (snd tup) --Caso contrario variavel^exp

--Deparsing de uma lista de tuplos
deparseTupleList :: TupleList -> String
deparseTupleList [] = []
deparseTupleList (x:[]) = deparseTuple x
deparseTupleList (x:xs) = deparseTuple x ++ "*" ++ deparseTupleList xs
 
--Deparsing de um termo
deparseTerm :: Term -> String
deparseTerm term 
    | null (snd term) && fst term > 0  = "+" ++ " " ++ show (abs(fst term))
    | null (snd term) && fst term < 0 = "-" ++ " " ++ show (abs(fst term))
    | fst term > 0 = "+" ++ " " ++ show (abs(fst term)) ++ "*" ++ deparseTupleList (snd term)
    | otherwise = "-" ++ " " ++ show (abs(fst term)) ++ "*" ++ deparseTupleList (snd term)

--Deparsing de um polinomio
deparsePoly :: Polynomial -> String
deparsePoly [] = []
deparsePoly (x:[]) = deparseTerm x
deparsePoly (x:xs) = deparseTerm x ++ " " ++ deparsePoly xs
