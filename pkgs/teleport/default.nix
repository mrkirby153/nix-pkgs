{
  callPackage,
  inputs,
  pkgs,
  ...
} @ args:
callPackage "${inputs.nixpkgs}/pkgs/servers/teleport/generic.nix" (rec {
    version = "17.0.1";
    hash = "sha256-4diE3rCwtESHU5JY13lNZBWxXrCeAKap7mPCpZVVg/0=";
    vendorHash = "sha256-n27T5DE3n7b16nDjNOFApcye5ofpW7ml3fL9A8MvspA=";
    pnpmHash = "sha256-irrPRPdfit0QJ+c90Rn7t7194gCcYJBBAFeBvsDOiSQ=";
    cargoLock = {
      lockFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/gravitational/teleport/v${version}/Cargo.lock";
        sha256 = "sha256:037fy5yybpldaawka4f8jdhzqs2irlyyg3fdz0vfzgwqqlrwpy22";
      };
      outputHashes = {
        "boring-4.7.0" = "sha256-ACzw4Bfo6OUrwvi3h21tvx5CpdQaWCEIDkslzjzy9o8=";
        "ironrdp-async-0.1.0" = "sha256-DOwDHavDaEda+JK9M6kbvseoXe2LxJg3MLTY/Nu+PN0=";
      };
    };
    wasm-bindgen-cli = pkgs.wasm-bindgen-cli.override {
      version = "0.2.93";
      hash = "sha256-DDdu5mM3gneraM85pAepBXWn3TMofarVR4NbjMdz3r0=";
      cargoHash = "sha256-birrg+XABBHHKJxfTKAMSlmTVYLmnmqMDfRnmG6g/YQ=";
    };
  }
  // builtins.removeAttrs args ["callPackage" "inputs" "pkgs"])
