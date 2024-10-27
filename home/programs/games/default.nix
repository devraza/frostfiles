{
  pkgs,
  pkgs-stable,
  hostName,
  inputs,
  ...
}:
let
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
    inputs.aagl-gtk-on-nix.packages.${pkgs.system}.an-anime-game-launcher
  ];

  # benchmarking
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 3;
    };
  };
}
