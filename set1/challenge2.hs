-- http://cryptopals.com/sets/1/challenges/2/
import Data.Bits (xor)
import Numeric (readHex)
import Text.Printf (printf)

groupBy :: Int -> [a] -> [[a]]
groupBy n [] = []
groupBy n xs = [take n xs] ++ groupBy n (drop n xs)

hex2int :: [Char] -> Int
hex2int x = fst  $ head  $ readHex x

hexDecode :: [Char] -> [Int]
hexDecode input = [hex2int i | i <- groupBy 2 input]

int2hex :: Int -> [Char]
int2hex i = printf "%02x" i

hexEncode :: [Int] -> [Char]
hexEncode input = concat [int2hex i | i <- input]

hexXor :: [Char] -> [Char] -> [Char]
hexXor input1 input2 =
    let decodedInput1 = hexDecode input1
        decodedInput2 = hexDecode input2
    in hexEncode (zipWith xor decodedInput1 decodedInput2)

input1 = "1c0111001f010100061a024b53535009181c"
input2 = "686974207468652062756c6c277320657965"

expectedOutput = "746865206b696420646f6e277420706c6179"

main =
    let output = hexXor input1 input2
    in if output == expectedOutput then putStrLn "Correct" else putStrLn "Incorrect"
