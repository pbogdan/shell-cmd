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
import qualified Turtle.Prelude as P

data ShellCmdFailed =
  ShellCmdFailed ExitCode
  deriving (Eq, Show)

shell :: (MonadIO m, MonadLogger m, MonadError ShellCmdFailed m) => Text -> m ()
shell cmd = do
  ret <- P.shell cmd mempty
  case ret of
    ExitSuccess -> return ()
    code@(ExitFailure _) -> do
      logWarnN $ "Command " <> cmd <> " has failed with exit code " <> show code
      throwError . ShellCmdFailed $ code

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
