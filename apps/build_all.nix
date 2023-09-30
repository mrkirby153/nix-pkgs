{pkgs ? (import ../nixpkgs.nix) {}, ...}:
pkgs.stdenv.mkDerivation {
  name = "build-all";
  src = ./.;
  type = "app";
  buildInputs = [pkgs.python3 pkgs.git];
  installPhase = ''
    mkdir -p $out/bin
    cp build_all.py $out/bin
    chmod +x $out/bin/build_all.py
  '';
}
