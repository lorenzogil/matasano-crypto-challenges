-- http://cryptopals.com/sets/1/challenges/3/
import Data.Bits (xor)
import Data.Char (chr, toLower)
import Data.Function (on)
import Data.List (sortBy)
import Numeric (readHex)

groupBy :: Int -> [a] -> [[a]]
groupBy n [] = []
groupBy n xs = [take n xs] ++ groupBy n (drop n xs)

hex2int :: [Char] -> Int
hex2int x = fst  $ head  $ readHex x

hexDecode :: [Char] -> [Int]
hexDecode input = [hex2int i | i <- groupBy 2 input]

xorList :: [Int] -> Int -> [Int]
xorList list key = (zipWith xor list (repeat key))

frequency :: Int -> Int
frequency byte
    | char == 'e' = 13
    | char == 't' = 12
    | char == 'a' = 11
    | char == 'o' = 10
    | char == 'i' = 9
    | char == 'n' = 8
    | char == ' ' = 7
    | char == 's' = 6
    | char == 'r' = 5
    | char == 'h' = 4
    | char == 'd' = 3
    | char == 'l' = 2
    | char == 'u' = 1
    | otherwise   = 0
    where char = toLower $ chr byte

score :: [Int] -> (Int, [Int])
score candidate =
    let result = sum [frequency c | c <- candidate]
    in (result, candidate)

stringify :: [Int] -> [Char]
stringify list = [chr d | d <- list]

decrypt :: [Char] -> [Char]
decrypt input =
    let decoded = hexDecode input
        candidates = [score $ xorList decoded key | key <- [0..255]]
        sortedCandidates = sortBy (flip (compare `on` fst)) candidates
        solution = snd $ head sortedCandidates
    in stringify solution

main =
    putStrLn $ decrypt "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
