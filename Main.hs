-- author: Konrad Kania
-- licence: as-is with restriction of commercial use.
-- this version of presented software has been made only for testing purpose

import Block
import DBManager
import HashCalculator
import System.Environment(getArgs)
import System.Directory(doesFileExist)
import Data.Time.Clock(getCurrentTime)

helpMsg = "Useage: chainstore file.db --option \n --show Show all records \n --latest Show latest added record\n --add CONTENT Add record with own CONTENT \n --verify Check database corectness"

errMsg  = "Bad arguement or operation not permited"

parseArgs :: [String] -> IO ()
parseArgs args@(f:a:xs) = case a of "--show" -> do
                                        blocks <- getAll f
                                        putStrLn (show $ blocks)
                                    "--latest" -> do
                                        block <- get f
                                        putStrLn (show $ block)
                                    "--add" -> do
                                        lastblk <- get f
                                        times  <- getCurrentTime
                                        newblk <- return $ newBlock (show $ times) (head xs) lastblk
                                        put newblk f
                                    "--verify" -> do
                                        blocks <- getAll f
                                        verdict <- return $ blockverify $ blocks
                                        if verdict
                                            then putStrLn "Database correct"
                                        else putStrLn "Database CORRUPTED"
                                    _ -> putStrLn errMsg

create :: [String] -> IO ()
create (f:a:_) = case a of "--create" -> newDB f
                           _ -> putStrLn errMsg

main = do
    args <- getArgs
    if (length $ args) < 2
        then putStrLn helpMsg
    else do
        existence <- doesFileExist (head $ args)
        if existence
            then parseArgs $ args
        else create $ args