{
  pkgs,
  pkgs-stable,
  hostName,
  ...
}:
let
  aagl-gtk-on-nix = import (builtins.fetchTarball "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz");
in
{
  home.packages = with pkgs; [
    lutris # library manager
    wineWowPackages.staging # windows compat
    protonup-ng # install proton-ge
    jdk21 # java
    osu-lazer-bin # osu!
    steam
    steam-run # FHS environment
    aagl-gtk-on-nix.an-anime-game-launcher
  ];

  # benchmarking
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 3;
    };
  };
}
