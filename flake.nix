{
  description = "Flake for my packages";

  inputs = {
    nixpkgs.url = "nixpkgs";
    nvim = {
      url = "github:mrkirby153/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nvim,
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    myPkgs = import ./pkgs {
      inherit pkgs;
      lib = pkgs.lib;
    };
    getLeaves = (
      attrset: let
        values = pkgs.lib.attrValues attrset;
        isLeaf = (v: (pkgs.lib.attrsets.isDerivation v));
        leaves = pkgs.lib.filter isLeaf values;
        nonLeaves = pkgs.lib.filter (v: (pkgs.lib.isAttrs v) && ! (pkgs.lib.attrsets.isDerivation v)) values;
        nonLeavesLeaves = builtins.map (attr: getLeaves attr) nonLeaves;
      in
        pkgs.lib.concatLists [leaves (pkgs.lib.concatLists nonLeavesLeaves)]
    );
    allPkgs = builtins.listToAttrs (builtins.map (pkg: pkgs.lib.nameValuePair pkg.name pkg) (getLeaves myPkgs)) // {
      nvim = nvim.packages.x86_64-linux.default;
    };
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
  };
}
