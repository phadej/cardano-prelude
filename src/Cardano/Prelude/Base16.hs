{-# LANGUAGE OverloadedStrings #-}

-- | Helper functions for parsing

module Cardano.Prelude.Base16
  ( parseBase16
  , Base16ParseError(..)
  )
where

import Cardano.Prelude.Base

import qualified Data.ByteString.Base16 as B16
import qualified Data.ByteString.Char8 as BS
import qualified Data.Text.Encoding as Text
import Formatting (bprint, shown)
import Formatting.Buildable (Buildable(build))


newtype Base16ParseError =
  Base16IncorrectSuffix ByteString
  deriving (Eq, Show)

instance Buildable Base16ParseError where
  build (Base16IncorrectSuffix suffix) =
    bprint ("Base16 parsing failed with incorrect suffix " . shown) suffix

parseBase16 :: Text -> Either Base16ParseError ByteString
parseBase16 s = do
  let (bs, suffix) = B16.decode $ Text.encodeUtf8 s
  unless (BS.null suffix) . Left $ Base16IncorrectSuffix suffix
  pure bs
