{
  branch ? "stable",
  callPackage,
  fetchurl,
  lib,
  stdenv,
}: let
  versions = {
    stable = "0.0.39";
    ptb = "0.0.64";
    canary = "0.0.235";
    development = "0.0.1";
  };
  version = versions.${branch};

  srcs = {
    stable = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      hash = "sha256-KZLKBzd9hdOQkp7mN0rUZ8TbMvH2G0/AfwHPLAlDpug=";
    };
    ptb = fetchurl {
      url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
      hash = "sha256-loA/RdT6Y5c6Upius+vO/383FrutsJEYS/1uiR0gfqo=";
    };
    canary = fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      hash = "sha256-FRRTI6CHcJQW+fwOEOScQb4C5ADoONtckrrQHWyJass=";
    };
  };

  src = srcs.${branch};

  meta = with lib; {
    description = "All-in-oine cross-platform voice and text chat for gamers";
    homepage = "https://discord.com";
    downloadPage = ["https://discord.com/download"];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    mainProgram = "discord";
  };

  packages = (
    builtins.mapAttrs
    (_: value:
      callPackage ./fsh.nix (value
        // {
          inherit src version;
          meta = meta // {mainProgram = value.binaryName;};
        }))
    {
      stable = {
        pname = "discord";
        binaryName = "Discord";
        desktopName = "Discord";
      };
      ptb = rec {
        pname = "discord-ptb";
        binaryName =
          if stdenv.isLinux
          then "DiscordPTB"
          else desktopName;
        desktopName = "Discord PTB";
      };
      canary = rec {
        pname = "discord-canary";
        binaryName =
          if stdenv.isLinux
          then "DiscordCanary"
          else desktopName;
        desktopName = "Discord Canary";
      };
      development = rec {
        pname = "discord-development";
        binaryName =
          if stdenv.isLinux
          then "DiscordDevelopment"
          else desktopName;
        desktopName = "Discord Development";
      };
    }
  );
in
  packages.${branch}
