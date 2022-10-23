module SumPoly where 
import Normalize
import Parsing


sumPoly :: [Polynomial] -> Polynomial
sumPoly [] = []
sumPoly (x:xs) = normalizePoly (x ++ sumPoly (xs))

