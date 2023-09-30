{
  inputs,
  outputs,
}: let
  inherit (inputs.nixpkgs.lib) mapAttrs filterAttrs elem;

  notBroken = pkg: !(pkg.meta.broken or false);
  hasPlatform = sys: pkg: elem sys (pkg.meta.platforms or []);
  filterValidPkgs = sys: pkgs: filterAttrs (_: pkg: hasPlatform sys pkg && notBroken pkg) pkgs;
in {
  pkgs = mapAttrs filterValidPkgs outputs.packages;
}
