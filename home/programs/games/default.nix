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
    protonup-ng # proton
    (pkgs.tetrio-desktop.override{ withTetrioPlus = true; })
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
