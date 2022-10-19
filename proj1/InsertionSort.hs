module InsertionSort where

-- Sort list in alphabetical order
-- Inserts an element a in the correct position on a list a 
myinsert :: Ord a => a -> [a] -> [a]
myinsert elem [] = [elem]
myinsert elem (x:xs)
   | elem <= x = elem : x : xs
   | otherwise = x : myinsert elem xs

-- Insertion Sort
myisort :: Ord a => [a] -> [a]
myisort [] = []
myisort (x:xs) = myinsert x (myisort xs)
