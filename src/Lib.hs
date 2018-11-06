{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric     #-}

module Lib ( files ) where

import Turtle
import Prelude  hiding (FilePath)
import Data.Csv hiding (Parser)
import GHC.Generics    (Generic)
import Data.Maybe      (fromMaybe)

files :: IO ()
files = do
    (src, dest) <- options "TODO: add description" parser
    info <- infoIf (\_ -> return True) src 
    maybe stdout output dest info

parser :: Parser (FilePath, Maybe FilePath)
parser = (,) <$>           optPath "src"  's' "The source directory"
             <*> optional (optPath "dest" 'd' "The destination csv file")

data Info = Info { path :: FilePath, name :: FilePath, ext :: Text, size :: Size }
    deriving (Generic, Show)

instance ToNamedRecord Info
instance ToField FilePath where toField = toField . format fp
instance ToField Size     where toField = toField . format sz

info :: MonadIO io => FilePath -> io Info
info p = Info (dirname p) (basename p) (fromMaybe "" (extension p)) <$> du p

infoIf :: (FilePath -> IO Bool) -> FilePath -> Shell Info
infoIf pred = info <=< lsif pred

