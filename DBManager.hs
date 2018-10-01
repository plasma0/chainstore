{-# LANGUAGE OverloadedStrings #-}
module DBManager (get, put, getAll) where

import Block
import Database.SQLite.Simple

get :: IO Block
get = do
    
