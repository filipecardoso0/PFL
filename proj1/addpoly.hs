module AddPoly where 
import Normalize
import Parsing


addPoly :: [Polynomial] -> Polynomial
addPoly [] = []
addPoly (x:xs) = normalizePoly (x ++ addPoly (xs))

