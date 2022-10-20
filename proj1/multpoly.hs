module MultPoly where 
import Normalize
import Parsing

p1 :: Polynomial
p1 = [(-12,[('x',2),('y',2)])]
p2 :: Polynomial
p2 = [(-4,[('x',2),('y',1)])]

multTerm :: Term -> Term -> Term
multTerm t1 t2 = (coef, newvars)
    where
        coef = fst t1 * fst t2
        newvars = snd t1 ++ snd t2

mult2Poly :: Polynomial -> Polynomial -> Polynomial
mult2Poly poly1 [] = poly1
mult2Poly [] poly2 = poly2
mult2Poly poly1 poly2 = [multTerm x y | x<-poly1, y<-poly2] 

multPoly :: [Polynomial] -> Polynomial
multPoly [[]] = []
multPoly [x] = x
multPoly (x:y:[]) = mult2Poly x y
multPoly (x:y:xs) =  (mult2Poly x y) ++ multPoly (xs)


t = multPoly [[(3, [('x',1),('y',1)]), (1,[('x',1)])]]
res = normalizePoly $ multPoly [[(3, [('x',1),('y',1)]), (1,[('x',1)])] , [(-4, [('x',1),('y',1)])]]
res1 = normalizePoly $ multPoly [[(3, [('x',1),('y',1)]), (1,[('x',1)])] , [(-4, [('x',1),('y',1)]), (-10, [('x',4),('y',3)])]]
