{
  pkgs,
  inputs,
  ...
}:
with pkgs; rec {
  dmenu = callPackage ./suckless/dmenu.nix {};
  kometa = callPackage ./py/kometa.nix {};
  st = callPackage ./suckless/st.nix {};
  dwm = callPackage ./suckless/dwm.nix {};
  dwmblocks = callPackage ./suckless/dwmblocks.nix {};
  teleport_16 = callPackage ./teleport {
    inherit inputs;
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit CoreFoundation Security;
  };
  teleport = teleport_16;
  textual-autocomplete = callPackage ./py/textual-autocomplete.nix {};
  posting = callPackage ./py/posting.nix {};
}
