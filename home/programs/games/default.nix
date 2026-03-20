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
    protonplus # windows compat
    obs-studio # game clips
    obs-cmd # OBS fix hotkeys
    mumble # voice chat
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
