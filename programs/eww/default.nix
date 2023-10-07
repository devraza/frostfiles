{ pkgs, config, ... }:

{
  programs.eww = {
    enable = true;
    configDir = ./config;
    package = pkgs.eww-wayland;
  };
}
