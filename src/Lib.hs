{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric     #-}

module Lib ( files ) where

import Turtle
import Prelude  hiding (FilePath)
import Data.Maybe      (fromMaybe)

files :: IO ()
files = do
    (src, dest) <- options "TODO: add description" parser
    maybe stdout output dest $ return "Path,Name,Extension,Size" <|> do
        p <- lsif (\_ -> return True) src 
        info p

info :: FilePath -> Shell Line
info p = do
    size <- du p
    let ext = fromMaybe "" $ extension p
        rec = format (fp%","%fp%","%s%","%sz) (dirname p) (basename p) ext size
    fromMaybe empty (return <$> textToLine rec)


parser :: Parser (FilePath, Maybe FilePath)
parser = (,) <$>           optPath "src"  's' "The source directory"
             <*> optional (optPath "dest" 'd' "The destination csv file")

