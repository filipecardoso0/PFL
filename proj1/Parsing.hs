module Parsing where

--Para efeitos de parsing da string : Utilizacao de todas as funcoes usadas para partir a string 
parsedString :: String -> [[[String]]]
parsedString x = (removeMult(removePlus(removeSpaces x )))
--Depois de recebida a string parti la :
splitString :: String -> Char -> [String]
splitString [] delim = [""]
splitString (x:xs) delim 
  | x == delim = "" : rest
  | otherwise = (x : head rest) : tail rest
  where
    rest = splitString xs delim
--1.Tirando os espacos 
removeSpaces :: String -> String
removeSpaces x = [y | y <-x , y/=' ']
--2.Tirando os '^'
removePow :: [String] -> [[String]]
removePow [] = []
removePow (x:xs) = (splitString x '^') : removePow (xs)
--3.Tirando os '*'
removeMult :: [String] -> [[[String]]]
removeMult [] = []
removeMult (x:xs) = [removePow(splitString x '*')] ++ removeMult (xs)
--4.Tirando os '+'
removePlus :: String -> [String]
removePlus [] = []
removePlus x = splitString x '+'


