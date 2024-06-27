{
  description = "Flake for my packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };
  outputs = {
    self,
    nixpkgs,
    flake-compat,
  } @ inputs: let
    pkgs = 
      import nixpkgs {
        system = "x86_64-linux";
        overlays = [];
      };

    allPkgs = import ./pkgs {
      inherit pkgs;
      inherit inputs;
    };
    overlay = final: prev: {
      aus = allPkgs;
    };
  in {
    packages.x86_64-linux = allPkgs;

    apps.x86_64-linux = let
      build-all = pkgs.callPackage ./apps/build_all.nix {inherit pkgs;};
    in {
      build-all = {
        type = "app";
        program = "${build-all}/bin/build_all.py";
      };
    };

    overlays.default = overlay;

    formatter.x86_64-linux = pkgs.alejandra;

    hydraJobs = import ./hydra.nix {
      inherit inputs;
      outputs = self.outputs;
    };

    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs; [nix-update];
    };
  };
}
