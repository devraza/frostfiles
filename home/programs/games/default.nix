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
    steam-run # FHS environment
    proton-cachyos # steam windows compat
    aseprite # spriting
    vinegar # roblox studio
    vbam # GBA
  ];

  # benchmarking
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 4;
    };
  };
}
