{pkgs, inputs, ...}: 
with pkgs; {
  dmenu = callPackage ./suckless/dmenu.nix {};
  st = callPackage ./suckless/st.nix {};
  dwm = callPackage ./suckless/dwm.nix {};
  dwmblocks = callPackage ./suckless/dwmblocks.nix {};
  teleport = callPackage ./teleport { 
    inherit inputs;
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit CoreFoundation Security;
  };
}
