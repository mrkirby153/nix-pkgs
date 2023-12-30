{
  pkgs,
  name,
  extraDeps ? [],
  preBuild ? "",
  extraMeta ? {},
  ...
}: let
  inherit (pkgs) stdenv;
  repoBase = pkgs.fetchgit {
    url = "https://github.com/mrkirby153/suckless";
    rev = "6b47559e5203d30ef2197b5e70f77dd1ea0e4721";
    sha256 = "sha256-ygshrB+P/PLrB1aMetMa12HilwTHqQbd9xvH2qkaM9Q=";
    fetchSubmodules = true;
  };
in
  stdenv.mkDerivation rec {
    inherit name;
    src = "${repoBase}/${name}";
    buildInputs = with pkgs;
      [
        pkg-config
        xorg.libX11
        xorg.libXft
      ]
      ++ extraDeps;
    makeFlags = ["DESTDIR=$(out)" "PREFIX="];
    patchPhase = ''
      pushd source
      for patch in ../patches/*; do
        echo "Applying patch $patch"
        patch -p1 < $patch
      done
      popd
      if [ -f config.h ]; then
        echo "Copying configuration"
        cp config.h source/config.h
      fi
    '';
    buildPhase =
      preBuild
      + ''
        cd source
        make
      '';
    meta = with pkgs.lib;
      {
        license = licenses.mit;
        platforms = platforms.linux;
      }
      // extraMeta;
  }
