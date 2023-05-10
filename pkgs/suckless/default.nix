{pkgs}: let
  inherit (pkgs) callPackage;
in {
  dmenu = callPackage ./dmenu.nix {};
  st = callPackage ./st.nix {};
  dwm = callPackage ./dwm.nix {};
}
