{-# LANGUAGE OverloadedStrings #-}

module Lib ( inventory ) where

import Turtle
import Prelude  hiding (FilePath)
import Data.Maybe      (fromMaybe)

inventory :: IO ()
inventory = do
    (src, mDest) <- options "CSV inventory of files" parser
    exists <- testdir src
    when (not exists) $ die (format ("dir does not exist: "%fp) src)
    maybe stdout output mDest $ return "Path,Name,Extension,Size" <|> do
        path <- lsif (return . notHidden) src 
        file <- testfile path >>= \isfile -> if isfile then return path else empty
        info file

parser :: Parser (FilePath, Maybe FilePath)
parser = (,) <$>           optPath "src"  's' "The source directory"
             <*> optional (optPath "dest" 'd' "The destination csv file (stdout if missing)")

info :: FilePath -> Shell Line
info p = do
    size <- du p
    let ext = fromMaybe "" $ extension p
        txt = format (fp%","%fp%","%s%","%sz) (directory p) (basename p) ext size
    fromMaybe empty (return <$> textToLine txt)

notHidden :: FilePath -> Bool
notHidden = null . match (begins ".") . format fp . basename
