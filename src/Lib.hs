{-# LANGUAGE OverloadedStrings #-}

module Lib ( inventory ) where

import Turtle
import Prelude  hiding (FilePath)
import Data.Maybe      (fromMaybe)

inventory :: IO ()
inventory = do
    (src, dest) <- options "CSV inventory of files" parser
    exists <- testdir src
    when (not exists) $ die (format ("dir does not exist: "%fp) src)
    let files = do path <- lsif (return . notHidden) src 
                   isFile <- testfile path
                   if isFile then return path else empty
    maybe stdout output dest $ return "Path,Name,Extension,Size" <|> do
        f    <- files
        size <- du f
        let ext = fromMaybe "" $ extension f
            rec = format (fp%","%fp%","%s%","%sz) (dirname f) (basename f) ext size
        fromMaybe empty (return <$> textToLine rec)

parser :: Parser (FilePath, Maybe FilePath)
parser = (,) <$>           optPath "src"  's' "The source directory"
             <*> optional (optPath "dest" 'd' "The destination csv file (stdout if missing)")

notHidden :: FilePath -> Bool
notHidden = null . match (begins ".") . format fp . basename
