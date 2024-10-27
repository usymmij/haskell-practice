{-# LANGUAGE ScopedTypeVariables #-}
module Main where
import Data.Bits
import Data.Char
import Numeric

knownPairs :: () -> [(String, [Int])]
knownPairs ()  = [("coins",   [0xb1, 0x0b, 0xa3, 0x04, 0xf9]), ("dense",   [0xb5, 0xce, 0x12, 0xef, 0xcf]), ("camping", [0xb1, 0xce, 0x9a, 0xc7, 0xf7, 0x94, 0x19]), ("caution", [0xb1, 0xce, 0x55, 0xd0, 0xcc, 0x9a, 0xa4]), ("predict", [0xd1, 0x9a, 0x54, 0xd6, 0x05, 0xc6, 0xd3])]

getEntry :: Char -> Int -> Int -> (String, String)
getEntry pchar iv cipher = ("0x" ++ showHex (xor (ord pchar) iv) "", "0x"++showHex cipher "")

getStringEntry :: String -> Int -> [Int] -> [(String, String)]
getStringEntry (char:charrest) iv (cipher:cipherrest) = getEntry char iv cipher : getStringEntry charrest cipher cipherrest
getStringEntry [] x [] = []

getTupleEntry :: (String, [Int]) -> Int -> [(String, String)]
getTupleEntry (ptex, ciphers) iv = getStringEntry ptex iv ciphers

getEntryTable :: [(String, [Int])] -> Int -> [(String, String)]
getEntryTable (entry:entryrest) iv = getTupleEntry entry iv ++ getEntryTable entryrest iv
getEntryTable [] a = []

getList :: [Int] -> [String] 
getList (li:lis) = ("0x" ++  showHex li "" ): getList lis;
getList [] = []

matchEntry :: [(String, String)] -> String -> String
matchEntry ((p,c):rest) query   | query == c = p ++ " "
                                | otherwise = matchEntry rest query
matchEntry [] q = "a"

parseEntries :: [(String, String)] -> [String] -> Int -> String
parseEntries dict (cipher:cipherrest) iv = [chr (xor iv (read (matchEntry dict cipher) :: Int)) ] ++ parseEntries dict cipherrest (read cipher :: Int)
parseEntries dict [] iv = []


--decrypt :: [Int] -> Int -> (String, String) -> String
--decrypt (c:ct) iv dict = fetchDict 

main :: IO ()
main = do 
    let iv :: Int = 0x1d;
    putStrLn "known pairs";
    let table :: [(String, String)] = getEntryTable (knownPairs ()) iv;
    print table; 

    let ciphertext :: [Int] = [0xb1, 0xce, 0x9a, 0xc7, 0xd3, 0x12];
    print $ getList ciphertext
    print $ parseEntries table (getList ciphertext) iv
