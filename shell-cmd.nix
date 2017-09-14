{ mkDerivation, base, extra, monad-logger, posix-escape, protolude
, stdenv, text
}:
mkDerivation {
  pname = "shell-cmd";
  version = "0.2.0.0";
  src = ./.;
  libraryHaskellDepends = [
    base extra monad-logger posix-escape protolude text
  ];
  homepage = "https://github.com/pbogdan/shell-cmd";
  license = stdenv.lib.licenses.bsd3;
}
