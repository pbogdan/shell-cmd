let
  shell-cmd = (import ./default.nix {});
  sources = import ./nix/sources.nix;
  pkgs = (import sources.unstable {});
in pkgs.haskellPackages.shellFor {
  packages = _: [
    shell-cmd
  ];
  withHoogle = true;
}
