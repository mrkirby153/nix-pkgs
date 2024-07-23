{ callPackage, inputs, pkgs, ... }@args:
callPackage "${inputs.nixpkgs}/pkgs/servers/teleport/generic.nix" (rec {
  version = "16.1.0";
  hash = "sha256-uAyP2y2nbj9rxvWiKI/4SEOpOCozc/SRF0aHJMgQdhA=";
  vendorHash = "sha256-3N87rhzlpuLbLD4EIMDf6GABnAiLZJ+TSLapj90Z1zw=";
  yarnHash = "sha256-Q9b1Lmbl2elr7NMLjrTS21zssdZfeh5S1unaxjmGAxU=";
  cargoLock = {
    lockFile = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/gravitational/teleport/v${version}/Cargo.lock";
      sha256 = "sha256:175cvg7jpfz22a9ig0psjkgxxww8cm68cs76v2slga3x53l6g3lm";
    };
    outputHashes = {
      "boring-4.7.0" = "sha256-ACzw4Bfo6OUrwvi3h21tvx5CpdQaWCEIDkslzjzy9o8=";
      "ironrdp-async-0.1.0" = "sha256-nE5O/wRJ3vJqJG5zdYmpVkhx6JC6Yb92pR4EKSWSdkA=";
      "sspi-0.10.1" = "sha256-fkclC/plTh2d8zcmqthYmr5yXqbPTeFxI1VuaPX5vxk";
    };
  };
  wasm-bindgen-cli = pkgs.wasm-bindgen-cli.override {
    version = "0.2.92";
    hash = "sha256-1VwY8vQy7soKEgbki4LD+v259751kKxSxmo/gqE6yV0=";
    cargoHash = "sha256-aACJ+lYNEU8FFBs158G1/JG8sc6Rq080PeKCMnwdpH0=";
  };
} // builtins.removeAttrs args [ "callPackage" "inputs" "pkgs" ])
