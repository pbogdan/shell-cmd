let
  sources = import ./nix/sources.nix;
in
{ pkgs ? import sources.unstable { }
}:
let
  shell-cmd = import ./default.nix {
    inherit pkgs;
  };
in
pkgs.haskellPackages.shellFor {
  packages = _: [
    shell-cmd
  ];
  withHoogle = true;
}
