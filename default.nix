{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc843" }:
nixpkgs.pkgs.haskell.packages.${compiler}.callPackage ./shell-cmd.nix { }
