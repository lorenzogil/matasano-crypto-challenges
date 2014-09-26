-- http://cryptopals.com/sets/1/challenges/2/
import Numeric (readHex)
import Text.Printf (printf)

groupBy :: Int -> [a] -> [[a]]
groupBy n [] = []
groupBy n xs = [take n xs] ++ groupBy n (drop n xs)

hex2int :: [Char] -> Int
hex2int x = fst  $ head  $ readHex x

mods :: Int -> [Int]
mods 0 = [0]
mods i =
    let (div, mod) = divMod i 2
    in mod:mods div

pad8 :: [Int] -> [Int]
pad8 xs = if length(xs) < 8 then pad8 (0:xs) else xs

int2bits :: Int -> [Int]
int2bits i = pad8 $ reverse $ mods i

hexDecode :: [Char] -> [Int]
hexDecode input = concat [int2bits $ hex2int i | i <- groupBy 2 input]

bitsXor :: Int -> Int -> Int
bitsXor a b = if a == b then 0 else 1

bits2int :: [Int] -> Int
bits2int xs =
    let size = (length xs) - 1
    in sum $ zipWith (\i b -> b * 2 ^ (size - i)) [0..] xs

int2hex :: Int -> [Char]
int2hex i = printf "%02x" i

hexEncode :: [Int] -> [Char]
hexEncode input = concat [int2hex $ bits2int i | i <- groupBy 8 input]

hexXor :: [Char] -> [Char] -> [Char]
hexXor input1 input2 =
    let decodedInput1 = hexDecode input1
        decodedInput2 = hexDecode input2
    in hexEncode (zipWith bitsXor decodedInput1 decodedInput2)

input1 = "1c0111001f010100061a024b53535009181c"
input2 = "686974207468652062756c6c277320657965"

expectedOutput = "746865206b696420646f6e277420706c6179"

main =
    let output = hexXor input1 input2
    in if output == expectedOutput then putStrLn "Correct" else putStrLn "Incorrect"
