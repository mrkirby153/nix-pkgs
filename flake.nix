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
  in {
    packages.x86_64-linux =
      myPkgs
      // {
        _all = pkgs.symlinkJoin {
          name = "all";
          paths = (getLeaves myPkgs);
        };
      };

    formatter.x86_64-linux = pkgs.alejandra;
  };
}
