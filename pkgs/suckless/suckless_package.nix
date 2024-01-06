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
    rev = "4d8b8f49a41bf47d5cb676e2326262d4da86f5d9";
    sha256 = "sha256-aLDDvU0oV0Uq38XKyqxBskmjicnOMIYmJmoiVmfy3hQ=";
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
