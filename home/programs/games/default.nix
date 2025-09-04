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
    lutris # library manager
    wineWowPackages.staging # windows compat
    protonup-ng # proton installer
    (pkgs.tetrio-desktop.override{ withTetrioPlus = true; }) # tetris
    osu-lazer-bin # osu!(mania)
    bottles # wine environment creation
    aseprite # spriting
    vinegar # roblox studio
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
