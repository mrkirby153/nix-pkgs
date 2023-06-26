{pkgs, inputs, ...}: 
with pkgs; {
  dmenu = callPackage ./suckless/dmenu.nix {};
  st = callPackage ./suckless/st.nix {};
  dwm = callPackage ./suckless/dwm.nix {};
  dwmblocks = callPackage ./suckless/dwmblocks.nix {};
  nvim = inputs.nvim.packages.${pkgs.stdenv.system}.default;
  teleport = callPackage ./teleport { inherit inputs;};
}
