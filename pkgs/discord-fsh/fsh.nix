{
  pname,
  binaryName,
  desktopName,
  version,
  src,
  meta,
  callPackage,
  stdenv,
  buildFHSEnv,
  writeScript,
}: let
  package = callPackage ./raw.nix {
    inherit pname binaryName desktopName version src meta;
  };
in
  buildFHSEnv {
    name = "${pname}-fsh";

    targetPkgs = pkgs: (with pkgs; [
      libcxx
      systemd
      libpulseaudio
      libdrm
      mesa
      stdenv.cc.cc
      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libglvnd
      libnotify
      xorg.libX11
      xorg.libXcomposite
      libunity
      libuuid
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      nspr
      xorg.libxcb
      pango
      xorg.libXScrnSaver
      libappindicator-gtk3
      libdbusmenu
      wayland
      nss
      alsa-lib
      cups
      mesa
      libxkbcommon
    ]);
    runScript = writeScript "${binaryName}" ''
      #!${stdenv.shell}
      exec ${package}/opt/${binaryName}/${binaryName}
    '';
  }
