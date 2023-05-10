{pkgs, ...}: let
  sucklessPackage = import ./suckless_package.nix;
in
  sucklessPackage {
    inherit pkgs;
    name = "dmenu";
    extraDeps = with pkgs; [
      xorg.libXinerama
    ];
  }
