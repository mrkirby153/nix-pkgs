{
  description = "Flake for my packages";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    flake-compat,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    packages.x86_64-linux = import ./pkgs {
      inherit pkgs;
      lib = pkgs.lib;
    };

    formatter.x86_64-linux = pkgs.alejandra;
  };
}
