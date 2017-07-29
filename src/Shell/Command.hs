{-# LANGUAGE FlexibleContexts #-}

module Shell.Command
  ( Args
  , option
  , switch
  , arg
  , raw
  , command
  ) where

import           Protolude

import qualified Data.Text as Text
import           System.Posix.Escape

-- @TODO: think about providing short / log args / switches

type Args = State [Text] ()

option :: MonadState [Text] m => Text -> Text -> m ()
option name value =
  modify (\s -> name <> " " <> (toS . escape . toS $ value) : s)

switch :: MonadState [Text] m => Text -> m ()
switch name = modify (\s -> name : s)

arg :: MonadState [Text] m => Text -> m ()
arg name = modify (\s -> (toS . escape . toS $ name) : s)

raw :: MonadState [Text] m => Text -> m ()
raw name = modify (\s -> name : s)

command :: Text -> Args -> Text
command name x =
  let s = runIdentity $ execStateT x [name]
  in Text.intercalate " " (reverse s)
