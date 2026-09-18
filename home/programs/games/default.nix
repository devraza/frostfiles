{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}:
let
in
{
  home.packages = with pkgs; [
    protonplus # windows compat
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
