module SumPoly where 
import Normalize
import Parsing

--Funcao que normaliza a concatenacao dos n termos passados
sumPoly :: [Polynomial] -> Polynomial
sumPoly [] = []
sumPoly (x:xs) = normalizePoly (x ++ sumPoly (xs))

