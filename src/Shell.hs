{-# LANGUAGE FlexibleContexts #-}

module Shell
  ( ShellCmdFailed
  , shell
  , shellOut
  , module Shell.Command
  , module Control.Monad.Logger
  ) where

import           Protolude

import           Control.Monad.Logger
import           Extra (systemOutput)
import           Shell.Command

data ShellCmdFailed =
  ShellCmdFailed ExitCode
  deriving (Eq, Show)

shell :: (MonadIO m, MonadLogger m, MonadError ShellCmdFailed m) => Text -> m ()
shell = void . shellOut

shellOut ::
     (MonadIO m, MonadLogger m, MonadError ShellCmdFailed m) => Text -> m Text
shellOut cmd = do
  (ret, out) <- liftIO $ systemOutput . toS $ cmd
  case ret of
    ExitSuccess -> return . toS $ out
    code@(ExitFailure _) -> do
      logWarnN $
        "Command " <> toS cmd <> " has failed with exit code " <> show code
      throwError . ShellCmdFailed $ code
