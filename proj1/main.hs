module Main where
import System.Environment
import System.IO

-- Separate this into other files later on
    
normalizepoly :: IO()
normalizepoly = do 
    putStrLn "Introduza um polinomio-> Exemplo: (0*x^2 + 2*y + 5*z + y + 7*y^2)"
    temp <- getLine -- temp reads the new line created by putStrLn
    poly <- getLine 
    putStrLn poly

addpoly :: IO()
addpoly = do 
    putStrLn "1"

multpoly :: IO()
multpoly = do 
    putStrLn "1"

derivpoly :: IO()
derivpoly = do 
    putStrLn "1"

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