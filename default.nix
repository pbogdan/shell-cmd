let
  sources = import ./nix/sources.nix;
in
{ pkgs ? import sources.unstable { }
}:
let
  hspkgs = pkgs.haskellPackages.override {
    overrides = hself: hsuper: with pkgs.haskell.lib; { };
  };

  inherit (hspkgs)
    callCabal2nix
    ;

  inherit (pkgs)
    nix-gitignore
    ;

  shell-cmd = callCabal2nix "shell-cmd" (nix-gitignore.gitignoreSource [ ] ./.) { };
in
shell-cmd
