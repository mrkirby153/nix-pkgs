{ callPackage, inputs, ... }@args:
callPackage ./generic.nix (rec {
  version = "15.1.10";
  hash = "sha256-XAjfHAHgwGV3QX9BnnPe2NamXrnjWFNK1sUMR+UdEao=";
  vendorHash = "sha256-SrAuGrLI25/d/4as/GlXO5mAfWMXvryaro16zHIq6K8=";
  yarnHash = "sha256-4XV2wlXbSiPSG0gGw1DguIEBxwpFyKHEyyC4s3ggsjs=";
  cargoLock = {
    lockFile = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/gravitational/teleport/v${version}/Cargo.lock";
      sha256 = "sha256:0x4x50gxx9wr9m35jb8jrkn2sglvh34qqa85j725sqxvliwxg4w1";
    };
    outputHashes = {
      "boring-4.4.0" = "sha256-4wdl2kIA5oHQ0H6IddKQ+B5kRwrTeMbKe1+tAYZt2uw=";
      "ironrdp-async-0.1.0" = "sha256-0p0A3OBsWryUyhsefqrrkUvPOzSMQ2q4DirE4bZNvIw=";
      "sspi-0.10.1" = "sha256-fkclC/plTh2d8zcmqthYmr5yXqbPTeFxI1VuaPX5vxk=";
    };
  };
  extPatches = [
    "${inputs.nixpkgs}/pkgs/servers/teleport/tsh_14.patch"
  ];
} // builtins.removeAttrs args [ "callPackage" "inputs" ])
