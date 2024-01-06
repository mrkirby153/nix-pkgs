{
  pkgs,
  inputs,
  ...
}:
with pkgs; {
  dmenu = callPackage ./suckless/dmenu.nix {};
  st = callPackage ./suckless/st.nix {};
  dwm = callPackage ./suckless/dwm.nix {};
  dwmblocks = callPackage ./suckless/dwmblocks.nix {};
  teleport = callPackage ./teleport {
    inherit inputs;
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit CoreFoundation Security;
  };
  discord-canary-fsh = callPackage ./discord-fsh {branch = "canary";};
  discord-ptb-fsh = callPackage ./discord-fsh {branch = "ptb";};
  discord-fsh = callPackage ./discord-fsh {};
}
