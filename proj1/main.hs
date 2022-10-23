module Main where
import System.Environment
import System.IO
import Parsing
import Deparse
import Normalize
import SumPoly
import MultPoly
import Derivative

--Reads user input until he writes STOP
readPolys :: IO [Polynomial]
readPolys = do
  x <- getLine
  if x == "STOP"
    then return []
    else do xs <- readPolys
            return ((normalizePoly(parsePolinomio x)) : xs)
    
normalizepoly :: IO()
normalizepoly = do 
    putStrLn "Introduza um polinomio-> Exemplo: (0*x^2 + 2*y + 5*z + y + 7*y^2)"
    temp <- getLine -- temp reads the new line created by putStrLn
    poly <- getLine 
    putStrLn "O polinómio normalizado é igual a: "
    putStrLn((deparsePoly(normalizePoly (parsePolinomio poly)))) 

addpoly :: IO()
addpoly = do 
    putStrLn("Introduza os polinómios que pretende SOMAR no formato: (0*x^2 + 2*y + 5*z + y + 7*y^2).")
    putStrLn("Escreva STOP quando tiver escrito todos os polinómios que deseja multiplicar")
    polys <- readPolys
    putStrLn(deparsePoly(sumPoly polys))

multpoly :: IO()
multpoly = do 
    putStrLn("Introduza os polinómios que pretende MULTIPLICAR no formato: (0*x^2 + 2*y + 5*z + y + 7*y^2).")
    putStrLn("Escreva STOP quando tiver escrito todos os polinómios que deseja multiplicar")
    polys <- readPolys
    putStrLn(deparsePoly(resmultPoly polys))

derivpoly :: IO()
derivpoly = do 
    putStrLn "Introduza um polinomio-> Exemplo: (0*x^2 + 2*y + 5*z + y + 7*y^2)"
    temp <- getLine -- temp reads the new line created by putStrLn
    poly <- getLine 
    putStrLn "Introduza a variável em relação à qual pretende derivar o polinómio:"
    var <- getChar
    putStrLn(deparsePoly (derivPoly var (normalizePoly (parsePolinomio poly))))

processInput :: Char -> IO()
processInput opt
  | opt == 'a' = normalizepoly
  | opt == 'b' = addpoly
  | opt == 'c' = multpoly
  | opt == 'd' = derivpoly
  | otherwise = error "Occorreu um erro!"

main :: IO()
main = do 
    putStrLn "Introduza a opção que pretende realizar: "
    putStrLn "a) Normalizar polinómios"
    putStrLn "b) Adicionar polinómios"
    putStrLn "c) Multiplicar polinómios"
    putStrLn "d) Calcular a derivada de um polinómio"
    putStrLn "Opcao (a/b/c/d):"
    option <- getChar
    if elem option validoptions == False
        then error "Por favor selecione uma opcao valida" 
        else processInput option
    where validoptions = ['a', 'b', 'c', 'd']