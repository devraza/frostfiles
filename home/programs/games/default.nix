{
  pkgs,
  pkgs-stable,
  pkgs-master,
  inputs,
  ...
}:
let
in
{
  home.packages = with pkgs; [
    protonplus # windows compat
    obs-studio # game clips
    obs-cmd # OBS fix hotkeys
    mumble # voice chat
    osu-lazer-bin # osu!(mania)
    pkgs-stable.bottles # wine environment creation
    graalvmPackages.graalvm-ce # java runtime
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
