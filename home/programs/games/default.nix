{
  pkgs,
  pkgs-stable,
  pkgs-master,
  hostName,
  inputs,
  ...
}:
let
in
{
  home.packages = with pkgs; [
    cartridges # games library
    wineWowPackages.staging # windows compat
    protonup-ng # proton installer
    tetrio-desktop # tetris
    osu-lazer-bin # osu!(mania)
    bottles # wine environment creation
    vbam # GBA
  ];
  # benchmarking
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 3;
    };
  };
}
