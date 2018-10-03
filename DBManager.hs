-- author: Konrad Kania
-- licence: as-is with restriction of commercial use.
-- this version of presented software has been made only for testing purpose


{-# LANGUAGE OverloadedStrings #-}
module DBManager (get, put, getAll, newDB) where

import Block
import Database.SQLite.Simple
import Database.SQLite.Simple.FromRow
import System.Command
import Data.Time.Clock(getCurrentTime)

instance FromRow Block where
    fromRow = Block <$> field <*> field <*> field <*> field <*> field

instance ToRow Block where
    toRow (Block index timestamp payload previoushash hash) = toRow (index, timestamp, payload, previoushash, hash)

dbcommand = "CREATE TABLE main (ix integer PRIMARY KEY, timestamp text NOT NULL, payload text, prevhash BLOB NOT NULL, hash text NOT NULL);"

get :: String -> IO Block
get dbfile = do
    conn <- open dbfile
    result <- query_ conn "SELECT * FROM main ORDER BY ix DESC LIMIT 1" :: IO [Block]
    close conn
    return (head $ result)

put :: Block -> String -> IO ()
put block dbfile = do
    conn <- open dbfile
    execute conn "INSERT INTO main (ix, timestamp, payload, prevhash, hash) VALUES (?,?,?,?,?)" block
    close conn

getAll :: String -> IO [Block]
getAll dbfile = do
    conn <- open dbfile
    result <- query_ conn "SELECT * FROM main ORDER BY ix ASC" :: IO [Block]
    close conn
    return result

newDB :: String -> IO ()
newDB db = do
    ps <- createProcess (proc "sqlite3" [db,dbcommand])
    wait <- waitForProcess $ (\(_,_,_,ph) -> ph) ps
    times <- getCurrentTime
    gblk <- return $ genesisBlock (show $ times) "--INITIAL BLOCK--"
    put gblk db