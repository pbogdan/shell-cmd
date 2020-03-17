{ sources ? (import ./nix/sources.nix)
, compiler ? "ghc882"
}:
let
  overlay = self: super: {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        "${compiler}" = super.haskell.packages.${compiler}.override {
          overrides = hself: hsuper: with self.haskell.lib; {};
        };
      };
    };
  };

  pkgs = (
    import sources.unstable {
      overlays = [
        overlay
      ];
    }
  );

  inherit (pkgs.haskellPackages)
    callCabal2nix
    shellFor
    ;
  inherit (pkgs)
    lib
    nix-gitignore
    ;

  shell-cmd = callCabal2nix "shell-cmd" (nix-gitignore.gitignoreSource [] ./.) {};
in
  shell-cmd
