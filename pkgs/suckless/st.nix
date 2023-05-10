{pkgs, ...}: let
  sucklessPackage = import ./suckless_package.nix;
in
  sucklessPackage {
    inherit pkgs;
    name = "st";
    extraDeps = with pkgs; [
      xorg.libXft
      ncurses
    ];
    preBuild = ''
      export TERMINFO=$out/share/terminfo
      mkdir -p $TERMINFO
    '';
  }
