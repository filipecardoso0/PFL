module Normalize where
import Parsing
import InsertionSort
import Data.List

removeCoef0 :: Polynomial -> Polynomial
removeCoef0 [] = []
removeCoef0 (x:xs) 
    | fst x == 0 = removeCoef0 xs
    | otherwise = x : removeCoef0 xs


removeExp0  :: TupleList -> TupleList
removeExp0 [] = []
removeExp0 (x:xs) 
  | snd x  == 0  = removeExp0 xs
  | otherwise = x : removeExp0 xs


addSameVariable :: TupleList -> TupleList
addSameVariable [] = []
addSameVariable [x] = [x]
addSameVariable (x:y:xs)
 | fst x == fst y = addSameVariable (n:xs)
 | otherwise = x : addSameVariable (y:xs)
  where n = (fst x, snd x + snd y)


equalTerms :: Term -> Term -> Bool
equalTerms t1 t2 
    | varst1 == varst2 = True
    | otherwise = False
    where 
        varst1 = snd t1
        varst2 = snd t2


simplifyPoly :: Polynomial -> Polynomial
simplifyPoly [] = []
simplifyPoly [x] = [x]
simplifyPoly (x:y:xs)
    | snd x == snd y = simplifyPoly (n:xs)
    | otherwise = x : simplifyPoly (y:xs)
    where
        n = (fst x + fst y, snd x)


mycompare :: Term -> Term -> Ordering
mycompare a b 
  | snd a > snd b = GT
  | snd a == snd b = EQ
  | otherwise = LT


normalizePoly :: Polynomial -> Polynomial
normalizePoly [] = []
normalizePoly poly = reverse $ simplifyPoly (sortBy mycompare (removeCoef0 [(fst x,addSameVariable (myisort((removeExp0 (snd x)))))  | x<-poly]))

