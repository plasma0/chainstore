-- author: Konrad Kania
-- licence: as-is with restriction of commercial use.
-- this version of presented software has been made only for testing purpose


module HashCalculator(calculateHash) where

import qualified Data.ByteString as BYTE
import qualified Crypto.Hash.SHA256 as SHA256
import qualified Data.Binary as BIN
import qualified Data.ByteString.Char8 as C8
import qualified Data.ByteString.Lazy as LS

calculateHash :: Int -> String -> String -> BYTE.ByteString -> BYTE.ByteString
calculateHash index timestamp payload previoushash = digest
    where
        digest = SHA256.finalize ctx
        ctx    = SHA256.update ctx1 (LS.toStrict (BIN.encode index))
        ctx1   = SHA256.updates ctx0 [C8.pack timestamp, C8.pack payload, previoushash]
        ctx0   = SHA256.init
