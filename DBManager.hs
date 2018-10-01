-- author: Konrad Kania
-- licence: as-is with restriction of commercial use.
-- this version of presented software has been made only for testing purpose


{-# LANGUAGE OverloadedStrings #-}
module DBManager (get, put, getAll) where

import Block
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow

instance FromRow Block where
    fromRow = Block <$> field <*> field <*> field <*> field <*> field

instance ToRow Block where
    toRow (Block index timestamp payload previoushash hash) = toRow (index, timestamp, payload, previoushash, hash)

get :: String -> IO Block
get dbfile = do
    conn <- open dbfile
    result <- query_ conn "SELECT * FROM main ORDER BY index DESC LIMIT 1" :: IO [Block]
    close conn
    return (head $ result)

put :: Block -> String -> IO ()
put block dbfile = do
    conn <- open dbfile
    execute conn "INSERT INTO main (index, timestamp, payload, prevhash, hash) VALUES (?,?,?,?,?)" block
    close conn

getAll :: String -> IO [Block]
getAll dbfile = do
    conn <- open dbfile
    result <- query_ conn "SELECT * FROM main ORDER BY index ASC" :: IO [Block]
    close conn
    return result