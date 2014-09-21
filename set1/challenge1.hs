-- http://cryptopals.com/sets/1/challenges/1/
import Data.Char (chr, ord)
import Numeric (readHex)

groupBy :: Int -> [a] -> [[a]]
groupBy n [] = []
groupBy n xs = [take n xs] ++ groupBy n (drop n xs)

hex2int :: [Char] -> Int
hex2int x = fst (head (readHex x))

mods :: Int -> [Int]
mods 0 = [0]
mods i =
    let (div, mod) = divMod i 2
    in mod:mods div

pad8 :: [Int] -> [Int]
pad8 xs = if length(xs) < 8 then pad8 (0:xs) else xs

int2bits :: Int -> [Int]
int2bits i = pad8 (reverse (mods i))

bits2int :: [Int] -> Int
bits2int xs =
    let size = (length xs) - 1
    in sum [snd(pair) * (2 ^ (size - fst(pair))) | pair <- zip [0..] xs]

int2base64 :: Int -> Char
int2base64 i
    | i < 26 = chr ((ord 'A') + i)
    | i < 52 = chr ((ord 'a') + i - 26)
    | i < 62 = chr ((ord '0') + i - 52)
    | i == 62 = '+'
    | otherwise = '/'

hex2base64 :: [Char] -> [Char]
hex2base64 s =
    let sixbitsblocks = groupBy 6 (concat [int2bits (hex2int i) | i <- groupBy 2 s])
    in [int2base64 (bits2int hextet) | hextet <- sixbitsblocks]

input = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
expectedOutput = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

main =
    let output = (hex2base64 input)
    in if output == expectedOutput then putStrLn "Correct" else putStrLn "Incorrect"
