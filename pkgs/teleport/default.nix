{ callPackage, inputs, ... }@args:
callPackage "${inputs.nixpkgs}/pkgs/servers/teleport/generic.nix" ({
  version = "13.1.2";
  hash = "sha256-zKbxth4zGWKIJqi5VpAo3RunTdMMznwFKAxDcZ2C5Dk=";
  vendorHash = "sha256-YRQL4q/FFwmWTHWTEgK0ttoD7Xn1kJo0jk6P6rPLbBQ=";
  yarnHash = "sha256-KbCcdLeI2dkl5MAKgf9wVFvHEzpwTzfG8eX9/OhD3i0=";
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rdp-rs-0.1.0" = "sha256-n4x4w7GZULxqaR109das12+ZGU0xvY3wGOTWngcwe4M=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" "inputs" ])