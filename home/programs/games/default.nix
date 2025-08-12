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
    protonup-ng # install proton-ge
    jdk21 # java
    steam-run # FHS environment
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
