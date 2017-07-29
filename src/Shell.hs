{-# LANGUAGE FlexibleContexts #-}

module Shell
  ( ShellCmdFailed
  , shell
  , shell_
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

shell ::
     (MonadIO m, MonadLogger m, MonadError ShellCmdFailed m) => Text -> m Text
shell cmd = do
  logDebugN $ "Running command " <> toS cmd
  (ret, out) <- liftIO $ systemOutput . toS $ cmd
  case ret of
    ExitSuccess -> return . toS $ out
    code@(ExitFailure _) -> do
      logWarnN $
        "Command " <> toS cmd <> " has failed with exit code " <> show code
      throwError . ShellCmdFailed $ code

shell_ :: (MonadIO m, MonadLogger m, MonadError ShellCmdFailed m) => Text -> m ()
shell_= void . shell
