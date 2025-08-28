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
    proton-cachyos_x86_64_v3 # specialised proton
    (pkgs.tetrio-desktop.override{ withTetrioPlus = true; }) # tetris
    aseprite # spriting
    vinegar # roblox studio
    vbam # GBA
  ];

  xdg.desktopEntries = {
    "TETR.IO" = {
      name = "TETR.IO";
      exec = "tetrio -enable-features=UseOzonePlatform -ozone-platform=wayland";
    };
  };

  # benchmarking
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 3;
    };
  };
}
