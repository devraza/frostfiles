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
  ];

  # benchmarking
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 3;
    };
  };
}
