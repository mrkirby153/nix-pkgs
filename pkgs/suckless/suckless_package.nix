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
    rev = "36ad933aee0560233571937a4566c5489c449e4d";
    sha256 = "sha256-HZCHpqrbbmeJx1AtE119QasSAu5EmFfUR8300NMO7jU=";
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
