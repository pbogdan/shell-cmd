{ mkDerivation, base, extra, monad-logger, posix-escape, protolude
, stdenv, text, turtle
}:
mkDerivation {
  pname = "shell-cmd";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base extra monad-logger posix-escape protolude text turtle
  ];
  homepage = "https://github.com/pbogdan/shell-cmd";
  license = stdenv.lib.licenses.bsd3;
}
