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
    obs-studio # game clips
    obs-cmd # OBS fix hotkeys
    osu-lazer-bin # osu!(mania)
    bottles # wine environment creation
    prismlauncher # minecraft launcher
  ];
  # benchmarking
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 3;
    };
  };
}
