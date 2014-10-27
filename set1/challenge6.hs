-- http://cryptopals.com/sets/1/challenges/6/
import Data.Bits (xor)
import Data.Char (chr, ord, toLower)
import Data.Function (on)
import Data.List (sortBy, transpose)

groupByFill :: Int -> [a] -> a -> [[a]]
groupByFill n [] fill = []
groupByFill n xs fill
    | length xs < n = [xs ++ take (n - length xs) (repeat fill)]
    | otherwise = take n xs:groupByFill n (drop n xs) fill

groupBy :: Int -> [a] -> [[a]]
groupBy n [] = []
groupBy n xs = take n xs:groupBy n (drop n xs)

pad :: Int -> [Int] -> [Int]
pad size xs = if length xs < size then pad size (0:xs) else xs

mods :: Int -> [Int]
mods 0 = []
mods i =
    let (div, mod) = divMod i 2
    in mod:mods div

int2bits :: Int -> Int -> [Int]
int2bits padSize i = pad padSize (reverse (mods i))

int2bits6 = int2bits 6
int2bits8 = int2bits 8

char2intb64 :: Char -> Int
char2intb64 c
  | 'A' <= c && c <= 'Z' = ord(c) - 65
  | 'a' <= c && c <= 'z' = ord(c) - 71
  | '0' <= c && c <= '9' = ord(c) + 4
  | '+' == c = 62
  | '/' == c = 63
  | otherwise   = 0

bits2int :: [Int] -> Int
bits2int xs =
    let size = (length xs) - 1
    in sum [snd(pair) * (2 ^ (size - fst(pair))) | pair <- zip [0..] xs]

b64 :: [Char] -> [Int]
b64 group =
    let bits = concat [int2bits6 (char2intb64 c) | c <- group, c /= '=']
    in [bits2int g | g <- groupBy 8 bits, (length g) == 8]

b64decode :: [Char] -> [Int]
b64decode encoded = concat [b64 g | g <- groupBy 4 encoded]

block2bits :: [Int] -> [Int]
block2bits block = concat [int2bits8 i | i <- block]

hamming :: [Int] -> [Int] -> Int
hamming a b = sum $ zipWith xor (block2bits a) (block2bits b)

distances :: [[Int]] -> [Int]
distances [] = []
distances [x] = []
distances (h:xs) = (hamming h (head xs)):distances xs

normalizedDistance :: Int -> [Int] -> Float
normalizedDistance size input =
    let blocks = groupByFill size input 0
        sumDistances = sum $ distances blocks
        n = length blocks - 1
    in ((fromIntegral sumDistances) / (fromIntegral n)) / (fromIntegral size)

findKeySize :: [Int] -> Int
findKeySize input =
    let candidates = [(size, normalizedDistance size input) | size <- [2..40]]
        sorted = sortBy (compare `on` snd) candidates
    in fst $ head sorted

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

xorList :: [Int] -> [Int] -> [Int]
xorList = zipWith xor

score :: [Int] -> Int -> Int -> (Int, Int)
score block key size = (sum [frequency c | c <- xorList block (repeat key)], key)

solveSingleXOR :: [Int] -> Int
solveSingleXOR block =
    let size = length block
        candidates = [score block key size | key <- [0..255]]
        sortedCandidates = sortBy (flip (compare `on` fst)) candidates
    in snd $ head sortedCandidates

findKey :: [Int] -> Int -> [Int]
findKey input keySize =
    let blocks = transpose $ groupByFill keySize input 0
    in [solveSingleXOR block | block <- blocks]

stringify :: [Int] -> [Char]
stringify list = [chr d | d <- list]

xorDecrypt :: [Int] -> Int -> [Int] -> [Int]
xorDecrypt input keySize key = concat [xorList block key | block <- groupByFill keySize input 0]

decrypt :: [Char] -> [Char]
decrypt b64 =
    let raw  = b64decode [c | c <- b64, c /= '\n']
        keySize = findKeySize raw
        key = findKey raw keySize
    in stringify $ xorDecrypt raw keySize key

main = do
    contents <- readFile "6.txt"
    putStrLn $ decrypt contents
