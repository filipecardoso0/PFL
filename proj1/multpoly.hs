module MultPoly where 
import Normalize
import Parsing

--Funcao usada para multiplicar 2 termos
multTerm :: Term -> Term -> Term
multTerm t1 t2 = (coef, newvars)
    where
        coef = fst t1 * fst t2
        newvars = snd t1 ++ snd t2
--Funcao usada para multiplicar 2 polinomios
mult2Poly :: Polynomial -> Polynomial -> Polynomial
mult2Poly poly1 [] = poly1
mult2Poly [] poly2 = poly2
mult2Poly poly1 poly2 = [multTerm x y | x<-poly1, y<-poly2] 

--Funcao usada para multiplicar n polinomios
multPoly :: [Polynomial] -> Polynomial
multPoly [[]] = []
multPoly [x] = x
multPoly (x:y:[]) = mult2Poly x y
multPoly (x:y:xs) = let res = normalizePoly (mult2Poly x y) in multPoly (res:xs)

--Funcao usada para a normalizacao da multiplicacao de n termos
resmultPoly :: [Polynomial] -> Polynomial
resmultPoly lst = normalizePoly (multPoly lst)
