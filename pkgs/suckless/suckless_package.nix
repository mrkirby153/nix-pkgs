{
  pkgs,
  name,
  extraDeps ? [],
  preBuild ? "",
  ...
}: let
  inherit (pkgs) stdenv;
  repoBase = pkgs.fetchgit {
    url = "https://github.com/mrkirby153/suckless";
    rev = "3869be941aafc28c423f08d373747c0b792574ef";
    sha256 = "sha256-gEOUNTmJhvkDN9Gr9jP+QaEGM6hfONa+y4XjE7P+1FY=";
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
  }
