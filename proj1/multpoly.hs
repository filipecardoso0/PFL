module MultPoly where 
import Normalize
import Parsing

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
multPoly (x:y:xs) = normalizePoly (mult2Poly x y) ++ multPoly (xs)

resmultPoly :: [Polynomial] -> Polynomial
resmultPoly lst = normalizePoly (multPoly lst)

