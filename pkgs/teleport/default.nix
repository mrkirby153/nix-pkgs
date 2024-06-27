{ callPackage, inputs, ... }@args:
callPackage "${inputs.nixpkgs}/pkgs/servers/teleport/generic.nix" (rec {
  version = "16.0.1";
  hash = "sha256-XTQwWV2tZ3JH2FyrRUlVJjeVH3rpq1My1LU6KtAIdfQ=";
  vendorHash = "sha256-fcnxy0pzrJqS3pYefuEQPO/4ziHUhHNXuBhuH0kaNjE=";
  yarnHash = "sha256-h478D+Ida/Gl7leljTi4XHzwugxU05TvNuylTv5Fc3U=";
  cargoLock = {
    lockFile = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/gravitational/teleport/v${version}/Cargo.lock";
      sha256 = "sha256:0777zldsx813b3yhckhpfgsdsz5syy8cxb162ps8d4w285zylfh9";
    };
    outputHashes = {
      "boring-4.4.0" = "sha256-4wdl2kIA5oHQ0H6IddKQ+B5kRwrTeMbKe1+tAYZt2uw=";
      "ironrdp-async-0.1.0" = "sha256-NpBzPsvopu5Te6Ljln5rp1Wxc6O6mRB4lLh0JVnN+Xc=";
      "sspi-0.10.1" = "sha256-fkclC/plTh2d8zcmqthYmr5yXqbPTeFxI1VuaPX5vxk=";
    };
  };
  extPatches = [
    "${inputs.nixpkgs}/pkgs/servers/teleport/tsh_14.patch"
  ];
} // builtins.removeAttrs args [ "callPackage" "inputs" ])
