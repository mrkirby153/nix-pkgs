{
  description = "Flake for my packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nvim = {
      url = "github:mrkirby153/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nvim,
  }@inputs : let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    allPkgs = import ./pkgs { inherit pkgs; inherit inputs; };
    overlay = final: prev: {
      aus = allPkgs;
    };
  in {
    packages.x86_64-linux = allPkgs;

    apps.x86_64-linux = 
    let
      build-all = pkgs.callPackage ./apps/build_all.nix { inherit pkgs; };
    in {
      build-all = {
        type = "app";
        program = "${build-all}/bin/build_all.py";
      };
    };

    overlays.default = overlay;

    formatter.x86_64-linux = pkgs.alejandra;

    hydraJobs = import ./hydra.nix { inherit inputs; outputs = self.outputs; };
  };
}
