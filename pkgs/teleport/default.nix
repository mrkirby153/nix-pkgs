{ callPackage, inputs, ... }@args:
callPackage ./generic.nix (rec {
  version = "15.0.2";
  hash = "sha256-xeDTaM2BuoSKff3WpBdkS5kBife5IGqLSK2wQQ1YqMo=";
  vendorHash = "sha256-L7ZHMR/1O0vRO11qKkpeRcosy0c9skE8+pWvT3vDb7M=";
  yarnHash = "sha256-mw00mLI0+wfz+easaY32RBgGt6DibImqT55VFrHK6dk=";
  cargoLock = {
    lockFile = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/gravitational/teleport/v${version}/Cargo.lock";
      sha256 = "sha256:0f6qc6pnd1m9rfqwfxd6x2yxz43g60578vx18c84fgixc5b497hx";
    };
    outputHashes = {
      "boring-4.4.0" = "sha256-4wdl2kIA5oHQ0H6IddKQ+B5kRwrTeMbKe1+tAYZt2uw=";
      "ironrdp-async-0.1.0" = "sha256-4XWrQtpZXNkGk9P+F1HcMYl6ZbAt/GPlpkIbfAH0xho=";
      "sspi-0.10.1" = "sha256-fkclC/plTh2d8zcmqthYmr5yXqbPTeFxI1VuaPX5vxk=";
    };
  };
  extPatches = [
    "${inputs.nixpkgs}/pkgs/servers/teleport/tsh_14.patch"
  ];
} // builtins.removeAttrs args [ "callPackage" "inputs" ])