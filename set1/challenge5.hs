-- http://cryptopals.com/sets/1/challenges/5/
import Data.Bits (xor)
import Data.Char (ord)
import Text.Printf (printf)

int2hex :: Int -> [Char]
int2hex i = printf "%02x" i

hexEncode :: [Int] -> [Char]
hexEncode input = concat [int2hex i | i <- input]

encrypt :: [Char] -> [Char] -> [Char]
encrypt input key = hexEncode $ zipWith xor (map ord input) (cycle (map ord key))

main =
    putStrLn $ encrypt "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal" "ICE"
