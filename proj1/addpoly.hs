module AddPoly where 
import Normalize
import Parsing


addPoly :: [Polynomial] -> Polynomial
addPoly [] = []
addPoly (x:xs) = normalizePoly (x ++ addPoly (xs))

res = addPoly [[(5,[('z',1)]),(-7,[('y',2)]),(7,[('y',1),('z',0)]),(1,[('y',1)]),(2,[('y',1)]),(1,[('x',1),('y',1),('y',1)]),(10,[]),(3,[])],[(5,[('z',1)]),(7,[('y',2)]),(7,[('y',1),('z',0)]),(1,[('y',1)]),(2,[('y',1)]),(1,[('x',1),('y',1),('y',1)]),(10,[]),(3,[])]]