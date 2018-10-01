-- author: Konrad Kania
-- this software has been made only for testing purpose
module Block(Block, newBlock)where

import qualified Data.ByteString as BYTE
import qualified Data.Binary as BIN
import qualified Data.ByteString.Base16 as B16
import qualified Data.ByteString.Lazy   as LS
import           HashCalculator 

type Index        = Int
type Timestamp    = String
type Payload      = String
type PreviousHash = BYTE.ByteString
type Hash         = BYTE.ByteString

data Block = Block Index Timestamp Payload PreviousHash Hash
    deriving(Eq)

instance Show Block where
    show (Block index timestamp payload previoushash hash) = "Index: " ++ show index ++ "\nTime stamp: " ++ timestamp ++ "\nPayload: " ++ payload ++ "\nPrevious block hash: " ++ show (B16.encode previoushash) ++ "\nHash: " ++ show (B16.encode hash)

newBlock :: Timestamp -> Payload -> Block -> Block
newBlock timestamp payload (Block index _ _ _ previoushash) = Block (index+1) timestamp payload previoushash (calculateHash index timestamp payload previoushash)

genesisBlock :: Timestamp -> Payload -> Block
genesisBlock timestamp payload = let previoushash = LS.toStrict (BIN.encode (0::Int))
                                     ci = 0
                                  in Block ci timestamp payload previoushash (calculateHash ci timestamp payload previoushash)

