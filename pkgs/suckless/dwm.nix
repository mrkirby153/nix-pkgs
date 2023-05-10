{pkgs, ...}: let
  sucklessPackage = import ./suckless_package.nix;
in
  sucklessPackage {
    inherit pkgs;
    name = "dwm";
    extraDeps = with pkgs; [
      xorg.libXinerama
    ];
  }
